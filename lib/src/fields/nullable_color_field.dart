import 'package:flutter/material.dart';
import 'package:fabula/src/entities/knob.dart';
import 'package:fabula/src/entities/knob_text_field_decoration.dart';
import 'package:fabula/src/helpers/hex_color.dart';
import 'package:fabula/src/widgets/general/custom_text_field.dart';
import 'package:fabula/src/widgets/nullable_toggler.dart';
import 'package:fabula/src/widgets/predefined_colors_entry_point.dart';

class NullableColorField extends StatelessWidget {
  const NullableColorField({
    super.key,
    required this.knob,
    required this.label,
    required this.toggleNull,
    this.keyboardType,
    this.predefinedColors,
    this.description,
  });

  final String label;
  final NullableKnob<Color?> knob;
  final TextInputType? keyboardType;
  final VoidCallback toggleNull;
  final List<Color>? predefinedColors;
  final String? description;

  @override
  Widget build(BuildContext context) {
    final color = knob.getValue();
    final currentHex = color == null ? null : hexStringFor(color);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CustomTextField(
                    maxLength: 8,
                    suffix: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: (knob.getValue() ?? knob.lastKnowValue)
                            ?.withAlpha(
                                (knob.isFieldEnabled ? 255 : 50).toInt()),
                      ),
                      height: 18,
                      width: 18,
                    ),
                    onChanged: (v) {
                      final parsed = tryParseHexColor(v);
                      if (parsed != null) knob.setValue(parsed);
                    },
                    description: description,
                    keyboardType: TextInputType.text,
                    isEnabled: knob.isFieldEnabled,
                    initialValue: currentHex,
                    decoration: KnobTextFieldDecoration(label: label),
                    value: currentHex,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (predefinedColors != null)
                        PredefinedColorsEntryPoint(
                          colors: predefinedColors!,
                          onColorSelected: (color) => knob.setValue(color),
                        ),
                      NullableToggler(
                        onClick: toggleNull,
                        isEnabled: knob.isFieldEnabled,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
