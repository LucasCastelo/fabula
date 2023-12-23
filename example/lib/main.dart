import 'package:flutter/material.dart';
import 'package:storyto/storyto.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              children: [
                ExhibitBuilder(
                  builder: (e) => Square(
                    text: e.string('Text', initialValue: 'abc'),
                  ),
                ),
                ExhibitBuilder(
                  builder: (e) => Text(
                    e.string('Text 2', initialValue: 'abc'),
                  ),
                ),
                ExhibitBuilder(
                  builder: (e) => Column(
                    children: List.generate(
                      e.integer(
                        'Count',
                        initialValue: 0,
                      ),
                      (index) => Text('Value: $index'),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Square extends StatelessWidget {
  const Square({
    super.key,
    required this.text,
    this.nullableText,
  });

  final String text;
  final String? nullableText;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      color: Colors.red,
      child: Column(
        children: [
          Text(text),
          if (nullableText != null) ...[
            Text(nullableText!),
            Container(
              width: 10,
              height: 10,
              color: Colors.amber,
            )
          ],
        ],
      ),
    );
  }
}

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.text,
    required this.textColor,
  });

  final VoidCallback onTap;
  final IconData icon;
  final String text;
  final Color textColor;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon),
          Text(
            text,
            style: TextStyle(
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }
}
