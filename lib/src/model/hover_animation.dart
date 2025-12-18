import 'package:flutter/material.dart';

@immutable
abstract class HoverAnimation {
  const HoverAnimation();

  static HoverAnimation scale({
    double scaleAmount = 1.05,
    Duration duration = const Duration(milliseconds: 200),
  }) =>
      HoverScaleAnimation(scaleAmount: scaleAmount, duration: duration);

  static HoverAnimation lift({
    double liftHeight = 4.0,
    Duration duration = const Duration(milliseconds: 200),
  }) =>
      HoverLiftAnimation(liftHeight: liftHeight, duration: duration);

  static HoverAnimation glow({
    Color glowColor = Colors.white,
    double glowStrength = 0.5,
    Duration duration = const Duration(milliseconds: 200),
  }) =>
      HoverGlowAnimation(
          glowColor: glowColor, glowStrength: glowStrength, duration: duration);

  static HoverAnimation shimmer(
          {Duration duration = const Duration(milliseconds: 1500)}) =>
      HoverShimmerAnimation(duration: duration);

  static HoverAnimation none() => const NoHoverAnimation();
}

@immutable
class HoverScaleAnimation extends HoverAnimation {
  final double scaleAmount;
  final Duration duration;

  const HoverScaleAnimation(
      {required this.scaleAmount, required this.duration});
}

@immutable
class HoverLiftAnimation extends HoverAnimation {
  final double liftHeight;
  final Duration duration;

  const HoverLiftAnimation({required this.liftHeight, required this.duration});
}

@immutable
class HoverGlowAnimation extends HoverAnimation {
  final Color glowColor;
  final double glowStrength;
  final Duration duration;

  const HoverGlowAnimation(
      {required this.glowColor,
      required this.glowStrength,
      required this.duration});
}

@immutable
class HoverShimmerAnimation extends HoverAnimation {
  final Duration duration;
  const HoverShimmerAnimation({required this.duration});
}

@immutable
class NoHoverAnimation extends HoverAnimation {
  const NoHoverAnimation();
}
