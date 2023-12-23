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
                  builder: (e) => BoolTest(
                    value: e.inputBool(
                      'abc',
                      initialValue: false,
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

class BoolTest extends StatelessWidget {
  const BoolTest({
    super.key,
    required this.value,
  });

  final bool value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      color: value ? Colors.black : Colors.blueGrey,
    );
  }
}
