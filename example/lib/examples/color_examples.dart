import 'package:flutter/material.dart';

class ColorExamples extends StatelessWidget {
  const ColorExamples({
    super.key,
    required this.aColor,
    required this.bColor,
    required this.cColor,
  });

  final Color aColor;
  final Color? bColor;
  final Color cColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [aColor, bColor, cColor].whereType<Color>().toList(),
        ),
      ),
      height: 20,
      width: 20,
    );
  }
}
