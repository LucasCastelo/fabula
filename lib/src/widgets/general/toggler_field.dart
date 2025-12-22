import 'package:flutter/material.dart';

class TogglerField<T> extends StatelessWidget {
  const TogglerField({
    super.key,
    required this.label,
    required this.getValue,
    required this.onChange,
    required this.onValue,
    required this.offValue,
  });
  final String label;
  final ValueGetter<T> getValue;
  final ValueSetter<T> onChange;
  final T onValue;
  final T offValue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(label),
        Checkbox(
          side: WidgetStateBorderSide.resolveWith(
            (states) => BorderSide(
              color:
                  getValue() == onValue ? Colors.transparent : Colors.black26,
            ),
          ),
          checkColor: Colors.white,
          fillColor: WidgetStatePropertyAll(
            getValue() == onValue ? Colors.green : Colors.black12,
          ),
          activeColor: Colors.green,
          overlayColor: const WidgetStatePropertyAll(Colors.green),
          value: getValue() == onValue,
          onChanged: (v) => onChange(
            v ?? true ? onValue : offValue,
          ),
        ),
      ],
    );
  }
}
