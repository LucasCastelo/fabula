import 'package:flutter/material.dart';
import 'package:fabula/src/entities/knob.dart';
import 'package:fabula/src/entities/knob_text_field_decoration.dart';
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

  Color hexToColor(String hexString) => Color(int.parse("0xff$hexString"));

  @override
  Widget build(BuildContext context) {
    final currentHexColor =
        knob.getValue()?.toARGB32().toRadixString(16).replaceRange(0, 2, '');
    final hexRegEx = RegExp(r'^[0-9a-fA-F]{6}$');

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
                    maxLength: 6,
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
                      if (hexRegEx.hasMatch(v)) {
                        knob.setValue(hexToColor(v));
                      }
                    },
                    description: description,
                    keyboardType: TextInputType.multiline,
                    isEnabled: knob.isFieldEnabled,
                    initialValue: currentHexColor,
                    decoration: KnobTextFieldDecoration(label: label),
                    value: currentHexColor,
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
