import 'package:flutter/material.dart';
import 'package:fabula/src/entities/color_holster.dart';
import 'package:fabula/src/entities/knob.dart';
import 'package:fabula/src/entities/knob_text_field_decoration.dart';
import 'package:fabula/src/helpers/hex_color.dart';
import 'package:fabula/src/widgets/color_holster_picker.dart';
import 'package:fabula/src/widgets/general/custom_text_field.dart';

class ColorField extends StatelessWidget {
  const ColorField({
    super.key,
    required this.knob,
    required this.label,
    this.keyboardType,
    this.holsters,
    this.description,
  });

  final String label;
  final Knob<Color> knob;
  final TextInputType? keyboardType;
  final List<ColorHolster>? holsters;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final currentHex = hexStringFor(knob.getValue());
    final holsters = this.holsters;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CustomTextField(
          value: currentHex,
          description: description,
          maxLength: 8,
          suffix: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: knob.getValue(),
            ),
            height: 18,
            width: 18,
          ),
          onChanged: (v) {
            final parsed = tryParseHexColor(v);
            if (parsed != null) knob.setValue(parsed);
          },
          keyboardType: keyboardType,
          isEnabled: true,
          initialValue: currentHex,
          decoration: KnobTextFieldDecoration(label: label),
        ),
        if (holsters != null && holsters.isNotEmpty) ...[
          const SizedBox(height: 4),
          Align(
            alignment: Alignment.centerLeft,
            child: ColorHolsterPicker(
              holsters: holsters,
              onColorSelected: knob.setValue,
            ),
          ),
        ],
      ],
    );
  }
}
