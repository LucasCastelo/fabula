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
                    const Text('STRING'),
                    ExhibitBuilder(
                      builder: (k) => Text(
                        k.nString(
                              'id',
                              decoration: KnobTextFieldDecoration(
                                label: 'Cool text field',
                                placeholder: 'E.g.: Test Value',
                              ),
                              initialValue: 'a',
                              startAsNull: false,
                            ) ??
                            'NULL',
                      ),
                    ),
                    ExhibitBuilder(
                      builder: (k) => Container(
                        color: k.boolean(
                          'id',
                          label: 'Change Color of box above',
                          initialValue: false,
                        )
                            ? Colors.red
                            : Colors.black,
                        height: 20,
                        width: 20,
                      ),
                    ),
                    ExhibitBuilder(
                      builder: (k) => Text(
                        k.string(
                          'id',
                          initialValue: 'Testing',
                          decoration:
                              KnobTextFieldDecoration(label: 'Text above'),
                        ),
                      ),
                    ),
                    ExhibitBuilder(
                      builder: (k) => IntTest(
                        aNumber: k.nInteger(
                          'id',
                          initialValue: 1,
                          startAsNull: false,
                          decoration: KnobTextFieldDecoration(
                            label: 'Will add with the number below',
                          ),
                        ),
                        bNumber: k.integer(
                          'id-2',
                          decoration: KnobTextFieldDecoration(
                            label: 'Will add to number above',
                            placeholder: 'E.g.: 1',
                          ),
                          initialValue: 12,
                        ),
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
                        color: k.color(
                          'id',
                          label: 'Above color',
                          initialValue: Colors.red,
                        ),
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

class IntTest extends StatelessWidget {
  const IntTest({
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
