import 'package:flutter/material.dart';
import 'package:storyto/src/entities/knob_text_field_decoration.dart';
import 'package:storyto/src/widgets/general/custom_checkbox.dart';
import 'package:storyto/src/widgets/general/custom_text_field.dart';

class NullableTextField<T> extends StatelessWidget {
  const NullableTextField({
    super.key,
    required this.decoration,
    required this.initialValue,
    required this.toggleNull,
    required this.onChanged,
    required this.isEnabled,
  });

  final KnobTextFieldDecoration decoration;
  final String initialValue;
  final ValueSetter<String> onChanged;
  final VoidCallback toggleNull;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: CustomTextField(
            decoration: decoration,
            initialValue: initialValue,
            isEnabled: isEnabled,
            onChanged: onChanged,
            keyboardType: TextInputType.number,
          ),
        ),
        CustomCheckbox(
          value: isEnabled,
          onChanged: (_) => toggleNull(),
        )
      ],
    );
  }
}
