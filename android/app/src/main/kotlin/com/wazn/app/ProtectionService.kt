package com.wazn.app

import android.app.AppOpsManager
import android.app.Service
import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.usage.UsageEvents
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.graphics.PixelFormat
import android.os.Build
import android.os.Handler
import android.os.IBinder
import android.os.Looper
import android.os.Process
import android.provider.Settings
import android.view.Gravity
import android.view.WindowManager
import android.widget.Button
import android.widget.LinearLayout
import android.widget.TextView
import java.text.SimpleDateFormat
import java.util.Calendar
import java.util.Date
import java.util.Locale

/** User-started, visible, best-effort monitor. This is not tamper-proof parental control. */
class ProtectionService : Service() {
    private val handler = Handler(Looper.getMainLooper())
    private var overlay: LinearLayout? = null
    private var foreground: String? = null
    private var cursor = 0L
    private var day = ""
    private var usedMillis = 0L
    private var lastTick = 0L
    private var sampleCount = 0
    private val prefs by lazy { getSharedPreferences("wazn.protection", Context.MODE_PRIVATE) }
    private val wm by lazy { getSystemService(Context.WINDOW_SERVICE) as WindowManager }

    override fun onBind(intent: Intent?): IBinder? = null
    override fun onCreate() {
        super.onCreate()
        createNotification()
        running = true
        val now = System.currentTimeMillis()
        resetForDay(now)
        // Recover today's usage after process death/reboot, rather than granting a fresh quota.
        recoverUsage(now)
        lastTick = now
        handler.post(tick)
    }

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        if (intent?.action == "STOP") {
            prefs.edit().putBoolean("enabled", false).putBoolean("userStopped", true).apply()
            stopSelf()
            return START_NOT_STICKY
        }
        return START_STICKY
    }

    private fun dateKey(now: Long) = SimpleDateFormat("yyyy-MM-dd", Locale.US).format(Date(now))
    private fun midnight(now: Long): Long = Calendar.getInstance().apply {
        timeInMillis = now
        set(Calendar.HOUR_OF_DAY, 0); set(Calendar.MINUTE, 0)
        set(Calendar.SECOND, 0); set(Calendar.MILLISECOND, 0)
    }.timeInMillis

    private fun resetForDay(now: Long) {
        val today = dateKey(now)
        if (day == today) return
        day = today
        usedMillis = if (prefs.getString("date", "") == today) prefs.getLong("usedMillis", 0) else 0
        prefs.edit().putString("date", today).putLong("usedMillis", usedMillis).apply()
        cursor = midnight(now)
    }

    private fun recoverUsage(now: Long) {
        val selected = prefs.getStringSet("packages", emptySet()) ?: emptySet()
        val start = midnight(now)
        // Start a day earlier to recover the foreground app spanning midnight.
        val events = (getSystemService(USAGE_STATS_SERVICE) as UsageStatsManager)
            .queryEvents(start - 86400000L, now)
        val event = UsageEvents.Event()
        var active: String? = null
        var activeAt = start
        var total = 0L
        while (events.hasNextEvent()) {
            events.getNextEvent(event)
            if (event.eventType == UsageEvents.Event.MOVE_TO_FOREGROUND) {
                if (active in selected) total += (event.timeStamp - activeAt).coerceAtLeast(0)
                active = event.packageName
                activeAt = event.timeStamp.coerceAtLeast(start)
            } else if (event.eventType == UsageEvents.Event.MOVE_TO_BACKGROUND && active == event.packageName) {
                if (active in selected) total += (event.timeStamp - activeAt).coerceAtLeast(0)
                active = null
                activeAt = event.timeStamp.coerceAtLeast(start)
            } else if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.P &&
                event.eventType == UsageEvents.Event.SCREEN_NON_INTERACTIVE) {
                if (active in selected) total += (event.timeStamp - activeAt).coerceAtLeast(0)
                active = null
                activeAt = event.timeStamp.coerceAtLeast(start)
            }
        }
        if (active in selected) total += (now - activeAt).coerceAtLeast(0)
        usedMillis = maxOf(usedMillis, total)
        foreground = active
        cursor = now
        persist()
    }

    private val tick = object : Runnable {
        override fun run() {
            val now = System.currentTimeMillis()
            if (!prefs.getBoolean("enabled", false) || !hasUsage(this@ProtectionService) || !Settings.canDrawOverlays(this@ProtectionService)) {
                hideOverlay()
                stopSelf()
                return
            }
            try {
                val rolled = day != dateKey(now)
                resetForDay(now)
                if (rolled) {
                    // Native reset works even while the Flutter app is closed.
                    prefs.edit().putLong("budgetSeconds", prefs.getLong("dailySeconds", 2700)).apply()
                    recoverUsage(now)
                    lastTick = now
                }
                val events = (getSystemService(USAGE_STATS_SERVICE) as UsageStatsManager).queryEvents(cursor, now)
                val selected = prefs.getStringSet("packages", emptySet()) ?: emptySet()
                val event = UsageEvents.Event()
                var at = lastTick
                while (events.hasNextEvent()) {
                    events.getNextEvent(event)
                    val time = event.timeStamp.coerceIn(at, now)
                    if (foreground in selected && overlay == null) usedMillis += time - at
                    at = time
                    when {
                        event.eventType == UsageEvents.Event.MOVE_TO_FOREGROUND -> foreground = event.packageName
                        event.eventType == UsageEvents.Event.MOVE_TO_BACKGROUND && foreground == event.packageName -> foreground = null
                        Build.VERSION.SDK_INT >= Build.VERSION_CODES.P && event.eventType == UsageEvents.Event.SCREEN_NON_INTERACTIVE -> foreground = null
                    }
                }
                val power = getSystemService(POWER_SERVICE) as android.os.PowerManager
                if (foreground in selected && overlay == null && power.isInteractive) usedMillis += now - at
                lastTick = now
                cursor = now
                if (foreground in selected && usedMillis / 1000 >= prefs.getLong("budgetSeconds", 2700)) showOverlay()
                else hideOverlay()
                if (++sampleCount % 5 == 0) persist()
                usedSeconds = usedMillis / 1000
            } catch (_: Exception) {
                // Permission revocation or OEM failures must never trap the user behind an overlay.
                hideOverlay()
                stopSelf()
                return
            }
            handler.postDelayed(this, 1000)
        }
    }

    private fun persist() {
        usedSeconds = usedMillis / 1000
        prefs.edit().putString("date", day).putLong("usedMillis", usedMillis).apply()
    }

    private fun showOverlay() {
        if (overlay != null) return
        val box = LinearLayout(this).apply {
            orientation = LinearLayout.VERTICAL
            gravity = Gravity.CENTER
            setPadding(40, 40, 40, 40)
            setBackgroundColor(0xff07241f.toInt())
            addView(TextView(context).apply {
                text = "انتهى رصيد التصفح\nافتح وزن لإتمام وردك أو لاستخدام الطوارئ."
                textSize = 24f; setTextColor(0xfffbf7ee.toInt()); gravity = Gravity.CENTER
            })
            addView(Button(context).apply {
                text = "افتح وزن"
                setOnClickListener {
                    hideOverlay()
                    startActivity(Intent(this@ProtectionService, MainActivity::class.java).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_SINGLE_TOP))
                }
            })
            addView(Button(context).apply {
                text = "الشاشة الرئيسية"
                setOnClickListener {
                    hideOverlay()
                    startActivity(Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_HOME).addFlags(Intent.FLAG_ACTIVITY_NEW_TASK))
                }
            })
        }
        val type = if (Build.VERSION.SDK_INT >= 26) WindowManager.LayoutParams.TYPE_APPLICATION_OVERLAY else @Suppress("DEPRECATION") WindowManager.LayoutParams.TYPE_PHONE
        wm.addView(box, WindowManager.LayoutParams(WindowManager.LayoutParams.MATCH_PARENT, WindowManager.LayoutParams.MATCH_PARENT, type,
            WindowManager.LayoutParams.FLAG_LAYOUT_IN_SCREEN, PixelFormat.TRANSLUCENT))
        overlay = box
    }

    private fun hideOverlay() {
        overlay?.let { try { wm.removeView(it) } catch (_: Exception) {} }
        overlay = null
    }

    private fun createNotification() {
        val nm = getSystemService(NOTIFICATION_SERVICE) as NotificationManager
        if (Build.VERSION.SDK_INT >= 26) nm.createNotificationChannel(NotificationChannel("protection", "حماية وقتك", NotificationManager.IMPORTANCE_LOW))
        val open = PendingIntent.getActivity(this, 1, Intent(this, MainActivity::class.java), PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT)
        val stop = PendingIntent.getService(this, 2, Intent(this, ProtectionService::class.java).setAction("STOP"), PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT)
        val builder = if (Build.VERSION.SDK_INT >= 26) Notification.Builder(this, "protection") else @Suppress("DEPRECATION") Notification.Builder(this)
        startForeground(22, builder.setSmallIcon(android.R.drawable.ic_lock_idle_alarm).setContentTitle("وزن يحمي وقتك")
            .setContentText("مراقبة التطبيقات المحددة مفعّلة. يمكنك إيقافها هنا.")
            .setContentIntent(open).setOngoing(true).addAction(Notification.Action.Builder(null, "إيقاف", stop).build()).build())
    }

    override fun onDestroy() {
        handler.removeCallbacks(tick)
        hideOverlay()
        persist()
        running = false
        super.onDestroy()
    }

    companion object {
        @Volatile var running = false
        @Volatile var usedSeconds = 0L
        fun hasUsage(context: Context): Boolean {
            val ops = context.getSystemService(APP_OPS_SERVICE) as AppOpsManager
            @Suppress("DEPRECATION")
            return ops.checkOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS, Process.myUid(), context.packageName) == AppOpsManager.MODE_ALLOWED
        }
    }
}
