import 'package:flutter/material.dart';
import '../models/selectable_app.dart';

class AppIcon extends StatelessWidget {
  final SelectableApp app;
  final double size;
  final double borderRadius;

  const AppIcon({
    super.key,
    required this.app,
    this.size = 46,
    this.borderRadius = 13,
  });

  @override
  Widget build(BuildContext context) {
    // 1. إذا كان التطبيق يحتوي على أيقونة حقيقية مستخرجة من النظام (Android PackageManager)
    if (app.iconBytes != null && app.iconBytes!.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Image.memory(
          app.iconBytes!,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildBrandedOrFallbackIcon(),
        ),
      );
    }

    // 2. إذا لم تتوفر الأيقونة المستخرجة، نستخدم أيقونات العلامات التجارية المصممة بدقة
    return _buildBrandedOrFallbackIcon();
  }

  Widget _buildBrandedOrFallbackIcon() {
    final key =
        (app.id.isNotEmpty ? app.id : (app.packageName ?? '')).toLowerCase();
    final name = app.name.toLowerCase();

    // فحص تطبيقات القرآن أولاً
    if (app.isQuranApp ||
        key.contains('quran') ||
        key.contains('ayat') ||
        name.contains('قرآن') ||
        name.contains('مصحف') ||
        name.contains('آيات')) {
      return _buildQuranAppIcon(key);
    }

    // فحص التطبيقات الشائعة
    if (key.contains('tiktok') || key.contains('musically')) {
      return _buildTikTokIcon();
    }
    if (key.contains('facebook') || key.contains('katana')) {
      return _buildFacebookIcon();
    }
    if (key.contains('instagram')) {
      return _buildInstagramIcon();
    }
    if (key.contains('youtube')) {
      return _buildYouTubeIcon();
    }
    if (key.contains('snapchat')) {
      return _buildSnapchatIcon();
    }
    if (key == 'x' || key.contains('twitter')) {
      return _buildXIcon();
    }
    if (key.contains('whatsapp')) {
      return _buildWhatsAppIcon();
    }
    if (key.contains('telegram')) {
      return _buildTelegramIcon();
    }
    if (key.contains('reddit')) {
      return _buildRedditIcon();
    }
    if (key.contains('pubg')) {
      return _buildPubgIcon();
    }

    // الأيقونة الافتراضية الأنيقة
    return _buildFallbackIcon();
  }

  // ── أيقونة تيك توك ───────────────────────────────────────────
  Widget _buildTikTokIcon() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF010101),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: SizedBox(
          width: size * 0.55,
          height: size * 0.55,
          child: CustomPaint(
            painter: _TikTokNotePainter(),
          ),
        ),
      ),
    );
  }

  // ── أيقونة فيسبوك ───────────────────────────────────────────
  Widget _buildFacebookIcon() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF1877F2),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1877F2).withValues(alpha: 0.3),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'f',
          style: TextStyle(
            fontFamily: 'sans-serif',
            fontSize: size * 0.72,
            fontWeight: FontWeight.w900,
            color: Colors.white,
            height: 1.1,
          ),
        ),
      ),
    );
  }

  // ── أيقونة إنستغرام ─────────────────────────────────────────
  Widget _buildInstagramIcon() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: const RadialGradient(
          center: Alignment(-0.8, 0.9),
          radius: 1.3,
          colors: [
            Color(0xFFFFDD55),
            Color(0xFFFF543E),
            Color(0xFFC837AB),
            Color(0xFF5B51D8),
            Color(0xFF3770E8),
          ],
          stops: [0.0, 0.35, 0.6, 0.85, 1.0],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFC837AB).withValues(alpha: 0.3),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Container(
          width: size * 0.58,
          height: size * 0.58,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(size * 0.16),
            border: Border.all(color: Colors.white, width: size * 0.05),
          ),
          child: Center(
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: size * 0.26,
                  height: size * 0.26,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: size * 0.05),
                  ),
                ),
                Positioned(
                  top: size * 0.04,
                  right: size * 0.04,
                  child: Container(
                    width: size * 0.06,
                    height: size * 0.06,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── أيقونة يوتيوب ───────────────────────────────────────────
  Widget _buildYouTubeIcon() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFFF0000),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF0000).withValues(alpha: 0.3),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.play_arrow_rounded,
          color: Colors.white,
          size: size * 0.65,
        ),
      ),
    );
  }

  // ── أيقونة سناب شات ─────────────────────────────────────────
  Widget _buildSnapchatIcon() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFFFFC00),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFFC00).withValues(alpha: 0.4),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: SizedBox(
          width: size * 0.6,
          height: size * 0.6,
          child: CustomPaint(painter: _SnapGhostPainter()),
        ),
      ),
    );
  }

  // ── أيقونة إكس (تويتر) ──────────────────────────────────────
  Widget _buildXIcon() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF000000),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(
        child: Text(
          '𝕏',
          style: TextStyle(
            fontFamily: 'serif',
            fontSize: size * 0.55,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // ── أيقونة واتساب ───────────────────────────────────────────
  Widget _buildWhatsAppIcon() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF25D366),
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF25D366).withValues(alpha: 0.3),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Icon(
          Icons.chat_bubble_rounded,
          color: Colors.white,
          size: size * 0.55,
        ),
      ),
    );
  }

  // ── أيقونة تيليجرام ────────────────────────────────────────
  Widget _buildTelegramIcon() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFF229ED9),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(
        child: Icon(
          Icons.send_rounded,
          color: Colors.white,
          size: size * 0.55,
        ),
      ),
    );
  }

  // ── أيقونة ريديت ───────────────────────────────────────────
  Widget _buildRedditIcon() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: const Color(0xFFFF4500),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(
        child: Icon(
          Icons.reddit_rounded,
          color: Colors.white,
          size: size * 0.6,
        ),
      ),
    );
  }

  // ── أيقونة ببجي ────────────────────────────────────────────
  Widget _buildPubgIcon() {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2D3748), Color(0xFF1A202C)],
        ),
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Center(
        child: Icon(
          Icons.sports_esports_rounded,
          color: const Color(0xFFE9C46A),
          size: size * 0.6,
        ),
      ),
    );
  }

  // ── أيقونات تطبيقات القرآن الكريم ───────────────────────────
  Widget _buildQuranAppIcon(String key) {
    if (key.contains('ayat') || key.contains('ksu')) {
      // آيات - جامعة الملك سعود (أخضر داكن + ذهبي إسلامي)
      return _quranBadge(
        gradient: const [Color(0xFF0B4634), Color(0xFF04261C)],
        accentColor: const Color(0xFFE9C46A),
        title: 'آيات',
        icon: Icons.auto_stories_rounded,
      );
    } else if (key.contains('golden')) {
      // المصحف الذهبي (تدرج ذهبي فاخر مع نقش مصحف)
      return _quranBadge(
        gradient: const [Color(0xFFD4A24C), Color(0xFF9A6D23)],
        accentColor: Colors.white,
        title: 'الذهبي',
        icon: Icons.menu_book_rounded,
      );
    } else if (key.contains('muslimpro') || key.contains('muslim_pro')) {
      // مسلم برو (أخضر زمردي + قبة وهلال)
      return _quranBadge(
        gradient: const [Color(0xFF0E7A63), Color(0xFF064739)],
        accentColor: const Color(0xFFFFD56B),
        title: 'Muslim',
        icon: Icons.mosque_rounded,
      );
    } else {
      // تطبيق قرآن عام (أخضر وذهب مع مظهر مصحف شريف)
      return _quranBadge(
        gradient: const [Color(0xFF135A4A), Color(0xFF0B382D)],
        accentColor: const Color(0xFFE9C46A),
        title: 'قرآن',
        icon: Icons.menu_book_rounded,
      );
    }
  }

  Widget _quranBadge({
    required List<Color> gradient,
    required Color accentColor,
    required String title,
    required IconData icon,
  }) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        gradient: LinearGradient(
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
          colors: gradient,
        ),
        border:
            Border.all(color: accentColor.withValues(alpha: 0.35), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: gradient.first.withValues(alpha: 0.3),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // إطار زخرفي خفيف
          Container(
            margin: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius - 2),
              border: Border.all(
                color: accentColor.withValues(alpha: 0.2),
                width: 0.7,
              ),
            ),
          ),
          Icon(
            icon,
            color: accentColor,
            size: size * 0.52,
          ),
        ],
      ),
    );
  }

  // ── الأيقونة العامة البديلة ─────────────────────────────────
  Widget _buildFallbackIcon() {
    final color = Color(app.iconBgColor);
    final letter = app.name.isNotEmpty ? app.name[0] : 'ت';
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(borderRadius),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
      ),
      alignment: Alignment.center,
      child: Text(
        letter,
        style: TextStyle(
          fontSize: size * 0.45,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

/// رسم نوتة تيك توك الشهيرة بدقة (تداخل السماوي والوردي مع الأبيض)
class _TikTokNotePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    void drawNote(Color color, double dx, double dy) {
      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      final path = Path();
      // رسم رأس النغمة الموسيقية الدائري والساق
      path.moveTo(w * 0.52 + dx, h * 0.15 + dy);
      path.lineTo(w * 0.52 + dx, h * 0.65 + dy);
      path.cubicTo(
        w * 0.52 + dx,
        h * 0.82 + dy,
        w * 0.20 + dx,
        h * 0.82 + dy,
        w * 0.20 + dx,
        h * 0.68 + dy,
      );
      path.cubicTo(
        w * 0.20 + dx,
        h * 0.52 + dy,
        w * 0.52 + dx,
        h * 0.52 + dy,
        w * 0.52 + dx,
        h * 0.52 + dy,
      );
      path.lineTo(w * 0.52 + dx, h * 0.32 + dy);
      path.cubicTo(
        w * 0.68 + dx,
        h * 0.42 + dy,
        w * 0.88 + dx,
        h * 0.42 + dy,
        w * 0.88 + dx,
        h * 0.42 + dy,
      );
      path.lineTo(w * 0.88 + dx, h * 0.26 + dy);
      path.cubicTo(
        w * 0.72 + dx,
        h * 0.26 + dy,
        w * 0.56 + dx,
        h * 0.15 + dy,
        w * 0.52 + dx,
        h * 0.15 + dy,
      );
      path.close();
      canvas.drawPath(path, paint);
    }

    // الظل السماوي (Cyan)
    drawNote(const Color(0xFF25F4EE), -w * 0.04, -h * 0.03);
    // الظل الوردي الفاتح (Magenta/Red)
    drawNote(const Color(0xFFFE2C55), w * 0.04, h * 0.03);
    // النوتة البيضاء المركزية
    drawNote(Colors.white, 0, 0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// رسم شبح سناب شات الشهير
class _SnapGhostPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    final fillPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = Colors.black
      ..style = PaintingStyle.stroke
      ..strokeWidth = w * 0.05
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final path = Path();
    // رأس الشبح وجسمه المقوس
    path.moveTo(w * 0.5, h * 0.12);
    // الرأس المدور
    path.cubicTo(w * 0.28, h * 0.12, w * 0.28, h * 0.35, w * 0.28, h * 0.45);
    // الذراع الأيسر
    path.cubicTo(w * 0.15, h * 0.45, w * 0.12, h * 0.52, w * 0.18, h * 0.58);
    path.cubicTo(w * 0.24, h * 0.62, w * 0.30, h * 0.58, w * 0.30, h * 0.58);
    // الجانب السفلي المتعرج
    path.cubicTo(w * 0.28, h * 0.75, w * 0.20, h * 0.82, w * 0.22, h * 0.88);
    path.cubicTo(w * 0.25, h * 0.92, w * 0.35, h * 0.85, w * 0.42, h * 0.90);
    path.cubicTo(w * 0.46, h * 0.93, w * 0.54, h * 0.93, w * 0.58, h * 0.90);
    path.cubicTo(w * 0.65, h * 0.85, w * 0.75, h * 0.92, w * 0.78, h * 0.88);
    path.cubicTo(w * 0.80, h * 0.82, w * 0.72, h * 0.75, w * 0.70, h * 0.58);
    // الذراع الأيمن
    path.cubicTo(w * 0.70, h * 0.58, w * 0.76, h * 0.62, w * 0.82, h * 0.58);
    path.cubicTo(w * 0.88, h * 0.52, w * 0.85, h * 0.45, w * 0.72, h * 0.45);
    // العودة للرأس
    path.cubicTo(w * 0.72, h * 0.35, w * 0.72, h * 0.12, w * 0.5, h * 0.12);
    path.close();

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
