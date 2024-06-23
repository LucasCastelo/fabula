import 'package:flutter/material.dart';
import 'package:storyto/src/entities/knob_text_field_decoration.dart';
import 'package:storyto/src/widgets/custom_checkbox.dart';
import 'package:storyto/src/widgets/custom_text_field.dart';

class NullableTextField<T> extends StatelessWidget {
  const NullableTextField({
    super.key,
    required this.decoration,
    required this.initialValue,
    required this.toggleNull,
    required this.valueGetter,
    required this.onChanged,
  });

  final KnobTextFieldDecoration decoration;
  final String initialValue;
  final ValueGetter<T> valueGetter;
  final ValueSetter<String> onChanged;
  final VoidCallback toggleNull;

  @override
  Widget build(BuildContext context) {
    final value = valueGetter();
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: CustomTextField(
            decoration: decoration,
            initialValue: initialValue,
            isEnabled: value != null,
            onChanged: onChanged,
            keyboardType: TextInputType.number,
          ),
        ),
        CustomCheckbox(
          value: value != null,
          onChanged: (_) => toggleNull(),
        )
      ],
    );
  }
}
