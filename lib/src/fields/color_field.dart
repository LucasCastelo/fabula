import 'package:flutter/material.dart';
import 'package:storyto/src/entities/knob.dart';
import 'package:storyto/src/entities/knob_text_field_decoration.dart';
import 'package:storyto/src/widgets/custom_text_field.dart';

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
    final currentHexColor =
        knob.getValue().value.toRadixString(16).replaceRange(0, 2, '');
    final hexRegEx = RegExp(r'^[0-9a-fA-F]{6}$');

    return CustomTextField(
      onChanged: (v) {
        if (hexRegEx.hasMatch(v)) {
          knob.setValue(hexToColor(v));
        }
      },
      keyboardType: keyboardType,
      isEnabled: true,
      initialValue: currentHexColor,
      decoration: KnobTextFieldDecoration(label: 'label'),
    );
  }
}

Color hexToColor(String hexString) {
  return Color(
    int.parse(
      "0xff$hexString",
    ),
  );
}
