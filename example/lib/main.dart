import 'package:example/examples/animation_example.dart';
import 'package:example/examples/bool_example.dart';
import 'package:example/examples/color_examples.dart';
import 'package:example/examples/full_page_example.dart';
import 'package:example/examples/integer_example.dart';
import 'package:example/examples/selectable_example.dart';
import 'package:example/examples/string_example.dart';
import 'package:example/examples/toggler_example.dart';
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
          Exhibit.page(
            label: 'String Example',
            tags: [
              ExhibitTag(label: 'String', color: Colors.blue),
              ExhibitTag(label: 'Nullable', color: Colors.red),
            ],
            builder: (k) => StringExample(
              place: k.string(
                'place',
                description: 'This is a description of the string field.',
                decoration: KnobTextFieldDecoration(
                  label: 'Place',
                ),
              ),
              car: k.nString(
                'car',
                description:
                    'This is a description of the nullable string field.',
                decoration: KnobTextFieldDecoration(
                  label: 'Insert your vehicle',
                ),
              ),
            ),
          ),
          Exhibit.page(
            label: 'Boolean Example',
            tags: [
              ExhibitTag(label: 'Boolean', color: Colors.green),
            ],
            builder: (k) => BoolExample(
              value: k.boolean(
                'id',
                label: 'Change Color of box above.',
                description: 'This is a description of the boolean field.',
                initialValue: false,
              ),
            ),
          ),
          Exhibit.page(
            label: 'Integer Example (Nullable and non-nullable)',
            tags: [
              ExhibitTag(label: 'Integer', color: Colors.purple),
              ExhibitTag(label: 'nullable', color: Colors.red),
            ],
            builder: (k) =>
                IntegerExample(foo: k.integer('foo'), bar: k.nInteger('bar')),
          ),
          Exhibit.page(
            label: 'Selectable Example',
            tags: [
              ExhibitTag(label: 'Selectable', color: Colors.orange),
            ],
            builder: (k) => SelectableExample(
              food: k.selectable(
                'food',
                values: [
                  Food(name: 'Pizza'),
                  Food(name: 'Burger'),
                  Food(name: 'Pasta'),
                  Food(name: 'Salad'),
                  Food(name: 'Sushi'),
                  Food(name: 'Taco'),
                  Food(name: 'Nachos'),
                  Food(name: 'Enchiladas'),
                  Food(name: 'Tacos'),
                  Food(name: 'Nachos'),
                  Food(name: 'Enchiladas'),
                  Food(name: 'Tacos'),
                ],
                nameMarshal: (v) => v.name,
              ),
              restaurant: k.nSelectable(
                'Restaurant',
                values: Restaurant.values,
                nameMarshal: (v) => v.toString(),
              ),
            ),
          ),
          Exhibit.page(
            label: 'Color Example',
            tags: [
              ExhibitTag(label: 'Color', color: Colors.pink),
              ExhibitTag(label: 'Predefined Colors', color: Colors.yellow),
            ],
            builder: (k) => ColorExamples(
              aColor: k.color(
                'Starting color of the gradient',
                predefinedColors: [
                  Colors.red,
                  Colors.green,
                  Colors.blue,
                  Colors.yellow,
                  Colors.purple,
                  Colors.orange,
                  Colors.brown
                ],
              ),
              bColor: k.nColor('Middle color of the gradient (nullable)'),
              cColor: k.color('Ending color of the gradient'),
            ),
          ),
          Exhibit.raw(
            label: 'Full Page Example',
            tags: [
              ExhibitTag(label: 'Full Page', color: Colors.pink),
              ExhibitTag(label: 'Animation', color: Colors.blue),
              ExhibitTag(label: 'Gradient', color: Colors.green),
              ExhibitTag(label: 'String', color: Colors.orange),
              ExhibitTag(label: 'Color', color: Colors.purple),
            ],
            builder: (k) => FullPageExample(
              title: k.string('title'),
              description: k.string('description'),
              color: k.color('color', initialValue: Colors.blueGrey),
              gradientColors: [
                k.color('gradientColor 1', initialValue: Colors.red),
                k.color('gradientColor 2', initialValue: Colors.green),
                k.color('gradientColor 3', initialValue: Colors.blue),
              ],
              animationController: k.animationController(
                'animationController',
                vsync: this,
                duration: const Duration(seconds: 5),
              ),
            ),
          ),
          Exhibit.page(
            label: 'Animation Example',
            tags: [
              ExhibitTag(label: 'Animation', color: Colors.teal),
              ExhibitTag(label: 'Color', color: Colors.pink),
            ],
            builder: (k) => AnimationExample(
              controller: k.animationController('animation', vsync: this),
              color: k.color('color', initialValue: Colors.red),
            ),
          ),
          Exhibit.page(
            label: 'Toggler Example',
            tags: [
              ExhibitTag(label: 'Toggler', color: Colors.purple),
            ],
            builder: (k) => TogglerExample(
              value: k.toggler(
                'value',
                label: 'Change the value of the toggler',
                onValue: 'Car is on',
                offValue: 'Car is off',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
