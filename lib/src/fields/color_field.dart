import 'package:flutter/material.dart';
import 'package:fabula/src/entities/knob.dart';
import 'package:fabula/src/entities/knob_text_field_decoration.dart';
import 'package:fabula/src/helpers/hex_color.dart';
import 'package:fabula/src/widgets/general/custom_text_field.dart';
import 'package:fabula/src/widgets/predefined_colors_entry_point.dart';

class ColorField extends StatelessWidget {
  const ColorField({
    super.key,
    required this.knob,
    required this.label,
    this.keyboardType,
    this.predefinedColors,
    this.description,
  });
  final String label;
  final Knob<Color> knob;
  final TextInputType? keyboardType;
  final List<Color>? predefinedColors;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final currentHex = hexStringFor(knob.getValue());

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
        if (predefinedColors != null) ...[
          const SizedBox(height: 4),
          PredefinedColorsEntryPoint(
            colors: predefinedColors!,
            onColorSelected: (color) {
              knob.setValue(color);
            },
          ),
        ],
      ],
    );
  }
}
