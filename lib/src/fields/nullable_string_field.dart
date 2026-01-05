import 'package:flutter/material.dart';
import 'package:fabula/src/entities/knob_text_field_decoration.dart';
import 'package:fabula/src/widgets/general/custom_text_field.dart';
import 'package:fabula/src/widgets/nullable_toggler.dart';

class NullableTextField<T> extends StatelessWidget {
  const NullableTextField({
    super.key,
    required this.decoration,
    required this.initialValue,
    required this.toggleNull,
    required this.onChanged,
    required this.isEnabled,
    this.description,
  });

  final KnobTextFieldDecoration decoration;
  final String? initialValue;
  final ValueSetter<String> onChanged;
  final VoidCallback toggleNull;
  final bool isEnabled;
  final String? description;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        CustomTextField(
          decoration: decoration,
          initialValue: initialValue,
          isEnabled: isEnabled,
          onChanged: onChanged,
          keyboardType: TextInputType.number,
          description: description,
        ),
        NullableToggler(
          onClick: toggleNull,
          isEnabled: isEnabled,
        ),
      ],
    );
  }
}
