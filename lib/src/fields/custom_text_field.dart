import 'package:flutter/material.dart';
import 'package:storyto/src/knob.dart';

class KnobTextField extends StatelessWidget {
  KnobTextField({
    super.key,
    required this.knob,
    this.keyboardType,
  });

  final Knob knob;
  final TextInputType? keyboardType;

  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: knob,
      builder: (BuildContext context, value, Widget? child) {
        if (value != controller.value.text) {
          controller.text = knob.getValue() ?? '';
        }

        return TextField(
          enabled: value != null,
          controller: controller,
          onChanged: knob.setValue,
          style: const TextStyle(),
          keyboardType: keyboardType,
        );
      },
    );
  }
}
