import 'package:flutter/material.dart';
import 'dart:async';

class SplitTextBit extends StatefulWidget {
  final String text;
  final Duration delay; // delay entre chaque lettre
  final Duration duration; // durée de l’animation
  final Curve ease; // équivalent de "ease" GSAP
  final Map<String, double> from; // { opacity: 0, y: 40 }
  final Map<String, double> to; // { opacity: 1, y: 0 }
  final double threshold;
  final String rootMargin;
  final String splitType; // "chars", "words", etc.
  final TextAlign textAlign;
  final TextStyle? textStyle;
  final void Function()? onLetterAnimationComplete;

  const SplitTextBit({
    super.key,
    required this.text,
    this.delay = const Duration(milliseconds: 100),
    this.duration = const Duration(milliseconds: 600),
    this.ease = Curves.easeOut,
    this.from = const {'opacity': 0, 'y': 40},
    this.to = const {'opacity': 1, 'y': 0},
    this.threshold = 0.1,
    this.rootMargin = "-100px",
    this.splitType = "chars",
    this.textAlign = TextAlign.center,
    this.textStyle,
    this.onLetterAnimationComplete,
  });

  @override
  State<SplitTextBit> createState() => _SplitTextBitState();
}

class _SplitTextBitState extends State<SplitTextBit>
    with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];
  final List<Animation<double>> _opacities = [];
  final List<Animation<Offset>> _positions = [];

  @override
  void initState() {
    super.initState();
    final units = _splitText(widget.text, widget.splitType);
    for (var i = 0; i < units.length; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: widget.duration,
      );

      final opacityAnim = Tween<double>(
        begin: widget.from['opacity'] ?? 0,
        end: widget.to['opacity'] ?? 1,
      ).animate(CurvedAnimation(parent: controller, curve: widget.ease));

      final positionAnim = Tween<Offset>(
        begin: Offset(0, (widget.from['y'] ?? 0) / 100),
        end: Offset(0, (widget.to['y'] ?? 0) / 100),
      ).animate(CurvedAnimation(parent: controller, curve: widget.ease));

      _controllers.add(controller);
      _opacities.add(opacityAnim);
      _positions.add(positionAnim);

      Future.delayed(widget.delay * i, () {
        if (mounted) controller.forward();
        if (i == units.length - 1 && widget.onLetterAnimationComplete != null) {
          Future.delayed(
            widget.duration,
            () => widget.onLetterAnimationComplete?.call(),
          );
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  List<String> _splitText(String text, String type) {
    switch (type) {
      case 'words':
        return text.split(' ');
      case 'lines':
        return text.split('\n');
      case 'words, chars':
        return text.split(' ').expand((w) => w.split('')).toList();
      case 'chars':
      default:
        return text.characters.toList();
    }
  }

  @override
  Widget build(BuildContext context) {
    final units = _splitText(widget.text, widget.splitType);

    return Wrap(
      alignment: _convertTextAlign(widget.textAlign),
      children: List.generate(units.length, (i) {
        return SlideTransition(
          position: _positions[i],
          child: FadeTransition(
            opacity: _opacities[i],
            child: Text(
              units[i],
              style: widget.textStyle ?? const TextStyle(fontSize: 24),
            ),
          ),
        );
      }),
    );
  }

  WrapAlignment _convertTextAlign(TextAlign align) {
    switch (align) {
      case TextAlign.left:
        return WrapAlignment.start;
      case TextAlign.center:
        return WrapAlignment.center;
      case TextAlign.right:
        return WrapAlignment.end;
      default:
        return WrapAlignment.center;
    }
  }
}
