import 'package:flutter/material.dart';

class ButtonShadow {
  final bool enabled;
  final Color color;
  final double blur;
  final Offset offset;
  final double spread;

  const ButtonShadow({
    this.enabled = true,
    this.color = const Color(0x55000000),
    this.blur = 20,
    this.offset = Offset.zero,
    this.spread = 0,
  });

  const ButtonShadow.none()
      : enabled = false,
        color = Colors.transparent,
        blur = 0,
        offset = Offset.zero,
        spread = 0;
}
