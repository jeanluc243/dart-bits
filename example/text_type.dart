import 'package:dart_bits/text_type_bit.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Scaffold(
        // backgroundColor: Colors.black,
        body: Center(
          child: TextTypeBit(
            text: ['Welcome to Dart Bits!', 'Animated components FTW 🚀'],
            textColors: [Colors.tealAccent, Colors.pinkAccent],
            typingSpeed: Duration(milliseconds: 60),
            deletingSpeed: Duration(milliseconds: 40),
            pauseDuration: Duration(seconds: 2),
            loop: true,
            cursorCharacter: '|',
            cursorBlinkDuration: Duration(milliseconds: 400),
            variableSpeed: {'min': 30, 'max': 90},
            reverseMode: false,
            onSentenceComplete: null,
          ),
        ),
      ),
    );
  }
}
