import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:qibla_finder/data/models/qibla_data.dart';

class QiblaCompass extends StatelessWidget {
  final QiblaData qiblaData;
  final double size;

  const QiblaCompass({
    super.key,
    required this.qiblaData,
    this.size = 300,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Compass background circle
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
          ),

          // Compass ring with degree marks
          Transform.rotate(
            angle: -qiblaData.currentHeading * (math.pi / 180),
            child: CustomPaint(
              size: Size(size, size),
              painter: CompassRingPainter(
                qiblaDirection: qiblaData.direction,
                isFacingQibla: qiblaData.isFacingQibla,
                isDark: isDark,
              ),
            ),
          ),

          // Qibla direction indicator (Kaaba icon/arrow)
          Transform.rotate(
            angle: (qiblaData.direction - qiblaData.currentHeading) *
                (math.pi / 180),
            child: Icon(
              Icons.arrow_upward,
              size: size * 0.4,
              color: qiblaData.isFacingQibla
                  ? Colors.green
                  : theme.colorScheme.primary,
            ),
          ),

          // Center point
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: qiblaData.isFacingQibla
                  ? Colors.green
                  : theme.colorScheme.primary,
              border: Border.all(
                color: theme.colorScheme.surface,
                width: 3,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CompassRingPainter extends CustomPainter {
  final double qiblaDirection;
  final bool isFacingQibla;
  final bool isDark;

  CompassRingPainter({
    required this.qiblaDirection,
    required this.isFacingQibla,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Draw outer circle
    final outerCirclePaint = Paint()
      ..color = isDark ? Colors.white24 : Colors.black12
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, radius - 10, outerCirclePaint);

    // Draw cardinal directions
    final textPainter = TextPainter(
      textDirection: TextDirection.rtl,
      textAlign: TextAlign.center,
    );

    final directions = [
      {'text': 'ش', 'angle': 0.0}, // North
      {'text': 'ق', 'angle': 90.0}, // East
      {'text': 'ج', 'angle': 180.0}, // South
      {'text': 'غ', 'angle': 270.0}, // West
    ];

    for (var direction in directions) {
      final angle = (direction['angle'] as double) * (math.pi / 180);
      final x = center.dx + (radius - 40) * math.sin(angle);
      final y = center.dy - (radius - 40) * math.cos(angle);

      textPainter.text = TextSpan(
        text: direction['text'] as String,
        style: TextStyle(
          color: isDark ? Colors.white : Colors.black87,
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      );

      textPainter.layout();
      textPainter.paint(
        canvas,
        Offset(x - textPainter.width / 2, y - textPainter.height / 2),
      );
    }

    // Draw degree marks
    final markPaint = Paint()
      ..color = isDark ? Colors.white54 : Colors.black54
      ..strokeWidth = 2;

    for (int i = 0; i < 360; i += 10) {
      final angle = i * (math.pi / 180);
      final isMainMark = i % 30 == 0;

      final startRadius = radius - (isMainMark ? 20 : 15);
      final endRadius = radius - 10;

      final startX = center.dx + startRadius * math.sin(angle);
      final startY = center.dy - startRadius * math.cos(angle);
      final endX = center.dx + endRadius * math.sin(angle);
      final endY = center.dy - endRadius * math.cos(angle);

      if (isMainMark) {
        markPaint.strokeWidth = 3;
      } else {
        markPaint.strokeWidth = 1;
      }

      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        markPaint,
      );
    }

    // Highlight Qibla direction with a special mark
    final qiblaAngle = qiblaDirection * (math.pi / 180);
    final qiblaPaint = Paint()
      ..color = isFacingQibla ? Colors.green : const Color(0xFF00796B)
      ..strokeWidth = 4;

    final qiblaStartRadius = radius - 30;
    final qiblaEndRadius = radius - 5;

    final qiblaStartX = center.dx + qiblaStartRadius * math.sin(qiblaAngle);
    final qiblaStartY = center.dy - qiblaStartRadius * math.cos(qiblaAngle);
    final qiblaEndX = center.dx + qiblaEndRadius * math.sin(qiblaAngle);
    final qiblaEndY = center.dy - qiblaEndRadius * math.cos(qiblaAngle);

    canvas.drawLine(
      Offset(qiblaStartX, qiblaStartY),
      Offset(qiblaEndX, qiblaEndY),
      qiblaPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CompassRingPainter oldDelegate) {
    return oldDelegate.qiblaDirection != qiblaDirection ||
        oldDelegate.isFacingQibla != isFacingQibla;
  }
}
