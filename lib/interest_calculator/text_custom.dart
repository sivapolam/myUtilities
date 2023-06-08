import 'package:flutter/material.dart';

class TextCustom extends StatelessWidget {
  const TextCustom(this.text, {super.key});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
    );
  }
}
