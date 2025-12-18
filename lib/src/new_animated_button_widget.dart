import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:new_animated_button/src/painter/button_shadow.dart';

import 'constants.dart';
import 'model/button_shape.dart';
import 'model/hover_animation.dart';
import 'model/tap_animation.dart';
import 'painter/new_animated_button_painter.dart';

/// A highly customizable animated button with advanced tap and hover effects.
///
/// `NewAnimatedButton` provides rich, physics-inspired animations such as
/// jelly deformation, ripple waves, bounce feedback, hover glow, shimmer,
/// and lift effects — all rendered using a custom painter for maximum
/// performance.
///
/// ### Features
/// - Multiple tap animations: jelly, scale, ripple, bounce, wave
/// - Hover animations for desktop & web: scale, lift, glow, shimmer
/// - Optional glassmorphism effect
/// - Custom shapes (rounded, stadium, polygon, star, custom path)
/// - Long-press support with visual progress indicator
/// - Optimized for Flutter Web and Desktop
///
/// ### Example
/// ```dart
/// NewAnimatedButton(
///   onPressed: () {},
///   tapAnimation: TapAnimation.jelly(),
///   hoverAnimation: HoverAnimation.scale(),
///   child: Text('Click me'),
/// )
/// ```
///
/// This widget is designed for interactive UIs, design systems,
/// and animation-heavy experiences where visual feedback matters.
class NewAnimatedButton extends StatefulWidget {
  /// Called when the pointer is pressed down on the button.
  ///
  /// Unlike standard buttons, this callback is triggered on
  /// pointer down instead of pointer up to allow instant feedback.
  final VoidCallback? onPressed;

  /// Called when the pointer is released after a press.
  ///
  /// Useful for separating press and release logic.
  final VoidCallback? onPressedUp;

  /// Called when the button is held for at least [longPressDuration].
  ///
  /// A circular progress indicator is drawn around the button
  /// during the long press interaction.
  final VoidCallback? onLongPress;

  final Duration longPressDuration;

  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsets padding;
  final Gradient? gradient;
  final Color? color;

  /// Convenience: used if [shape] is null.
  final double borderRadius;

  /// Defines the animation applied when the button is tapped.
  ///
  /// Available animations include jelly, scale, ripple, bounce, and wave.
  /// Defaults to a jelly animation.
  final TapAnimation tapAnimation;

  /// Defines the animation applied when the pointer hovers over the button.
  ///
  /// Hover animations are mainly intended for desktop and web platforms.
  final HoverAnimation hoverAnimation;

  /// If null -> uses [borderRadius] rounded rectangle.
  final ButtonShape? shape;

  /// Whether to enable the glassmorphism visual effect.
  ///
  /// When enabled, a translucent overlay and highlight are rendered
  /// on top of the button shape.
  final bool enableGlassmorphism;

  final ButtonShadow shadow;

  /// Creates a new animated button.
  ///
  /// The button reacts to pointer interactions with configurable
  /// tap and hover animations. If no [shape] is provided, a rounded
  /// rectangle using [borderRadius] is used.
  const NewAnimatedButton({
    super.key,
    this.onPressed,
    this.onPressedUp,
    this.onLongPress,
    this.longPressDuration = const Duration(milliseconds: 500),
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
    this.gradient,
    this.color,
    this.borderRadius = 30.0,
    this.tapAnimation = const JellyTapAnimation(
      deformationStrength: 25.0,
      bounceStrength: 15.0,
      pressDuration: Duration(milliseconds: 300),
      releaseDuration: Duration(milliseconds: 600),
    ),
    this.hoverAnimation = const NoHoverAnimation(),
    this.enableGlassmorphism = true,
    this.shape,
    this.shadow = const ButtonShadow(enabled: false),
  });

  @override
  State<NewAnimatedButton> createState() => _NewAnimatedButtonState();
}

