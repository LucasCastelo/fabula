import 'package:flutter/material.dart';
import 'package:fabula/src/widgets/general/knob_label.dart';

class TogglerField<T> extends StatelessWidget {
  const TogglerField({
    super.key,
    required this.label,
    required this.getValue,
    required this.onChange,
    required this.onValue,
    required this.offValue,
    this.description,
  });
  final String label;
  final ValueGetter<T> getValue;
  final ValueSetter<T> onChange;
  final T onValue;
  final T offValue;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        KnobLabel(label: label, description: description),
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
