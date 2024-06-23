import 'package:flutter/material.dart';
import 'package:storyto/src/entities/knob.dart';
import 'package:storyto/src/entities/knob_text_field_decoration.dart';
import 'package:storyto/src/widgets/custom_checkbox.dart';
import 'package:storyto/src/widgets/custom_text_field.dart';

class NullableColorField extends StatelessWidget {
  NullableColorField({
    super.key,
    required this.knob,
    required this.label,
    required this.toggleNull,
    this.keyboardType,
  });
  final String label;
  final Knob<Color?> knob;
  final TextInputType? keyboardType;
  final VoidCallback toggleNull;

  final controller = TextEditingController();

  Color hexToColor(String hexString) => Color(int.parse("0xff$hexString"));

  @override
  Widget build(BuildContext context) {
    final currentHexColor =
        knob.getValue()?.value.toRadixString(16).replaceRange(0, 2, '');
    final hexRegEx = RegExp(r'^[0-9a-fA-F]{6}$');

    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: CustomTextField(
            onChanged: (v) {
              if (hexRegEx.hasMatch(v)) {
                knob.setValue(hexToColor(v));
              }
            },
            keyboardType: keyboardType,
            isEnabled: currentHexColor != null,
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
        ),
        CustomCheckbox(
          value: currentHexColor != null,
          onChanged: (_) => toggleNull(),
        )
      ],
    );
  }
}
