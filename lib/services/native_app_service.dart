import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/selectable_app.dart';

class NativeAppService {
  static const MethodChannel _channel = MethodChannel('com.wazn.app/native');
  static final NativeAppService instance = NativeAppService._();

  NativeAppService._();

  List<SelectableApp>? _cachedInstalledApps;

  /// جلب التطبيقات المثبتة على الجهاز مع أيقوناتها الحقيقية
  Future<List<SelectableApp>> getInstalledApps(
      {bool forceRefresh = false}) async {
    if (_cachedInstalledApps != null && !forceRefresh) {
      return _cachedInstalledApps!;
    }

    final List<SelectableApp> deviceApps = [];

    // على أندرويد نحاول القراءة المباشرة عبر Platform Channel
    if (!kIsWeb && Platform.isAndroid) {
      try {
        final List<dynamic>? res =
            await _channel.invokeMethod('getInstalledApps');
        if (res != null) {
          for (final raw in res) {
            if (raw is Map) {
              final map = Map<String, dynamic>.from(raw);
              final id = (map['packageName'] ?? map['id'] ?? '').toString();
              final name = (map['name'] ?? id).toString();
              final isQuran =
                  map['isQuranApp'] == true || _checkIfQuran(name, id);
              final rawIcon = map['iconBytes'];
              Uint8List? iconBytes;
              if (rawIcon is Uint8List) {
                iconBytes = rawIcon;
              } else if (rawIcon is List) {
                iconBytes = Uint8List.fromList(rawIcon.cast<int>());
              }

              deviceApps.add(SelectableApp(
                id: id,
                name: name,
                packageName: id,
                iconBytes: iconBytes,
                isInstalled: true,
                isQuranApp: isQuran,
                category:
                    isQuran ? AppCategory.quran : _guessCategory(name, id),
              ));
            }
          }
        }
      } catch (e) {
        debugPrint(
            'Wazn: Error querying installed apps via Native Channel: $e');
      }
    }

    // ندمج التطبيقات المثبتة مع التطبيقات الشائعة المقترحة لضمان وجود أيقونات تيك توك وفيسبوك والقرآن دائماً
    final Map<String, SelectableApp> merged = {};

    // 1. أضف التطبيقات الشائعة الأساسية
    for (final def in SelectableApp.defaultDistractingApps) {
      merged[def.id] = def;
    }

    // 2. أضف تطبيقات الجهاز المثبتة (تتطابق مع الشائعة أو تضاف كجديدة)
    for (final dev in deviceApps) {
      // هل يطابق تطبيقاً شائعاً بالمعرّف أو الـ package name؟
      final matchedKey = merged.keys.firstWhere(
        (k) =>
            merged[k]?.packageName?.toLowerCase() ==
                dev.packageName?.toLowerCase() ||
            k.toLowerCase() == dev.name.toLowerCase(),
        orElse: () => '',
      );

      if (matchedKey.isNotEmpty) {
        // تحديث التطبيق الشائع بالأيقونة الحقيقية والاسم الفعلي المثبت
        merged[matchedKey] = merged[matchedKey]!.copyWith(
          name: dev.name,
          iconBytes: dev.iconBytes,
          isInstalled: true,
          packageName: dev.packageName,
        );
      } else {
        merged[dev.id] = dev;
      }
    }

    _cachedInstalledApps = merged.values.toList();
    return _cachedInstalledApps!;
  }

  /// جلب تطبيقات القرآن الكريم الموجودة على الجهاز أو المقترحة
  Future<List<SelectableApp>> getQuranApps() async {
    final all = await getInstalledApps();
    final deviceQuran =
        all.where((a) => a.isQuranApp || _checkIfQuran(a.name, a.id)).toList();

    // ندمج أيضاً قائمة تطبيقات القرآن الشائعة مع تطبيقات الجهاز
    final Map<String, SelectableApp> map = {};
    for (final def in SelectableApp.defaultQuranApps) {
      map[def.id] = def;
    }

    for (final q in deviceQuran) {
      final matchedKey = map.keys.firstWhere(
        (k) =>
            map[k]?.packageName?.toLowerCase() ==
                q.packageName?.toLowerCase() ||
            q.name.contains(map[k]?.name ?? '###'),
        orElse: () => '',
      );
      if (matchedKey.isNotEmpty) {
        map[matchedKey] = map[matchedKey]!.copyWith(
          name: q.name,
          iconBytes: q.iconBytes,
          isInstalled: true,
          packageName: q.packageName,
        );
      } else {
        map[q.id] = q;
      }
    }

    return map.values.toList();
  }

