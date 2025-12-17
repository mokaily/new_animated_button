import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../model/hover_animation.dart';
import '../model/tap_animation.dart';
import 'button_shadow.dart';

void drawShadowLayer({
  required Canvas canvas,
  required Path path,
  required Size size,
  required bool isPressed,
  required bool isHovered,
  required HoverAnimation hoverAnimation,
  required double hoverProgress,
  required ButtonShadow shadow,
}) {
  if (!shadow.enabled) return;

  var blur = isPressed ? shadow.blur * 0.6 : shadow.blur;

  if (hoverAnimation is HoverLiftAnimation && isHovered) {
    blur += 10 * hoverProgress;
  }

  final paint = Paint()
    ..color = shadow.color
    ..maskFilter = MaskFilter.blur(BlurStyle.normal, blur);

  canvas.save();
  canvas.translate(shadow.offset.dx, shadow.offset.dy);
  canvas.drawPath(path, paint);
  canvas.restore();
}

void drawBackgroundLayer({
  required Canvas canvas,
  required Path path,
  required Size size,
  required Gradient? gradient,
  required Color? color,
}) {
  final paint = Paint()..style = PaintingStyle.fill;
  if (gradient != null) {
    paint.shader = gradient.createShader(Rect.fromLTWH(0, 0, size.width, size.height));
  } else {
    paint.color = color ?? const Color(0xFF7C3AED);
  }
  canvas.drawPath(path, paint);
}

void drawGlassLayer({required Canvas canvas, required Path path}) {
  final paint =
      Paint()
        ..color = Colors.white.withOpacity(0.15)
        ..style = PaintingStyle.fill;
  canvas.drawPath(path, paint);
}

void drawBorderLayer({
  required Canvas canvas,
  required Path path,
  required bool isGlass,
  required bool isHovered,
  required HoverAnimation hoverAnimation,
  required double hoverProgress,
}) {
  var borderOpacity = isGlass ? 0.3 : 0.2;
  var borderWidth = 1.5;

  if (hoverAnimation is HoverGlowAnimation && isHovered) {
    borderOpacity += hoverAnimation.glowStrength * hoverProgress;
    borderWidth += 1.0 * hoverProgress;
  }

  final paint =
      Paint()
        ..color = Colors.white.withOpacity(borderOpacity)
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth;

  canvas.drawPath(path, paint);
}

void drawHighlightLayer({required Canvas canvas, required List<Offset> points, required Size size}) {
  if (points.length < 4) return;

  final highlightPoints = points.sublist(0, points.length ~/ 2);
  final highlightPath = Path()..moveTo(highlightPoints[0].dx, highlightPoints[0].dy);
  for (var i = 1; i < highlightPoints.length; i++) {
    highlightPath.lineTo(highlightPoints[i].dx, highlightPoints[i].dy);
  }

  final paint =
      Paint()
        ..shader = const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.center,
          colors: [Colors.white54, Colors.transparent],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height / 3))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0;

  canvas.drawPath(highlightPath, paint);
}

void drawRippleLayer({
  required Canvas canvas,
  required Size size,
  required Offset pressPosition,
  required double releaseProgress,
  required RippleTapAnimation animation,
}) {
  final maxRadius = math.sqrt(size.width * size.width + size.height * size.height);
  final radius = releaseProgress * maxRadius;

  final paint =
      Paint()
        ..color = animation.rippleColor.withOpacity(0.3 * (1 - releaseProgress))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0;

  canvas.drawCircle(pressPosition, radius, paint);
}

void drawShimmerLayer({
  required Canvas canvas,
  required Size size,
  required Path path,
  required double shimmerProgress,
}) {
  final paint =
      Paint()
        ..shader = LinearGradient(
          begin: Alignment(-1.0 + shimmerProgress * 2, 0),
          end: Alignment(1.0 + shimmerProgress * 2, 0),
          colors: [Colors.transparent, Colors.white.withOpacity(0.3), Colors.transparent],
          stops: const [0.0, 0.5, 1.0],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..blendMode = BlendMode.overlay;

  canvas.drawPath(path, paint);
}

void drawLongPressIndicator({required Canvas canvas, required Size size, required double progress}) {
  final rect = Rect.fromLTWH(-3, -3, size.width + 6, size.height + 6);

  final paint =
      Paint()
        ..color = Colors.white.withOpacity(0.8)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 3.0
        ..strokeCap = StrokeCap.round;

  final sweepAngle = 2 * math.pi * progress;
  canvas.drawArc(rect, -math.pi / 2, sweepAngle, false, paint);
}
