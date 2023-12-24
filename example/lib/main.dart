import 'package:example/bool_test.dart';
import 'package:example/double_test.dart';
import 'package:example/int_test.dart';
import 'package:example/list_test.dart';
import 'package:example/strings_test.dart';
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
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Builder(
              builder: (context) {
                return ListView(
                  children: const [
                    StringsTest(),
                    BoolTest(),
                    IntTest(),
                    DoubleTest(),
                    ListTest(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
