<div align="center">

<img src="https://img.shields.io/badge/Flutter-3.4+-02569B?logo=flutter&logoColor=white" alt="Flutter">
<img src="https://img.shields.io/badge/Dart-3.4+-0175C2?logo=dart&logoColor=white" alt="Dart">
<img src="https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web-0E3A31" alt="Platforms">
<img src="https://img.shields.io/badge/Language-Arabic%20RTL-E9C46A" alt="Arabic">
<img src="https://img.shields.io/badge/Offline-First-1F6B5C" alt="Offline">

<h1>⚖️ وزن — Wazn</h1>

<p><strong>اجعل وقتك يزن أكثر</strong></p>

<p>تطبيق عربي يحوّل وقت التمرير إلى وردٍ وذكر.<br>
يحظر التطبيقات المُشتِّتة بعد حدٍّ يومي، ولا يُفتح القفل إلا بإتمام ورد قراءة أو أذكار.</p>

</div>

---

## ✨ الفكرة

> كل دقيقة تقرأها = ٣ دقائق تصفح. وقتك يستحق أن **يزن**.

بدلاً من تطبيقات الحظر الصارمة، يقدّم «وزن» مقايضة عادلة: تُعطي ورداً (قرآن، أذكار، تدبّر)، فتحصل على وقت تصفح. يعمل المصحف والأذكار والتفسير وحديث اليوم **بلا إنترنت** تماماً.

---

## 🎨 الهوية البصرية

| اللون | القيمة | الاستخدام |
|------|--------|-----------|
| زمرد الليل | `#07241F` | خلفيات داكنة |
| زمرد | `#0E3A31` | الأساسي |
| أخضر الواحة | `#1F6B5C` | العناصر النشطة |
| ذهب | `#E9C46A` | الإجراء الرئيسي |
| ذهب عتيق | `#D4A24C` | التدرجات |
| رمل | `#FBF7EE` | الخلفية الفاتحة |
| رمل دافئ | `#F1E9D8` | البطاقات |
| حبر | `#10251F` | النصوص |

**الخطوط:** Aref Ruqaa (الشعار) · IBM Plex Sans Arabic (الواجهة) · Amiri (المصحف والأحاديث والأذكار).

---

## 📱 الشاشات (25)

| # | الشاشة | الملف |
|---|--------|-------|
| ١ | البداية | `splash_screen.dart` |
| ٢ | الإعداد — التطبيقات | `onboarding_apps_screen.dart` |
| ٣ | الإعداد — الافتراضيات | `onboarding_defaults_screen.dart` |
| ٤ | الرئيسية | `home_screen.dart` |
| ٥ | الحظر والتأجيل | `block_screen.dart` |
| ٦ | التنبيه والويدجت | `pre_block_alert_screen.dart` |
| ٧ | تم فك القفل | `unlocked_screen.dart` |
| ٨ | المصحف | `worship_screen.dart` |
| ٩ | الأذكار | `adhkar_screen.dart` |
| ١٠ | عدّاد التسبيح | `dhikr_counter_screen.dart` |
| ١١ | القراءة والتفسير | `reading_screen.dart` |
| ١٢ | الإحصاءات | `stats_screen.dart` |
| ١٣ | الإعدادات | `settings_screen.dart` |
| ١٤ | نية الفتح | `open_intent_screen.dart` |
| ١٥ | الحظر التدريجي | `gradual_block_screen.dart` |
| ١٦ | أحتاجه الآن | `emergency_screen.dart` |
| ١٧ | التدبّر | `reflection_screen.dart` |
| ١٨ | شريك المساءلة | `accountability_screen.dart` |
| ١٩ | الإذن غير مفعّل | `permission_screen.dart` |

---

## 🚀 التشغيل

```bash
# 1. تثبيت الحزم
flutter pub get

# 2. التشغيل على أندرويد أو سطح المكتب
flutter run

# 3. على الويب
flutter run -d chrome

# 4. بناء APK
flutter build apk --release
```

> **المتطلبات:** Flutter 3.4+ · Dart 3.4+

---

## 🏗️ المعمارية

```
lib/
├── main.dart              # نقطة الدخول + RTL + Provider
├── theme/                 # الألوان والثيم والخطوط
│   ├── wazn_colors.dart
│   └── wazn_theme.dart
├── models/                # النماذج (Ayah, Dhikr, Hadith…)
├── data/
│   ├── app_state.dart     # الحالة المركزية (ChangeNotifier)
│   ├── local_store.dart   # تخزين محلي (SharedPreferences)
│   └── seed_*.dart        # بيانات مضمّنة تعمل بلا إنترنت
├── widgets/               # مكوّنات مشتركة (زر، بطاقة، شريط سفلي…)
└── screens/               # 20 شاشة
```

**المبدأ:** كل شاشة تتحدث مع `AppState` فقط، و`AppState` يقرأ من `LocalStore` قبل أي شبكة. وحدات Kotlin/Swift الأصلية ستُضاف لاحقاً لقراءة وقت الاستخدام الحقيقي.

---

## 📦 ما يعمل بلا إنترنت

- ✅ المصحف والتفسير (عيّنة مضمّنة، قابلة للتوسيع)
- ✅ الأذكار وعدّاد التسبيح
- ✅ حديث اليوم
- ✅ السلسلة والإحصاءات والرصيد
- ⚠️ مواقيت الصلاة والصوت: تحتاج شبكة (مرحلة لاحقة)

---

## 🔮 الخطوة التالية

- [ ] استبدال عيّنة المصحف بأرشيف كامل (spa5k/tafsir_api)
- [ ] وحدة Kotlin (UsageStats) للقراءة الفعلية لوقت الاستخدام
- [ ] وحدة Swift (Screen Time / FamilyControls) لآيفون
- [ ] صوت التلاوة مع التحميل المسبق للاستماع بلا إنترنت
- [ ] شريك المساءلة مع خادم صغير

---

## 📄 الترخيص

MIT © [Adham AbuElenin](https://github.com/domz-1)

<div align="center"><sub>صُنع بعناية — اجعل وقتك يزن أكثر ⚖️</sub></div>
