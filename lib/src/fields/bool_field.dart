import 'package:flutter/material.dart';

// Ugly make it pretty
class BoolField extends StatelessWidget {
  const BoolField({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool? value;
  final ValueSetter<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: value == null ? null : () => onChanged(!value!),
      child: value == null
          ? const Text('NULL')
          : Text(
              value! ? 'True' : "False",
            ),
    );
  }
}
