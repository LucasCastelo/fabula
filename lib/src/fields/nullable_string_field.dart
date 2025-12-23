import 'package:flutter/material.dart';
import 'package:storyto/src/entities/knob_text_field_decoration.dart';
import 'package:storyto/src/widgets/general/custom_text_field.dart';

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
        InkWell(
          onTap: toggleNull,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  isEnabled ? 'Disable/Null' : 'Enable',
                  style: TextStyle(
                    fontSize: 12,
                    color: isEnabled ? Colors.redAccent : Colors.green,
                  ),
                ),
                const Text(
                  'Optional',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