  /// فتح تطبيق خارجي (تطبيق قرآني أو تطبيق مشتت)
  Future<bool> launchApp(String idOrPackage) async {
    if (kIsWeb) return false;
    try {
      final res = await _channel
          .invokeMethod<bool>('launchApp', {'package': idOrPackage});
      return res ?? false;
    } catch (e) {
      debugPrint('Wazn: launchApp error: $e');
      return false;
    }
  }

  /// فحص إذن إحصاءات الاستخدام
  Future<bool> hasUsagePermission() async {
    if (kIsWeb || !Platform.isAndroid) return true;
    try {
      final res = await _channel.invokeMethod<bool>('hasUsagePermission');
      return res ?? false;
    } catch (_) {
      return false;
    }
  }

  /// فتح شاشة تفعيل إذن الاستخدام
  Future<void> openUsageSettings() async {
    if (kIsWeb || !Platform.isAndroid) return;
    try {
      await _channel.invokeMethod('openUsageSettings');
    } catch (e) {
      debugPrint('Wazn: openUsageSettings error: $e');
    }
  }

  /// فحص إذن العرض فوق التطبيقات (النافذة العائمة للحظر)
  Future<bool> hasOverlayPermission() async {
    if (kIsWeb || !Platform.isAndroid) return true;
    try {
      final res = await _channel.invokeMethod<bool>('hasOverlayPermission');
      return res ?? false;
    } catch (_) {
      return false;
    }
  }

  /// فتح شاشة تفعيل إذن الظهور فوق التطبيقات
  Future<void> openOverlaySettings() async {
    if (kIsWeb || !Platform.isAndroid) return;
    try {
      await _channel.invokeMethod('openOverlaySettings');
    } catch (e) {
      debugPrint('Wazn: openOverlaySettings error: $e');
    }
  }

  /// الحصول على تمثيل SelectableApp من معرّف أو اسم حزمة
  Future<SelectableApp> resolveApp(String idOrPackage) async {
    final all = await getInstalledApps();
    final found = all.firstWhere(
      (a) => a.id == idOrPackage || a.packageName == idOrPackage,
      orElse: () {
        // فحص في الافتراضيات
        final def = SelectableApp.defaultDistractingApps.firstWhere(
          (d) => d.id == idOrPackage || d.packageName == idOrPackage,
          orElse: () => SelectableApp.defaultQuranApps.firstWhere(
            (q) => q.id == idOrPackage || q.packageName == idOrPackage,
            orElse: () => SelectableApp(
              id: idOrPackage,
              name: _cleanName(idOrPackage),
              packageName: idOrPackage,
              category: AppCategory.other,
            ),
          ),
        );
        return def;
      },
    );
    return found;
  }

  static bool _checkIfQuran(String name, String pkg) {
    final low = '${name.toLowerCase()} ${pkg.toLowerCase()}';
    return low.contains('quran') ||
        low.contains('mushaf') ||
        low.contains('قرآن') ||
        low.contains('قران') ||
        low.contains('مصحف') ||
        low.contains('ayat') ||
        low.contains('آيات') ||
        low.contains('ايات') ||
        low.contains('تلاوة') ||
        low.contains('tafsir') ||
        low.contains('تفسير') ||
        low.contains('islam');
  }

  static AppCategory _guessCategory(String name, String pkg) {
    final low = '${name.toLowerCase()} ${pkg.toLowerCase()}';
    if (low.contains('social') ||
        low.contains('chat') ||
        low.contains('messenger') ||
        low.contains('talk')) {
      return AppCategory.social;
    }
    if (low.contains('game') ||
        low.contains('video') ||
        low.contains('media')) {
      return AppCategory.entertainment;
    }
    return AppCategory.other;
  }

  static String _cleanName(String raw) {
    if (!raw.contains('.')) return raw;
    final parts = raw.split('.');
    return parts.last;
  }
}
