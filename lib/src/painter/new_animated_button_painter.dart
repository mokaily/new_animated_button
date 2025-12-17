import 'package:flutter/material.dart';

import '../model/button_shape.dart';
import '../model/tap_animation.dart';
import '../model/hover_animation.dart';

import 'button_shadow.dart';
import 'shape_points.dart';
import 'effects.dart';
import 'path_utils.dart';
import 'paint_layers.dart';

class NewAnimatedButtonPainter extends CustomPainter {
  final Offset? pressPosition;
  final double pressProgress;
  final double releaseProgress;
  final double hoverProgress;
  final double shimmerProgress;
  final double longPressProgress;

  final Gradient? gradient;
  final Color? color;

  final bool isPressed;
  final bool isHovered;

  final TapAnimation tapAnimation;
  final HoverAnimation hoverAnimation;

  final bool hasLongPress;
  final bool enableGlassmorphism;
  final ButtonShape shape;
  final ButtonShadow shadow;


  const NewAnimatedButtonPainter({
    required this.pressPosition,
    required this.pressProgress,
    required this.releaseProgress,
    required this.hoverProgress,
    required this.shimmerProgress,
    required this.longPressProgress,
    required this.gradient,
    required this.color,
    required this.isPressed,
    required this.isHovered,
    required this.tapAnimation,
    required this.hoverAnimation,
    required this.hasLongPress,
    required this.enableGlassmorphism,
    required this.shape,
    this.shadow = const ButtonShadow(),
  });

  @override
  void paint(Canvas canvas, Size size) {
    final points = generateShapePoints(shape: shape, size: size);

    final deformed = applyEffects(
      points: points,
      size: size,
      pressPosition: pressPosition,
      isPressed: isPressed,
      pressProgress: pressProgress,
      releaseProgress: releaseProgress,
      tapAnimation: tapAnimation,
    );

    final path = createClosedPath(deformed);

    drawShadowLayer(
      canvas: canvas,
      path: path,
      size: size,
      isPressed: isPressed,
      isHovered: isHovered,
      hoverAnimation: hoverAnimation,
      hoverProgress: hoverProgress,
      shadow: shadow, // ✅
    );


    drawBackgroundLayer(
      canvas: canvas,
      path: path,
      size: size,
      gradient: gradient,
      color: color,
    );

    if (enableGlassmorphism) {
      drawGlassLayer(canvas: canvas, path: path);
      drawBorderLayer(
        canvas: canvas,
        path: path,
        isGlass: true,
        isHovered: isHovered,
        hoverAnimation: hoverAnimation,
        hoverProgress: hoverProgress,
      );
      drawHighlightLayer(canvas: canvas, points: deformed, size: size);
    } else {
      drawBorderLayer(
        canvas: canvas,
        path: path,
        isGlass: false,
        isHovered: isHovered,
        hoverAnimation: hoverAnimation,
        hoverProgress: hoverProgress,
      );
    }

    if (hasLongPress && isPressed && longPressProgress > 0) {
      drawLongPressIndicator(canvas: canvas, size: size, progress: longPressProgress);
    }

    if (tapAnimation is RippleTapAnimation && pressPosition != null) {
      drawRippleLayer(
        canvas: canvas,
        size: size,
        pressPosition: pressPosition!,
        releaseProgress: releaseProgress,
        animation: tapAnimation as RippleTapAnimation,
      );
    }

    if (hoverAnimation is HoverShimmerAnimation && isHovered) {
      drawShimmerLayer(
        canvas: canvas,
        size: size,
        path: path,
        shimmerProgress: shimmerProgress,
      );
    }
  }

  @override
  bool shouldRepaint(covariant NewAnimatedButtonPainter old) {
    return old.pressPosition != pressPosition ||
        old.pressProgress != pressProgress ||
        old.releaseProgress != releaseProgress ||
        old.hoverProgress != hoverProgress ||
        old.shimmerProgress != shimmerProgress ||
        old.longPressProgress != longPressProgress ||
        old.isPressed != isPressed ||
        old.isHovered != isHovered ||
        old.gradient != gradient ||
        old.color != color ||
        old.enableGlassmorphism != enableGlassmorphism ||
        old.shape != shape ||
        old.tapAnimation.runtimeType != tapAnimation.runtimeType ||
        old.hoverAnimation.runtimeType != hoverAnimation.runtimeType;
  }
}
