import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

class TextTypeBit extends StatefulWidget {
  final List<String> text;
  final Duration typingSpeed;
  final Duration deletingSpeed;
  final Duration initialDelay;
  final Duration pauseDuration;
  final bool loop;
  final bool showCursor;
  final bool hideCursorWhileTyping;
  final String cursorCharacter;
  final Duration cursorBlinkDuration;
  final TextStyle? textStyle;
  final List<Color>? textColors;
  final bool startOnVisible;
  final bool reverseMode;
  final void Function(String sentence, int index)? onSentenceComplete;
  final Map<String, int>? variableSpeed;

  const TextTypeBit({
    super.key,
    required this.text,
    this.typingSpeed = const Duration(milliseconds: 50),
    this.deletingSpeed = const Duration(milliseconds: 30),
    this.initialDelay = Duration.zero,
    this.pauseDuration = const Duration(milliseconds: 2000),
    this.loop = true,
    this.showCursor = true,
    this.hideCursorWhileTyping = false,
    this.cursorCharacter = '|',
    this.cursorBlinkDuration = const Duration(milliseconds: 500),
    this.textStyle,
    this.textColors,
    this.startOnVisible = false,
    this.reverseMode = false,
    this.onSentenceComplete,
    this.variableSpeed,
  });

  @override
  State<TextTypeBit> createState() => _TextTypeBitState();
}

class _TextTypeBitState extends State<TextTypeBit> {
  int sentenceIndex = 0;
  String displayedText = '';
  bool isTyping = true;
  bool showCursor = true;
  Timer? _cursorTimer;

  @override
  void initState() {
    super.initState();
    if (!widget.startOnVisible) {
      Future.delayed(widget.initialDelay, _startTyping);
    }
    if (widget.showCursor) {
      _cursorTimer = Timer.periodic(widget.cursorBlinkDuration, (_) {
        setState(() {
          showCursor = !showCursor;
        });
      });
    }
  }

  Future<void> _startTyping() async {
    while (true) {
      String fullText = widget.text[sentenceIndex];
      final buffer = StringBuffer();
      for (int i = 0; i < fullText.length; i++) {
        await Future.delayed(_getTypingSpeed());
        buffer.write(
          widget.reverseMode ? fullText[fullText.length - i - 1] : fullText[i],
        );
        setState(() {
          displayedText = buffer.toString();
        });
      }

      widget.onSentenceComplete?.call(fullText, sentenceIndex);
      await Future.delayed(widget.pauseDuration);

      // Deleting
      while (buffer.isNotEmpty) {
        await Future.delayed(widget.deletingSpeed);
        String currentText = buffer.toString();
        buffer.clear();
        buffer.write(currentText.substring(0, currentText.length - 1));
        setState(() {
          displayedText = buffer.toString();
        });
      }

      sentenceIndex = (sentenceIndex + 1) % widget.text.length;
      if (!widget.loop && sentenceIndex == 0) break;
    }
  }

  Duration _getTypingSpeed() {
    if (widget.variableSpeed != null) {
      final random = Random();
      final min = widget.variableSpeed!['min'] ?? 30;
      final max = widget.variableSpeed!['max'] ?? 70;
      return Duration(milliseconds: min + random.nextInt(max - min));
    }
    return widget.typingSpeed;
  }

  @override
  void dispose() {
    _cursorTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentColor =
        widget.textColors != null && sentenceIndex < widget.textColors!.length
        ? widget.textColors![sentenceIndex]
        : Colors.white;

    return Text(
      '${displayedText}${(widget.showCursor && !(widget.hideCursorWhileTyping && isTyping) && showCursor) ? widget.cursorCharacter : ''}',
      style:
          widget.textStyle?.copyWith(color: currentColor) ??
          TextStyle(fontSize: 24, color: currentColor),
      textAlign: TextAlign.center,
    );
  }
}
