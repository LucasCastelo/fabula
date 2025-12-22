import 'package:flutter/material.dart';

class IntegerExample extends StatelessWidget {
  const IntegerExample({
    super.key,
    required this.foo,
    required this.bar,
  });

  final int foo;
  final int? bar;

  @override
  Widget build(BuildContext context) {
    return Text(
      bar == null
          ? 'bar is null'
          : '$foo + ${bar!} = ${(foo + bar!).toString()}',
      style: const TextStyle(
        fontSize: 20,
        color: Colors.black,
      ),
      textAlign: TextAlign.center,
    );
  }
}
