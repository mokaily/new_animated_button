import 'dart:math' as math;
import 'dart:ui';

import '../model/tap_animation.dart';

List<Offset> applyEffects({
  required List<Offset> points,
  required Size size,
  required Offset? pressPosition,
  required bool isPressed,
  required double pressProgress,
  required double releaseProgress,
  required TapAnimation tapAnimation,
}) {
  if (tapAnimation is JellyTapAnimation) {
    return _applyJelly(
      points: points,
      size: size,
      pressPosition: pressPosition,
      isPressed: isPressed,
      pressProgress: pressProgress,
      releaseProgress: releaseProgress,
      anim: tapAnimation,
    );
  }

  if (tapAnimation is WaveTapAnimation) {
    return _applyWave(
      points: points,
      size: size,
      pressPosition: pressPosition,
      releaseProgress: releaseProgress,
      anim: tapAnimation,
    );
  }

  return points;
}

List<Offset> _applyJelly({
  required List<Offset> points,
  required Size size,
  required Offset? pressPosition,
  required bool isPressed,
  required double pressProgress,
  required double releaseProgress,
  required JellyTapAnimation anim,
}) {
  if (pressPosition == null) return points;

  final deformed = <Offset>[];
  final maxDistance = math.sqrt(size.width * size.width + size.height * size.height);

  for (final p in points) {
    var x = p.dx;
    var y = p.dy;

    final dx = x - pressPosition.dx;
    final dy = y - pressPosition.dy;
    final distance = math.sqrt(dx * dx + dy * dy);
    final influence = math.max(0, 1 - (distance / (maxDistance * 0.4)));

    final dirX = dx / (distance + 0.1);
    final dirY = dy / (distance + 0.1);

    if (isPressed) {
      final deformation = pressProgress * influence * anim.deformationStrength;
      x -= dirX * deformation;
      y -= dirY * deformation;
    } else if (releaseProgress > 0) {
      final bounce = math.sin(releaseProgress * math.pi) * influence * anim.bounceStrength;
      final overshoot = math.sin(releaseProgress * math.pi * 2) * influence * (anim.bounceStrength * 0.5);
      x += dirX * (bounce + overshoot);
      y += dirY * (bounce + overshoot);
    }

    deformed.add(Offset(x, y));
  }

  return deformed;
}

List<Offset> _applyWave({
  required List<Offset> points,
  required Size size,
  required Offset? pressPosition,
  required double releaseProgress,
  required WaveTapAnimation anim,
}) {
  if (pressPosition == null || releaseProgress == 0) return points;

  final deformed = <Offset>[];
  final maxDistance = math.sqrt(size.width * size.width + size.height * size.height);

  for (final p in points) {
    final dx = p.dx - pressPosition.dx;
    final dy = p.dy - pressPosition.dy;
    final distance = math.sqrt(dx * dx + dy * dy);

    final waveRadius = releaseProgress * maxDistance;
    final distanceFromWave = (distance - waveRadius).abs();

    if (distanceFromWave < 50) {
      final waveIntensity = (1 - distanceFromWave / 50) * anim.waveStrength;
      final dirX = dx / (distance + 0.1);
      final dirY = dy / (distance + 0.1);
      deformed.add(Offset(p.dx + dirX * waveIntensity, p.dy + dirY * waveIntensity));
    } else {
      deformed.add(p);
    }
  }

  return deformed;
}
