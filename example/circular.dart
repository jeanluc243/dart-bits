import 'package:dart_bits/circular_text_bit.dart';
import 'package:flutter/material.dart';
// import 'circular_text_bit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Circular Text Animated Demo',
      home: Scaffold(
        appBar: AppBar(title: const Text('Dart Bits - Circular Text Animated')),
        body: Center(
          child: CircularTextBit(
            text: "DART*BITS*COMPONENTS*",
            radius: 120,

            textStyle: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
            clockwise: true,
            spinDuration: 20,
            onHover: HoverEffect.pause,
          ),
        ),
      ),
    );
  }
}
