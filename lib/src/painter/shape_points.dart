import 'dart:math' as math;
import 'dart:ui';

import '../model/button_shape.dart';

List<Offset> generateShapePoints({required ButtonShape shape, required Size size}) {
  return switch (shape) {
    CircleShape() => _circle(size),
    StadiumShape() => _stadium(size),
    RectangleShape() => _rectangle(size),
    PolygonShape s => _polygon(size, s),
    StarShape s => _star(size, s),
    CustomShape s => _custom(size, s),
    RoundedRectangleCustomShape s => _roundedRectCustom(size, s),
    RoundedRectangleShape s => _roundedRect(size, s),
    _ => _roundedRect(size, const RoundedRectangleShape(radius: 30)),
  };
}

List<Offset> _circle(Size size) {
  const pointsCount = 60;
  final result = <Offset>[];
  final radius = math.min(size.width, size.height) / 2;
  final center = Offset(size.width / 2, size.height / 2);

  for (var i = 0; i < pointsCount; i++) {
    final angle = (i / pointsCount) * 2 * math.pi;
    result.add(Offset(center.dx + math.cos(angle) * radius, center.dy + math.sin(angle) * radius));
  }
  return result;
}

List<Offset> _stadium(Size size) {
  const pointsPerSide = 15;
  final points = <Offset>[];
  final radius = size.height / 2;
  final r = radius.clamp(0.0, size.width / 2);

  for (var i = 0; i <= pointsPerSide; i++) {
    final t = i / pointsPerSide;
    points.add(Offset(r + t * (size.width - 2 * r), 0));
  }

  for (var i = 1; i <= pointsPerSide; i++) {
    final t = i / pointsPerSide;
    final angle = -math.pi / 2 + t * math.pi;
    points.add(Offset(size.width - r + math.cos(angle) * r, r + math.sin(angle) * r));
  }

  for (var i = 1; i <= pointsPerSide; i++) {
    final t = i / pointsPerSide;
    points.add(Offset(size.width - r - t * (size.width - 2 * r), size.height));
  }

  for (var i = 1; i < pointsPerSide; i++) {
    final t = i / pointsPerSide;
    final angle = math.pi / 2 + t * math.pi;
    points.add(Offset(r + math.cos(angle) * r, r + math.sin(angle) * r));
  }

  return points;
}

List<Offset> _rectangle(Size size) {
  const pointsPerSide = 15;
  final points = <Offset>[];

  for (var i = 0; i <= pointsPerSide; i++) {
    points.add(Offset((i / pointsPerSide) * size.width, 0));
  }
  for (var i = 1; i <= pointsPerSide; i++) {
    points.add(Offset(size.width, (i / pointsPerSide) * size.height));
  }
  for (var i = 1; i <= pointsPerSide; i++) {
    points.add(Offset(size.width - (i / pointsPerSide) * size.width, size.height));
  }
  for (var i = 1; i < pointsPerSide; i++) {
    points.add(Offset(0, size.height - (i / pointsPerSide) * size.height));
  }

  return points;
}

List<Offset> _polygon(Size size, PolygonShape shape) {
  final sides = shape.sides.clamp(3, 60);
  if (sides < 3) return _roundedRect(size, const RoundedRectangleShape(radius: 30));

  final radius = math.min(size.width, size.height) / 2;
  final center = Offset(size.width / 2, size.height / 2);

  final vertices = List<Offset>.generate(sides, (i) {
    final angle = (2 * math.pi * i / sides) + shape.rotation - math.pi / 2;
    return Offset(center.dx + radius * math.cos(angle), center.dy + radius * math.sin(angle));
  });

  const pointsPerSide = 8;
  final points = <Offset>[];

  for (var i = 0; i < sides; i++) {
    final a = vertices[i];
    final b = vertices[(i + 1) % sides];
    for (var j = 0; j < pointsPerSide; j++) {
      final t = j / pointsPerSide;
      points.add(Offset(lerpDouble(a.dx, b.dx, t)!, lerpDouble(a.dy, b.dy, t)!));
    }
  }

  return points;
}

List<Offset> _star(Size size, StarShape shape) {
  if (shape.points < 2) return _roundedRect(size, const RoundedRectangleShape(radius: 30));

  final points = <Offset>[];
  final outerRadius = math.min(size.width, size.height) / 2;
  final innerRadius = outerRadius * shape.innerRadiusRatio.clamp(0.1, 0.9);
  final center = Offset(size.width / 2, size.height / 2);

  const pointsPerSegment = 5;
  final totalSegments = shape.points * 2;

  for (var i = 0; i < totalSegments; i++) {
    final isOuter = i % 2 == 0;
    final currentRadius = isOuter ? outerRadius : innerRadius;
    final startAngle = (i / totalSegments) * 2 * math.pi + shape.rotation - math.pi / 2;
    final endAngle = ((i + 1) / totalSegments) * 2 * math.pi + shape.rotation - math.pi / 2;

    for (var j = 0; j <= pointsPerSegment; j++) {
      final t = j / pointsPerSegment;
      final angle = startAngle + t * (endAngle - startAngle);
      points.add(
        Offset(center.dx + math.cos(angle) * currentRadius, center.dy + math.sin(angle) * currentRadius),
      );
    }
  }

  return points;
}

