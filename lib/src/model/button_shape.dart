import 'dart:ui';
import 'package:flutter/foundation.dart';

@immutable
abstract class ButtonShape {
  const ButtonShape();

  static ButtonShape circle() => const CircleShape();
  static ButtonShape rectangle() => const RectangleShape();
  static ButtonShape stadium() => const StadiumShape();

  static ButtonShape roundedRectangle({double radius = 30.0}) => RoundedRectangleShape(radius: radius);

  static ButtonShape roundedRectangleCustom({
    double topLeft = 0,
    double topRight = 0,
    double bottomLeft = 0,
    double bottomRight = 0,
  }) => RoundedRectangleCustomShape(
    topLeft: topLeft,
    topRight: topRight,
    bottomLeft: bottomLeft,
    bottomRight: bottomRight,
  );

  static ButtonShape polygon({required int sides, double rotation = 0}) =>
      PolygonShape(sides: sides, rotation: rotation);

  static ButtonShape star({required int points, double innerRadiusRatio = 0.5, double rotation = 0}) =>
      StarShape(points: points, innerRadiusRatio: innerRadiusRatio, rotation: rotation);

  static ButtonShape custom({required Path Function(Size size) pathBuilder, int smoothPoints = 60}) =>
      CustomShape(pathBuilder: pathBuilder, smoothPoints: smoothPoints);
}

@immutable
class CircleShape extends ButtonShape {
  const CircleShape();
}

@immutable
class RectangleShape extends ButtonShape {
  const RectangleShape();
}

@immutable
class StadiumShape extends ButtonShape {
  const StadiumShape();
}

@immutable
class RoundedRectangleShape extends ButtonShape {
  final double radius;
  const RoundedRectangleShape({required this.radius});
}

@immutable
class RoundedRectangleCustomShape extends ButtonShape {
  final double topLeft;
  final double topRight;
  final double bottomLeft;
  final double bottomRight;

  const RoundedRectangleCustomShape({
    required this.topLeft,
    required this.topRight,
    required this.bottomLeft,
    required this.bottomRight,
  });
}

@immutable
class PolygonShape extends ButtonShape {
  final int sides;
  final double rotation;
  const PolygonShape({required this.sides, required this.rotation});
}

@immutable
class StarShape extends ButtonShape {
  final int points;
  final double innerRadiusRatio;
  final double rotation;

  const StarShape({required this.points, required this.innerRadiusRatio, required this.rotation});
}

@immutable
class CustomShape extends ButtonShape {
  final Path Function(Size size) pathBuilder;
  final int smoothPoints;

  const CustomShape({required this.pathBuilder, required this.smoothPoints});
}
