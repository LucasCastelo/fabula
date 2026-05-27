import 'package:flutter/material.dart';

class SectionOrderingExample extends StatelessWidget {
  const SectionOrderingExample({
    super.key,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.textColor,
    required this.padding,
    required this.borderRadius,
  });

  final String title;
  final String subtitle;
  final Color backgroundColor;
  final Color textColor;
  final int padding;
  final int borderRadius;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(padding.toDouble()),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(borderRadius.toDouble()),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: TextStyle(
              color: textColor,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(color: textColor, fontSize: 14),
          ),
        ],
      ),
    );
  }
}
