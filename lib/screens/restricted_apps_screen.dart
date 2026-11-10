import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../data/app_state.dart';
import '../models/selectable_app.dart';
import '../services/native_app_service.dart';
import '../theme/wazn_colors.dart';
import '../theme/wazn_theme.dart';
import '../widgets/app_icon.dart';

class RestrictedAppsScreen extends StatefulWidget {
  const RestrictedAppsScreen({super.key});

  @override
  State<RestrictedAppsScreen> createState() => _RestrictedAppsScreenState();
}

class _RestrictedAppsScreenState extends State<RestrictedAppsScreen> {
  List<SelectableApp> _allApps = [];
  bool _loading = true;
  String _searchQuery = '';
  int _selectedFilter = 0; // 0: الكل, 1: المحدد, 2: التواصل, 3: الترفيه

  @override
  void initState() {
    super.initState();
    _loadApps();
  }

  Future<void> _loadApps({bool forceRefresh = false}) async {
    setState(() => _loading = true);
    final apps = await NativeAppService.instance
        .getInstalledApps(forceRefresh: forceRefresh);
    if (mounted) {
      setState(() {
        _allApps = apps;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final selected = state.settings.restrictedApps;

    final filtered = _allApps.where((app) {
      if (app.isQuranApp) return false; // تطبيقات القرآن تُدار بشكل منفصل

      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matchName = app.name.toLowerCase().contains(q);
        final matchEng = app.englishName?.toLowerCase().contains(q) ?? false;
        final matchPkg = app.packageName?.toLowerCase().contains(q) ?? false;
        if (!matchName && !matchEng && !matchPkg) return false;
      }

      if (_selectedFilter == 1) {
        return selected.contains(app.id) ||
            (app.packageName != null && selected.contains(app.packageName));
      } else if (_selectedFilter == 2) {
        return app.category == AppCategory.social;
      } else if (_selectedFilter == 3) {
        return app.category == AppCategory.entertainment;
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: WaznColors.sand,
      appBar: AppBar(
        title: const Text('التطبيقات المقيّدة'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded),
            tooltip: 'تحديث التطبيقات المثبتة',
            onPressed: () => _loadApps(forceRefresh: true),
          ),
        ],
      ),
      body: Column(
        children: [
          // شريط البحث
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              onChanged: (v) => setState(() => _searchQuery = v),
              decoration: InputDecoration(
                hintText: 'ابحث عن تطبيق (تيك توك، فيسبوك...)...',
                prefixIcon:
                    const Icon(Icons.search_rounded, color: WaznColors.oasis),
                filled: true,
                fillColor: WaznColors.white,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: WaznColors.sandLine),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: WaznColors.sandLine),
                ),
              ),
            ),
          ),

          // شرائح التصفية
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: Row(
              children: [
                _chip(
                    0, 'الكل (${_allApps.where((a) => !a.isQuranApp).length})'),
                const SizedBox(width: 8),
                _chip(1, 'المحدد (${selected.length})'),
                const SizedBox(width: 8),
                _chip(2, 'التواصل الاجتماعي'),
                const SizedBox(width: 8),
                _chip(3, 'الألعاب والترفيه'),
              ],
            ),
          ),

          const SizedBox(height: 8),

          // قائمة التطبيقات
          Expanded(
            child: _loading
                ? const Center(
                    child: CircularProgressIndicator(color: WaznColors.oasis))
                : filtered.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.apps_outlined,
                                size: 48, color: WaznColors.inkMuted),
                            const SizedBox(height: 8),
                            Text(
                              _searchQuery.isNotEmpty
                                  ? 'لم يتم العثور على نتائج'
                                  : 'لا توجد تطبيقات',
                              style: const TextStyle(
                                  fontFamily: WaznFonts.ui,
                                  color: WaznColors.inkMuted),
                            ),
                          ],
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                        itemCount: filtered.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, i) {
                          final a = filtered[i];
                          final isRestricted = selected.contains(a.id) ||
                              (a.packageName != null &&
                                  selected.contains(a.packageName));

                          return Container(
                            decoration: BoxDecoration(
                              color: WaznColors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color: isRestricted
                                    ? WaznColors.oasis
                                    : WaznColors.sandLine,
                                width: isRestricted ? 1.5 : 1,
                              ),
                            ),
                            child: ListTile(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 4),
                              leading: AppIcon(app: a, size: 44),
                              title: Text(
                                a.name,
                                style: const TextStyle(
                                  fontFamily: WaznFonts.ui,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 15.5,
                                  color: WaznColors.ink,
                                ),
                              ),
                              subtitle: Text(
                                a.englishName ??
                                    (a.isInstalled
                                        ? 'مثبت على الجهاز'
                                        : 'تطبيق مقترح'),
                                style: const TextStyle(
                                  fontFamily: WaznFonts.ui,
                                  fontSize: 12,
                                  color: WaznColors.inkMuted,
                                ),
                              ),
                              trailing: Switch(
                                value: isRestricted,
                                activeTrackColor: WaznColors.oasis,
                                onChanged: (_) => state.toggleApp(a.id),
                              ),
                              onTap: () => state.toggleApp(a.id),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }

  Widget _chip(int index, String label) {
    final active = _selectedFilter == index;
    return ChoiceChip(
      label: Text(label),
      selected: active,
      labelStyle: TextStyle(
        fontFamily: WaznFonts.ui,
        fontSize: 12.5,
        fontWeight: active ? FontWeight.w700 : FontWeight.w500,
        color: active ? WaznColors.sandSoft : WaznColors.ink,
      ),
      selectedColor: WaznColors.emerald,
      backgroundColor: WaznColors.sandWarm,
      side: BorderSide.none,
      onSelected: (_) => setState(() => _selectedFilter = index),
    );
  }
}
