import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:storyto/src/entities/knob.dart';
import 'package:storyto/src/entities/knob_text_field_decoration.dart';
import 'package:storyto/src/widgets/general/custom_text_field.dart';

// TODO: Allow more ways of selection of colors
// E.g: Color picker, color wheel, etc.
class ColorField extends StatelessWidget {
  ColorField({
    super.key,
    required this.knob,
    required this.label,
    this.description,
    this.keyboardType,
    this.predefinedColors,
  });
  final String label;
  final String? description;
  final KnobValue<Color> knob;
  final TextInputType? keyboardType;
  final List<Color>? predefinedColors;

  final controller = TextEditingController();

  Color hexToColor(String hexString) => Color(int.parse("0xff$hexString"));

  @override
  Widget build(BuildContext context) {
    final currentHexColor =
        knob.getValue().toARGB32().toRadixString(16).replaceRange(0, 2, '');
    final hexRegEx = RegExp(r'^[0-9a-fA-F]{6}$');

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: CustomTextField(
                value: currentHexColor,
                description: description,
                onChanged: (v) {
                  if (hexRegEx.hasMatch(v)) {
                    knob.setValue(hexToColor(v));
                  }
                },
                keyboardType: keyboardType,
                isEnabled: true,
                initialValue: currentHexColor,
                decoration: KnobTextFieldDecoration(label: label),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(4),
                color: knob.getValue(),
              ),
              height: 48,
              width: 48,
            )
          ],
        ),
        if (predefinedColors != null) ...[
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: predefinedColors!
                .map(
                  (color) => GestureDetector(
                    onTap: () => knob.setValue(color),
                    child: Container(
                      height: 24,
                      width: 24,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        color: knob.getValue() == color
                            ? color
                            : color.withAlpha((255 * 0.4).toInt()),
                      ),
                    ),
                  ),
                )
                .toList(),
          ),
        ],
      ],
    );
  }
}
