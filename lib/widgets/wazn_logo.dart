import 'package:flutter/material.dart';
import '../theme/wazn_colors.dart';
import '../theme/wazn_theme.dart';

/// أيقونة وزن: كتاب مفتوح تعلوه عارضة ميزان ولؤلؤة ذهبية.
class WaznMark extends StatelessWidget {
  final double size;
  const WaznMark({super.key, this.size = 44});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(size * 0.3),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: WaznColors.emeraldBtnGradient,
        ),
      ),
      child: CustomPaint(painter: _MarkPainter()),
    );
  }
}

class _MarkPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final gold = Paint()..color = WaznColors.goldLight..style = PaintingStyle.stroke..strokeWidth = w * 0.045..strokeCap = StrokeCap.round;
    final sand = Paint()..color = WaznColors.sand;
    // العارضة
    canvas.drawLine(Offset(w * 0.25, h * 0.22), Offset(w * 0.75, h * 0.22), gold);
    // اللؤلؤة
    canvas.drawCircle(Offset(w * 0.5, h * 0.22), w * 0.075, Paint()..color = WaznColors.goldLight);
    // الكتاب
    final book = Path()
      ..moveTo(w * 0.5, h * 0.4)
      ..cubicTo(w * 0.4, h * 0.34, w * 0.28, h * 0.34, w * 0.2, h * 0.37)
      ..lineTo(w * 0.2, h * 0.72)
      ..cubicTo(w * 0.28, h * 0.69, w * 0.4, h * 0.69, w * 0.5, h * 0.75)
      ..cubicTo(w * 0.6, h * 0.69, w * 0.72, h * 0.69, w * 0.8, h * 0.72)
      ..lineTo(w * 0.8, h * 0.37)
      ..cubicTo(w * 0.72, h * 0.34, w * 0.6, h * 0.34, w * 0.5, h * 0.4)
      ..close();
    canvas.drawPath(book, sand);
    canvas.drawLine(Offset(w * 0.5, h * 0.4), Offset(w * 0.5, h * 0.75), Paint()..color = WaznColors.emeraldMid..strokeWidth = w * 0.02);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// الشعار النصّي «وزن» بخط رقعة.
class WaznWordmark extends StatelessWidget {
  final double fontSize;
  final Color color;
  const WaznWordmark({super.key, this.fontSize = 30, this.color = WaznColors.emerald});

  @override
  Widget build(BuildContext context) {
    return Text(
      'وزن',
      style: TextStyle(fontFamily: WaznFonts.logo, fontSize: fontSize, fontWeight: FontWeight.w700, color: color, height: 1.1),
    );
  }
}
