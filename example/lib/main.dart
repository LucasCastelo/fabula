import 'package:flutter/material.dart';
import 'package:storyto/storyto.dart';

enum ColorEnum {
  green,
  red,
  blue,
  yellow,
  black;

  T map<T>({
    required T Function() green,
    required T Function() red,
    required T Function() blue,
    required T Function() yellow,
    required T Function() black,
  }) {
    switch (this) {
      case ColorEnum.black:
        return black();
      case ColorEnum.green:
        return green();
      case ColorEnum.red:
        return red();
      case ColorEnum.blue:
        return blue();
      case ColorEnum.yellow:
        return yellow();
    }
  }
}

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
                    ExhibitBuilder(
                      builder: (k) => NSelectableTester(
                        colorEnum: k.nSelectable(
                          'id',
                          values: ColorEnum.values,
                          startAsNull: false,
                          nameMarshal: (colorEnum) =>
                              'Name is: ${colorEnum.toString()}',
                        ),
                      ),
                    ),
                    ExhibitBuilder(
                      builder: (k) => SelectableTester(
                        colorEnum: k.selectable(
                          'id',
                          values: ColorEnum.values,
                          initialValue: ColorEnum.black,
                          nameMarshal: (colorEnum) =>
                              'Name is: ${colorEnum.toString()}',
                        ),
                      ),
                    ),
                    ExhibitBuilder(
                      builder: (k) => ColorTester(
                        color: k.color('id', initialValue: Colors.red),
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

class ColorTester extends StatelessWidget {
  const ColorTester({
    super.key,
    required this.color,
  });

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 20,
      width: 20,
      color: color,
    );
  }
}

class NSelectableTester extends StatelessWidget {
  const NSelectableTester({
    super.key,
    required this.colorEnum,
  });

  final ColorEnum? colorEnum;

  @override
  Widget build(BuildContext context) {
    if (colorEnum == null) {
      return const SizedBox(
        height: 40,
        width: 40,
        child: Text('NULL'),
      );
    }

    return Container(
      color: colorEnum!.map(
        green: () => Colors.green,
        red: () => Colors.red,
        blue: () => Colors.blue,
        yellow: () => Colors.yellow,
        black: () => Colors.black,
      ),
      height: 40,
      width: 40,
    );
  }
}

class SelectableTester extends StatelessWidget {
  const SelectableTester({
    super.key,
    required this.colorEnum,
  });

  final ColorEnum colorEnum;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colorEnum.map(
        green: () => Colors.green,
        red: () => Colors.red,
        blue: () => Colors.blue,
        yellow: () => Colors.yellow,
        black: () => Colors.black,
      ),
      height: 40,
      width: 40,
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
