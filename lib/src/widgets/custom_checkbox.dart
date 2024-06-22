import 'package:flutter/material.dart';

class CustomCheckbox extends StatelessWidget {
  const CustomCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
  });

  final bool value;
  final ValueSetter<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      side: MaterialStateBorderSide.resolveWith(
        (states) => BorderSide(
          color: value ? Colors.transparent : Colors.black26,
        ),
      ),
      checkColor: Colors.white,
      fillColor: MaterialStatePropertyAll(
        value ? Colors.green : Colors.black12,
      ),
      activeColor: Colors.green,
      overlayColor: const MaterialStatePropertyAll(Colors.green),
      value: value,
      onChanged: (v) => onChanged(v!),
    );
  }
}
