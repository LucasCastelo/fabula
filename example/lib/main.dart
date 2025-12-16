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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ExhibitGallery(
        appBar: AppBar(
          title: const Text('Exhibit Gallery'),
        ),
        children: [
          ExhibitBuilder(
            label: 'String Basic Example',
            tags: [
              ExhibitTag(label: 'String', color: Colors.blue),
            ],
            builder: (k) => Text(
              k.string(
                'id',
                decoration: KnobTextFieldDecoration(label: 'Text above'),
              ),
            ),
          ),
          ExhibitBuilder(
            label: 'String Nullable Example',
            tags: [
              ExhibitTag(label: 'String', color: Colors.blue),
              ExhibitTag(label: 'Nullable', color: Colors.red),
            ],
            builder: (k) => Text(
              k.nString(
                    'id',
                    decoration: KnobTextFieldDecoration(
                      label: 'Cool text field',
                      placeholder: 'E.g.: Test Value',
                    ),
                  ) ??
                  'NULL',
            ),
          ),
          ExhibitBuilder(
            label: 'Boolean Example',
            tags: [
              ExhibitTag(label: 'Boolean', color: Colors.green),
            ],
            builder: (k) => Container(
              color: k.boolean(
                'id',
                label: 'Change Color of box above',
              )
                  ? Colors.red
                  : Colors.black,
              height: 20,
              width: 20,
            ),
          ),
          ExhibitBuilder(
            label: 'Integer Example (Nullable and non-nullable)',
            tags: [
              ExhibitTag(label: 'Integer', color: Colors.purple),
              ExhibitTag(label: 'nullable', color: Colors.red),
            ],
            builder: (k) => IntTest(
              aNumber: k.nInteger(
                'id',
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
              ),
            ),
          ),
          ExhibitBuilder(
            label: 'Selectable Example',
            tags: [
              ExhibitTag(label: 'Selectable', color: Colors.orange),
            ],
            builder: (k) => SelectableTester(
              colorEnum: k.selectable(
                'id',
                values: ColorEnum.values,
                nameMarshal: (colorEnum) => 'Name is: ${colorEnum.toString()}',
              ),
            ),
          ),
          ExhibitBuilder(
            label: 'Selectable Nullable Example',
            tags: [
              ExhibitTag(label: 'Selectable', color: Colors.orange),
              ExhibitTag(label: 'Nullable', color: Colors.red),
            ],
            builder: (k) => NSelectableTester(
              colorEnum: k.nSelectable(
                'id',
                values: ColorEnum.values,
                nameMarshal: (colorEnum) => 'Name is: ${colorEnum.toString()}',
              ),
            ),
          ),
          ExhibitBuilder(
            label: 'Color Example',
            tags: [
              ExhibitTag(label: 'Color', color: Colors.pink),
            ],
            builder: (k) => ColorTester(
              color: k.color(
                'id',
                label: 'Above color',
              ),
            ),
          ),
          ExhibitBuilder(
            label: 'Color Nullable Example',
            tags: [
              ExhibitTag(label: 'Color', color: Colors.pink),
              ExhibitTag(label: 'Nullable', color: Colors.red),
            ],
            builder: (k) => NullableColorTester(
              color: k.nColor(
                'id',
                label: 'Above color',
              ),
            ),
          ),
          ExhibitBuilder(
            label: 'List Example (Not working yet)',
            tags: [
              ExhibitTag(label: 'List', color: Colors.purple),
            ],
            builder: (k) => ListTester(
              list: k.listDefunct(
                'id',
                itemBuilder: (prefixId) => k.string('$prefixId-string'),
              ),
            ),
          ),
          ExhibitBuilder(
            label: 'Animation Example',
            tags: [
              ExhibitTag(label: 'Animation', color: Colors.teal),
            ],
            builder: (k) => AnimationTester(
              controller: k.animationController(
                id: 'animation',
                vsync: this,
                duration: const Duration(seconds: 5),
              ),
            ),
          ),
          ExhibitBuilder(
            label: 'Animation Example',
            entryType: ExhibitEntryType.popupMenu,
            tags: [
              ExhibitTag(label: 'Snackbar', color: Colors.orange),
            ],
            builder: (k) => AnimationTester(
              controller: k.animationController(
                id: 'animation',
                vsync: this,
                duration: const Duration(seconds: 5),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ListTester extends StatelessWidget {
  const ListTester({
    super.key,
    required this.list,
  });

  final List<String> list;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: list
          .map(
            (e) => Text(
              e,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          )
          .toList(),
    );
  }
}

class AnimationTester extends StatefulWidget {
  const AnimationTester({
    super.key,
    required this.controller,
  });

  final AnimationController controller;

  @override
  State<AnimationTester> createState() => _AnimationTesterState();
}

class _AnimationTesterState extends State<AnimationTester>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: widget.controller,
      builder: (_, value, ___) {
        return Container(
          height: 100,
          width: 100,
          color: Colors.red.withAlpha((255 * value).toInt()),
        );
      },
    );
  }
}

class NullableColorTester extends StatelessWidget {
  const NullableColorTester({
    super.key,
    required this.color,
  });

  final Color? color;

  @override
  Widget build(BuildContext context) {
    return color == null
        ? const Text('Color is null')
        : Container(
            height: 20,
            width: 20,
            color: color,
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