class _NewAnimatedButtonState extends State<NewAnimatedButton>
    with TickerProviderStateMixin {
  late final AnimationController _pressController;
  late final AnimationController _releaseController;
  late final AnimationController _hoverController;
  late final AnimationController _shimmerController;
  late final AnimationController _longPressController;

  /// Tracks the last pointer position without triggering widget rebuilds.
  ///
  /// Used to drive jelly and ripple effects efficiently.
  final ValueNotifier<Offset?> _pressPositionNotifier =
      ValueNotifier<Offset?>(null);

  bool _isPressed = false;
  bool _isHovered = false;
  bool _longPressTriggered = false;

  int _lastMoveMicros = 0;

  @override
  void initState() {
    super.initState();

    final tapAnim = widget.tapAnimation;

    var pressDuration = const Duration(milliseconds: 300);
    var releaseDuration = const Duration(milliseconds: 600);

    if (tapAnim is JellyTapAnimation) {
      pressDuration = tapAnim.pressDuration;
      releaseDuration = tapAnim.releaseDuration;
    } else if (tapAnim is ScaleTapAnimation) {
      pressDuration = tapAnim.duration;
      releaseDuration = tapAnim.duration;
    } else if (tapAnim is RippleTapAnimation) {
      releaseDuration = tapAnim.duration;
    } else if (tapAnim is BounceTapAnimation) {
      releaseDuration = tapAnim.duration;
    } else if (tapAnim is WaveTapAnimation) {
      releaseDuration = tapAnim.duration;
    }

    _pressController =
        AnimationController(vsync: this, duration: pressDuration);
    _releaseController =
        AnimationController(vsync: this, duration: releaseDuration);

    var hoverDuration = const Duration(milliseconds: 200);
    final hover = widget.hoverAnimation;
    if (hover is HoverScaleAnimation) hoverDuration = hover.duration;
    if (hover is HoverLiftAnimation) hoverDuration = hover.duration;
    if (hover is HoverGlowAnimation) hoverDuration = hover.duration;

    _hoverController =
        AnimationController(vsync: this, duration: hoverDuration);

    _shimmerController = AnimationController(
      vsync: this,
      duration: widget.hoverAnimation is HoverShimmerAnimation
          ? (widget.hoverAnimation as HoverShimmerAnimation).duration
          : const Duration(milliseconds: 1500),
    );

    _longPressController =
        AnimationController(vsync: this, duration: widget.longPressDuration);

    _longPressController.addStatusListener((status) {
      if (status == AnimationStatus.completed && !_longPressTriggered) {
        _longPressTriggered = true;
        widget.onLongPress?.call();
      }
    });
  }

  @override
  void dispose() {
    _pressController.dispose();
    _releaseController.dispose();
    _hoverController.dispose();
    _shimmerController.dispose();
    _longPressController.dispose();
    _pressPositionNotifier.dispose();
    super.dispose();
  }

  ButtonShape _resolveShape() {
    return widget.shape ??
        ButtonShape.roundedRectangle(radius: widget.borderRadius);
  }

  void _handlePointerDown(PointerDownEvent event) {
    _pressController
      ..stop()
      ..reset();
    _releaseController
      ..stop()
      ..reset();
    _longPressController
      ..stop()
      ..reset();

    _longPressTriggered = false;

    setState(() {
      _isPressed = true;
    });

    _pressPositionNotifier.value = event.localPosition;

    _pressController.forward();

    widget.onPressed?.call();

    if (widget.onLongPress != null) {
      _longPressController.forward();
    }
  }

  void _handlePointerMove(PointerMoveEvent event) {
    if (!_isPressed) return;

    final now = DateTime.now().microsecondsSinceEpoch;
    if (now - _lastMoveMicros < 16000) return;
    _lastMoveMicros = now;

    _pressPositionNotifier.value = event.localPosition;
  }

  void _handlePointerUp(PointerUpEvent event) {
    if (!mounted) return;

    _longPressController
      ..stop()
      ..reset();

    setState(() => _isPressed = false);

    _pressController.reverse();
    _releaseController.forward();

    widget.onPressedUp?.call();

    var clearDelay = const Duration(milliseconds: 650);
    final tapAnim = widget.tapAnimation;

    if (tapAnim is JellyTapAnimation) {
      clearDelay = tapAnim.releaseDuration + const Duration(milliseconds: 50);
    } else if (tapAnim is RippleTapAnimation) {
      clearDelay = tapAnim.duration + const Duration(milliseconds: 50);
    }

    Future.delayed(clearDelay, () {
      if (mounted && !_isPressed) {
        _pressPositionNotifier.value = null;
      }
    });
  }

  void _handlePointerCancel(PointerCancelEvent event) {
    if (!mounted) return;

    _longPressController
      ..stop()
      ..reset();

    setState(() => _isPressed = false);

    _pressController.reverse();
    _releaseController.forward();
  }

  void _handlePointerEnter(PointerEvent event) {
    if (!mounted) return;

    setState(() => _isHovered = true);

    _hoverController.forward();

    if (widget.hoverAnimation is HoverShimmerAnimation) {
      _shimmerController.repeat();
    }
  }

  void _handlePointerExit(PointerEvent event) {
    if (!mounted) return;

    setState(() => _isHovered = false);

    _hoverController.reverse();

    if (widget.hoverAnimation is HoverShimmerAnimation) {
      _shimmerController
        ..stop()
        ..reset();
    }
  }

  Widget _buildPaintedContent() {
    final shape = _resolveShape();
    final effectiveGradient =
        widget.gradient ?? (widget.color == null ? defaultGradient : null);

    final childWithPadding = Padding(
      padding: widget.padding,
      child: Center(child: widget.child),
    );

    final childLayout = (widget.width != null || widget.height != null)
        ? SizedBox.expand(child: childWithPadding)
        : childWithPadding;

    final animation = Listenable.merge([
      _pressController,
      _releaseController,
      _hoverController,
      _shimmerController,
      _longPressController,
      _pressPositionNotifier,
    ]);

    return AnimatedBuilder(
      animation: animation,
      builder: (context, _) {
        return CustomPaint(
          painter: NewAnimatedButtonPainter(
            pressPosition: _pressPositionNotifier.value,
            pressProgress: _pressController.value,
            releaseProgress: _releaseController.value,
            hoverProgress: _hoverController.value,
            shimmerProgress: _shimmerController.value,
            longPressProgress: _longPressController.value,
            gradient: effectiveGradient,
            color: widget.color,
            isPressed: _isPressed,
            isHovered: _isHovered,
            tapAnimation: widget.tapAnimation,
            hoverAnimation: widget.hoverAnimation,
            hasLongPress: widget.onLongPress != null,
            enableGlassmorphism: widget.enableGlassmorphism,
            shape: shape,
            shadow: widget.shadow,
          ),
          child: childLayout,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget buttonWidget = _buildPaintedContent();

    if (widget.tapAnimation is ScaleTapAnimation && _isPressed) {
      final anim = widget.tapAnimation as ScaleTapAnimation;
      buttonWidget = AnimatedBuilder(
        animation: _pressController,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 - (1.0 - anim.scaleAmount) * _pressController.value,
            child: child,
          );
        },
        child: buttonWidget,
      );
    }

    if (widget.tapAnimation is BounceTapAnimation) {
      final anim = widget.tapAnimation as BounceTapAnimation;
      buttonWidget = AnimatedBuilder(
        animation: _releaseController,
        builder: (context, child) {
          final offset = _releaseController.value < 1.0
              ? math.sin(_releaseController.value * math.pi) * anim.bounceHeight
              : 0.0;
          return Transform.translate(offset: Offset(0, -offset), child: child);
        },
        child: buttonWidget,
      );
    }

    if (widget.hoverAnimation is HoverScaleAnimation && _isHovered) {
      final anim = widget.hoverAnimation as HoverScaleAnimation;
      buttonWidget = AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform.scale(
            scale: 1.0 + (anim.scaleAmount - 1.0) * _hoverController.value,
            child: child,
          );
        },
        child: buttonWidget,
      );
    }

    if (widget.hoverAnimation is HoverLiftAnimation && _isHovered) {
      final anim = widget.hoverAnimation as HoverLiftAnimation;
      buttonWidget = AnimatedBuilder(
        animation: _hoverController,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, -anim.liftHeight * _hoverController.value),
            child: child,
          );
        },
        child: buttonWidget,
      );
    }

    final sizedButton = (widget.width != null || widget.height != null)
        ? SizedBox(
            width: widget.width, height: widget.height, child: buttonWidget)
        : IntrinsicWidth(child: IntrinsicHeight(child: buttonWidget));

    return MouseRegion(
      onEnter: _handlePointerEnter,
      onExit: _handlePointerExit,
      child: Listener(
        onPointerDown: _handlePointerDown,
        onPointerMove: _handlePointerMove,
        onPointerUp: _handlePointerUp,
        onPointerCancel: _handlePointerCancel,
        child: sizedButton,
      ),
    );
  }
}
