import 'package:dart_bits/split_text.dart';
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
        // backgroundColor: Colors.,
        body: Center(
          child: SplitTextBit(
            text: 'Hello, you!',
            delay: Duration(milliseconds: 80),
            duration: Duration(milliseconds: 1500),
            ease: Curves.elasticIn,
            from: {'opacity': 0, 'y': 40},
            to: {'opacity': 1, 'y': 0},
            textAlign: TextAlign.center,
            textStyle: TextStyle(
              color: Colors.black,
              fontSize: 42,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}
