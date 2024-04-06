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
                    Container(width: 40, height: 2, color: Colors.black),
                    ExhibitBuilder(
                      builder: (k) => Container(
                        color: k.nBool('id', initialValue: false)
                            ? Colors.red
                            : Colors.black,
                        height: 20,
                        width: 20,
                      ),
                    ),
                    Container(width: 40, height: 2, color: Colors.black),
                    ExhibitBuilder(
                      builder: (k) => Text(
                        k.string(
                          'id',
                          initialValue: 'Testing',
                        ),
                      ),
                    ),
                    Container(width: 40, height: 2, color: Colors.black),
                    ExhibitBuilder(
                      builder: (k) => Cool(
                        aNumber: k.nInteger(
                          'id',
                          defaultValue: 1,
                          startAsNull: false,
                        ),
                        // bNumber: 1,
                        bNumber: k.integer('id-2', initialValue: 12),
                      ),
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

class Cool extends StatelessWidget {
  const Cool({
    super.key,
    required this.aNumber,
    required this.bNumber,
  });

  final int? aNumber;
  final int bNumber;
  @override
  Widget build(BuildContext context) {
    if (aNumber == null) {
      return const Text('aNumber null');
    } else {
      return Text((aNumber! + bNumber).toString());
    }
  }
}
