import 'package:flutter/material.dart';

class TogglerField<T> extends StatelessWidget {
  const TogglerField({
    super.key,
    required this.getValue,
    required this.onChange,
    required this.onValue,
    required this.offValue,
  });
  final ValueGetter<T> getValue;
  final ValueSetter<T> onChange;
  final T onValue;
  final T offValue;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      side: MaterialStateBorderSide.resolveWith(
        (states) => BorderSide(
          color: getValue() == onValue ? Colors.transparent : Colors.black26,
        ),
      ),
      checkColor: Colors.white,
      fillColor: MaterialStatePropertyAll(
        getValue() == onValue ? Colors.green : Colors.black12,
      ),
      activeColor: Colors.green,
      overlayColor: const MaterialStatePropertyAll(Colors.green),
      value: getValue() == onValue,
      onChanged: (v) => onChange(
        v ?? true ? onValue : offValue,
      ),
    );
  }
}