List<Offset> _custom(Size size, CustomShape shape) {
  final customPath = shape.pathBuilder(size);
  final points = <Offset>[];
  final metrics = customPath.computeMetrics();

  for (final metric in metrics) {
    for (var i = 0; i <= shape.smoothPoints; i++) {
      final distance = (metric.length / shape.smoothPoints) * i;
      final tangent = metric.getTangentForOffset(distance);
      if (tangent != null) points.add(tangent.position);
    }
  }

  return points;
}

List<Offset> _roundedRect(Size size, RoundedRectangleShape shape) {
  const pointsPerSide = 15;
  final points = <Offset>[];

  final maxRadius = math.min(size.width, size.height) / 2;
  final radius = shape.radius.clamp(0.0, maxRadius);

  for (var i = 0; i <= pointsPerSide; i++) {
    final t = i / pointsPerSide;
    points.add(Offset(radius + t * (size.width - 2 * radius), 0));
  }

  for (var i = 1; i <= pointsPerSide; i++) {
    final t = i / pointsPerSide;
    final angle = -math.pi / 2 + t * (math.pi / 2);
    points.add(Offset(size.width - radius + math.cos(angle) * radius, radius + math.sin(angle) * radius));
  }

  for (var i = 1; i <= pointsPerSide; i++) {
    final t = i / pointsPerSide;
    points.add(Offset(size.width, radius + t * (size.height - 2 * radius)));
  }

  for (var i = 1; i <= pointsPerSide; i++) {
    final t = i / pointsPerSide;
    final angle = t * (math.pi / 2);
    points.add(
      Offset(size.width - radius + math.cos(angle) * radius, size.height - radius + math.sin(angle) * radius),
    );
  }

  for (var i = 1; i <= pointsPerSide; i++) {
    final t = i / pointsPerSide;
    points.add(Offset(size.width - radius - t * (size.width - 2 * radius), size.height));
  }

  for (var i = 1; i <= pointsPerSide; i++) {
    final t = i / pointsPerSide;
    final angle = math.pi / 2 + t * (math.pi / 2);
    points.add(Offset(radius + math.cos(angle) * radius, size.height - radius + math.sin(angle) * radius));
  }

  for (var i = 1; i <= pointsPerSide; i++) {
    final t = i / pointsPerSide;
    points.add(Offset(0, size.height - radius - t * (size.height - 2 * radius)));
  }

  for (var i = 1; i < pointsPerSide; i++) {
    final t = i / pointsPerSide;
    final angle = math.pi + t * (math.pi / 2);
    points.add(Offset(radius + math.cos(angle) * radius, radius + math.sin(angle) * radius));
  }

  return points;
}

List<Offset> _roundedRectCustom(Size size, RoundedRectangleCustomShape s) {
  const pointsPerSide = 15;
  final points = <Offset>[];

  var tl = s.topLeft;
  var tr = s.topRight;
  var br = s.bottomRight;
  var bl = s.bottomLeft;

  final maxTop = size.width / 2;
  final maxBottom = size.width / 2;
  final maxLeft = size.height / 2;
  final maxRight = size.height / 2;

  tl = tl.clamp(0.0, math.min(maxTop, maxLeft));
  tr = tr.clamp(0.0, math.min(maxTop, maxRight));
  br = br.clamp(0.0, math.min(maxBottom, maxRight));
  bl = bl.clamp(0.0, math.min(maxBottom, maxLeft));

  for (var i = 0; i <= pointsPerSide; i++) {
    final t = i / pointsPerSide;
    points.add(Offset(tl + t * (size.width - tl - tr), 0));
  }

  if (tr > 0) {
    for (var i = 1; i <= pointsPerSide; i++) {
      final t = i / pointsPerSide;
      final angle = -math.pi / 2 + t * (math.pi / 2);
      points.add(Offset(size.width - tr + math.cos(angle) * tr, tr + math.sin(angle) * tr));
    }
  }

  for (var i = 1; i <= pointsPerSide; i++) {
    final t = i / pointsPerSide;
    points.add(Offset(size.width, tr + t * (size.height - tr - br)));
  }

  if (br > 0) {
    for (var i = 1; i <= pointsPerSide; i++) {
      final t = i / pointsPerSide;
      final angle = t * (math.pi / 2);
      points.add(Offset(size.width - br + math.cos(angle) * br, size.height - br + math.sin(angle) * br));
    }
  }

  for (var i = 1; i <= pointsPerSide; i++) {
    final t = i / pointsPerSide;
    points.add(Offset(size.width - br - t * (size.width - br - bl), size.height));
  }

  if (bl > 0) {
    for (var i = 1; i <= pointsPerSide; i++) {
      final t = i / pointsPerSide;
      final angle = math.pi / 2 + t * (math.pi / 2);
      points.add(Offset(bl + math.cos(angle) * bl, size.height - bl + math.sin(angle) * bl));
    }
  }

  for (var i = 1; i <= pointsPerSide; i++) {
    final t = i / pointsPerSide;
    points.add(Offset(0, size.height - bl - t * (size.height - bl - tl)));
  }

  if (tl > 0) {
    for (var i = 1; i < pointsPerSide; i++) {
      final t = i / pointsPerSide;
      final angle = math.pi + t * (math.pi / 2);
      points.add(Offset(tl + math.cos(angle) * tl, tl + math.sin(angle) * tl));
    }
  }

  return points;
}
