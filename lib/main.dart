import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            '機器管理システム',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blue,
        ),
      ),
    );
  }
}
