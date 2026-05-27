import 'package:flutter/material.dart';
import 'package:fabula/src/widgets/general/custom_checkbox.dart';
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label),
                  if (description != null)
                    Text(
                      description!,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                ],
              ),
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
