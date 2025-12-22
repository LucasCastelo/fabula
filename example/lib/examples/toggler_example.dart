import 'package:flutter/material.dart';

class TogglerExample extends StatelessWidget {
  const TogglerExample({
    super.key,
    required this.value,
  });

  final String value;

  @override
  Widget build(BuildContext context) {
    return Text(
      value,
      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
    );
  }
}
