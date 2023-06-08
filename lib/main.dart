import 'package:flutter/material.dart';
import 'interest_calculator/interest_calculator.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Interest Calculator',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const InterestCalculator(),
    );
  }
}
