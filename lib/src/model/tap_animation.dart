import 'package:flutter/material.dart';

@immutable
abstract class TapAnimation {
  const TapAnimation();

  static TapAnimation jelly({
    double deformationStrength = 25.0,
    double bounceStrength = 15.0,
    Duration pressDuration = const Duration(milliseconds: 300),
    Duration releaseDuration = const Duration(milliseconds: 600),
  }) => JellyTapAnimation(
    deformationStrength: deformationStrength,
    bounceStrength: bounceStrength,
    pressDuration: pressDuration,
    releaseDuration: releaseDuration,
  );

  static TapAnimation scale({
    double scaleAmount = 0.95,
    Duration duration = const Duration(milliseconds: 150),
  }) => ScaleTapAnimation(scaleAmount: scaleAmount, duration: duration);

  static TapAnimation ripple({
    Color rippleColor = Colors.white,
    Duration duration = const Duration(milliseconds: 600),
  }) => RippleTapAnimation(rippleColor: rippleColor, duration: duration);

  static TapAnimation bounce({
    double bounceHeight = 8.0,
    Duration duration = const Duration(milliseconds: 400),
  }) => BounceTapAnimation(bounceHeight: bounceHeight, duration: duration);

  static TapAnimation wave({
    double waveStrength = 20.0,
    Duration duration = const Duration(milliseconds: 500),
  }) => WaveTapAnimation(waveStrength: waveStrength, duration: duration);

  static TapAnimation none() => const NoTapAnimation();
}

@immutable
class JellyTapAnimation extends TapAnimation {
  final double deformationStrength;
  final double bounceStrength;
  final Duration pressDuration;
  final Duration releaseDuration;

  const JellyTapAnimation({
    required this.deformationStrength,
    required this.bounceStrength,
    required this.pressDuration,
    required this.releaseDuration,
  });
}

@immutable
class ScaleTapAnimation extends TapAnimation {
  final double scaleAmount;
  final Duration duration;

  const ScaleTapAnimation({required this.scaleAmount, required this.duration});
}

@immutable
class RippleTapAnimation extends TapAnimation {
  final Color rippleColor;
  final Duration duration;

  const RippleTapAnimation({required this.rippleColor, required this.duration});
}

@immutable
class BounceTapAnimation extends TapAnimation {
  final double bounceHeight;
  final Duration duration;

  const BounceTapAnimation({required this.bounceHeight, required this.duration});
}

@immutable
class WaveTapAnimation extends TapAnimation {
  final double waveStrength;
  final Duration duration;

  const WaveTapAnimation({required this.waveStrength, required this.duration});
}

@immutable
class NoTapAnimation extends TapAnimation {
  const NoTapAnimation();
}
