package com.wazn.app

import android.app.AppOpsManager
import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.AdaptiveIconDrawable
import android.graphics.drawable.BitmapDrawable
import android.graphics.drawable.Drawable
import android.net.Uri
import android.os.Build
import android.os.Process
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream
import java.util.concurrent.Executors

class MainActivity : FlutterActivity() {
    private val CHANNEL = "com.wazn.app/native"
    private val executor = Executors.newSingleThreadExecutor()

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getInstalledApps" -> {
                    executor.execute {
                        try {
                            val apps = queryInstalledApps()
                            runOnUiThread {
                                result.success(apps)
                            }
                        } catch (e: Exception) {
                            runOnUiThread {
                                result.error("ERROR", e.message, null)
                            }
                        }
                    }
                }

                "launchApp" -> {
                    val pkg = call.argument<String>("package")
                    if (pkg.isNullOrEmpty()) {
                        result.success(false)
                        return@setMethodCallHandler
                    }
                    try {
                        val launchIntent = packageManager.getLaunchIntentForPackage(pkg)
                        if (launchIntent != null) {
                            launchIntent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                            startActivity(launchIntent)
                            result.success(true)
                        } else {
                            // محاولة فتحه كرابط أو في المتجر
                            val marketIntent = Intent(Intent.ACTION_VIEW, Uri.parse("market://details?id=$pkg")).apply {
                                addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                            }
                            startActivity(marketIntent)
                            result.success(true)
                        }
                    } catch (e: Exception) {
                        result.success(false)
                    }
                }

                "hasUsagePermission" -> {
                    result.success(checkUsageStatsPermission())
                }

                "openUsageSettings" -> {
                    try {
                        val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS).apply {
                            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        }
                        startActivity(intent)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("ERROR", e.message, null)
                    }
                }

                "hasOverlayPermission" -> {
                    result.success(Settings.canDrawOverlays(this))
                }

                "openOverlaySettings" -> {
                    try {
                        val intent = Intent(
                            Settings.ACTION_MANAGE_OVERLAY_PERMISSION,
                            Uri.parse("package:$packageName")
                        ).apply {
                            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                        }
                        startActivity(intent)
                        result.success(true)
                    } catch (e: Exception) {
                        result.error("ERROR", e.message, null)
                    }
                }

                else -> result.notImplemented()
            }
        }
    }

    private fun checkUsageStatsPermission(): Boolean {
        return try {
            val appOps = getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
            val mode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
                appOps.unsafeCheckOpNoThrow(
                    AppOpsManager.OPSTR_GET_USAGE_STATS,
                    Process.myUid(),
                    packageName
                )
            } else {
                appOps.checkOpNoThrow(
                    AppOpsManager.OPSTR_GET_USAGE_STATS,
                    Process.myUid(),
                    packageName
                )
            }
            mode == AppOpsManager.MODE_ALLOWED
        } catch (e: Exception) {
            false
        }
    }

    private fun queryInstalledApps(): List<Map<String, Any?>> {
        val pm = packageManager
        val intent = Intent(Intent.ACTION_MAIN, null).apply {
            addCategory(Intent.CATEGORY_LAUNCHER)
        }

        val resolveInfos = pm.queryIntentActivities(intent, 0)
        val list = mutableListOf<Map<String, Any?>>()
        val seen = mutableSetOf<String>()

        for (ri in resolveInfos) {
            val pkg = ri.activityInfo.packageName ?: continue
            if (pkg == packageName || seen.contains(pkg)) continue
            seen.add(pkg)

            val label = ri.loadLabel(pm).toString()
            val iconDrawable = try {
                ri.loadIcon(pm)
            } catch (e: Exception) {
                null
            }

            val iconBytes = iconDrawable?.let { drawableToByteArray(it) }
            val isQuran = isQuranRelated(label, pkg)

            list.add(
                mapOf(
                    "id" to pkg,
                    "packageName" to pkg,
                    "name" to label,
                    "iconBytes" to iconBytes,
                    "isQuranApp" to isQuran
                )
            )
        }

        // ترتيب أبجدي
        list.sortBy { (it["name"] as? String)?.lowercase() ?: "" }
        return list
    }

    private fun drawableToByteArray(drawable: Drawable): ByteArray? {
        return try {
            val width = when {
                drawable.intrinsicWidth > 0 -> drawable.intrinsicWidth.coerceIn(48, 144)
                else -> 96
            }
            val height = when {
                drawable.intrinsicHeight > 0 -> drawable.intrinsicHeight.coerceIn(48, 144)
                else -> 96
            }

            val bitmap = Bitmap.createBitmap(width, height, Bitmap.Config.ARGB_8888)
            val canvas = Canvas(bitmap)
            drawable.setBounds(0, 0, canvas.width, canvas.height)
            drawable.draw(canvas)

            val stream = ByteArrayOutputStream()
            bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
            val bytes = stream.toByteArray()
            bitmap.recycle()
            bytes
        } catch (e: Exception) {
            null
        }
    }

    private fun isQuranRelated(name: String, pkg: String): Boolean {
        val keywords = listOf(
            "quran", "mushaf", "koran", "quraan", "ayah", "ayat", "tafsir",
            "تفسير", "قرآن", "قران", "مصحف", "آيات", "ايات", "تلاوة", "اذكار", "أذكار", "muslim"
        )
        val text = "${name.lowercase()} ${pkg.lowercase()}"
        return keywords.any { text.contains(it) }
    }
}
