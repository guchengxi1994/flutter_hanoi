import 'package:flutter/material.dart';
import 'package:flutter_hanoi/components/board.dart';

void main() {
  runApp(const MaterialApp(
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: 500,
        height: 500,
        child: CustomPaint(painter: HanoiBoard()),
      ),
    );
  }
}
