import 'dart:math' as math;
import 'package:flutter/material.dart';

enum HoverEffect { slowDown, speedUp, pause, goBonkers, undefined }

class CircularTextBit extends StatefulWidget {
  final String text;
  final double radius;
  final TextStyle? textStyle;
  final bool clockwise;
  final double spinDuration; // en secondes pour un tour complet
  final HoverEffect onHover;

  const CircularTextBit({
    super.key,
    required this.text,
    this.radius = 100,
    this.textStyle,
    this.clockwise = true,
    this.spinDuration = 10.0,
    this.onHover = HoverEffect.undefined,
  });

  @override
  State<CircularTextBit> createState() => _CircularTextBitState();
}

class _CircularTextBitState extends State<CircularTextBit>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late double _baseDuration;

  @override
  void initState() {
    super.initState();
    _baseDuration = widget.spinDuration;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: (_baseDuration * 1000).toInt()),
    )..repeat();
  }

  @override
  void didUpdateWidget(covariant CircularTextBit oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.spinDuration != widget.spinDuration) {
      _baseDuration = widget.spinDuration;
      _controller.duration = Duration(
        milliseconds: (_baseDuration * 1000).toInt(),
      );
      _controller.repeat();
    }
    if (oldWidget.onHover != widget.onHover) {
      _applyHoverEffect(widget.onHover);
    }
  }

  void _applyHoverEffect(HoverEffect effect) {
    switch (effect) {
      case HoverEffect.pause:
        _controller.stop();
        break;
      case HoverEffect.slowDown:
        _controller.duration = Duration(
          milliseconds: (_baseDuration * 2000).toInt(),
        );
        if (!_controller.isAnimating) _controller.repeat();
        break;
      case HoverEffect.speedUp:
        _controller.duration = Duration(
          milliseconds: (_baseDuration * 500).toInt(),
        );
        if (!_controller.isAnimating) _controller.repeat();
        break;
      case HoverEffect.goBonkers:
        _controller.duration = Duration(
          milliseconds: (_baseDuration * 200).toInt(),
        );
        if (!_controller.isAnimating) _controller.repeat();
        break;
      case HoverEffect.undefined:
        _controller.duration = Duration(
          milliseconds: (_baseDuration * 1000).toInt(),
        );
        if (!_controller.isAnimating) _controller.repeat();
        break;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final maxChars = 24;
    String displayText = widget.text;
    if (displayText.length > maxChars) {
      displayText = displayText.substring(0, maxChars);
      debugPrint('Warning: CircularTextBit text truncated to 24 characters.');
    }

    final characters = displayText.characters.toList();
    final anglePerChar =
        2 * math.pi / characters.length * (widget.clockwise ? 1 : -1);

    return MouseRegion(
      onEnter: (_) => _applyHoverEffect(widget.onHover),
      onExit: (_) => _applyHoverEffect(HoverEffect.undefined),
      child: SizedBox(
        width: widget.radius * 2,
        height: widget.radius * 2,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            final rotationAngle =
                _controller.value * 2 * math.pi * (widget.clockwise ? 1 : -1);

            return Transform.rotate(
              angle: rotationAngle,
              child: Stack(
                alignment: Alignment.center,
                children: List.generate(characters.length, (index) {
                  final charAngle = anglePerChar * index - math.pi / 2;

                  return Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..translate(
                        widget.radius * math.cos(charAngle),
                        widget.radius * math.sin(charAngle),
                      )
                      ..rotateZ(charAngle + (widget.clockwise ? 0 : math.pi))
                      ..rotateZ(math.pi / 2),
                    child: Text(
                      characters[index],
                      style:
                          widget.textStyle ??
                          const TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  );
                }),
              ),
            );
          },
        ),
      ),
    );
  }
}
