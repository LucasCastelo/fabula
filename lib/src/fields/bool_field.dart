import 'package:flutter/material.dart';
import 'package:fabula/src/widgets/general/custom_checkbox.dart';
import 'package:fabula/src/widgets/general/knob_label.dart';
import 'package:fabula/src/widgets/general/touch.dart';

class BoolField extends StatelessWidget {
  const BoolField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.description,
  });

  final String label;
  final bool value;
  final ValueSetter<bool> onChanged;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Touch(
      semanticsLabel: label,
      onTap: () => onChanged(!value),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: KnobLabel(label: label, description: description),
            ),
            CustomCheckbox(
              value: value,
              onChanged: onChanged,
            ),
          ],
        ),
      ),
    );
  }
}
