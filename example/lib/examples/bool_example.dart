import 'package:flutter/material.dart';

class BoolExample extends StatelessWidget {
  const BoolExample({super.key, required this.value});

  final bool value;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: value ? Colors.red : Colors.black,
      height: 20,
      width: 20,
    );
  }
}
