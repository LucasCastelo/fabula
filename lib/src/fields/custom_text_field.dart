import 'package:flutter/material.dart';
import 'package:storyto/src/knobs/knob.dart';

typedef InputMarshal<T> = T Function(String v);

class KnobTextField extends StatelessWidget {
  KnobTextField({
    super.key,
    required this.knob,
    this.keyboardType,
    this.marshal,
  });

  final Knob knob;
  final TextInputType? keyboardType;
  final InputMarshal? marshal;

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: knob,
      builder: (BuildContext context, value, Widget? child) {
        if (value != controller.value.text) {
          controller.text = value is! String ? value.toString() : value;
        }

        return TextField(
          enabled: value != null,
          controller: controller,
          onChanged: marshal != null
              ? (v) => knob.setValue(marshal!(v))
              : knob.setValue,
          style: const TextStyle(),
          keyboardType: keyboardType,
        );
      },
    );
  }
}
