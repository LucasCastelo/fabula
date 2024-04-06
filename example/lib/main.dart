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
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Builder(
              builder: (context) {
                return ListView(
                  children: [
                    ExhibitBuilder(
                      builder: (k) => Text(k.nString(
                            'id',
                            defaultValue: 'a',
                            startAsNull: false,
                          ) ??
                          'NULL'),
                    ),
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
