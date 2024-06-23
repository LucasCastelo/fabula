import 'package:flutter/material.dart';
import 'package:storyto/src/entities/knob.dart';

class ColorField extends StatelessWidget {
  ColorField({
    super.key,
    required this.knob,
    this.keyboardType,
  });

  final Knob<Color> knob;
  final TextInputType? keyboardType;

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: knob,
      builder: (BuildContext context, value, Widget? child) {
        final currentHexColor =
            value.value.toRadixString(16).replaceRange(0, 2, '');
        final hexRegEx = RegExp(r'^[0-9a-fA-F]{6}$');

        if (currentHexColor != controller.value.text) {
          controller.text = currentHexColor;
        }

        return TextField(
          controller: controller,
          onChanged: (v) {
            if (hexRegEx.hasMatch(v)) {
              knob.setValue(hexToColor('#$v'));
            }
          },
          style: const TextStyle(),
          keyboardType: keyboardType,
        );
      },
    );
  }
}

Color hexToColor(String hexString) {
  return Color(
    int.parse(
      hexString.replaceFirst('#', '0xFF'),
    ),
  );
}
