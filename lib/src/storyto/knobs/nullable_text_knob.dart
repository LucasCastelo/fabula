import 'package:flutter/material.dart';
import 'package:storyto/src/fields/custom_text_field.dart';
import 'package:storyto/src/storyto/knob.dart';

class NullableTextKnob<T> with ChangeNotifier implements Knob {
  NullableTextKnob({
    required this.initialValue,
    required this.marshal,
    required this.isNullable,
  }) {
    controller = TextEditingController();
    controller.text = initialValue.toString();
  }

  late TextEditingController controller;
  final T? initialValue;
  final T? Function(String e) marshal;
  final bool isNullable;

  bool isNull = false;

  @override
  Widget knob() {
    return Row(
      children: [
        Expanded(
          child: CustomTextField(
            controller: controller,
            onChanged: setValue,
          ),
        ),
        if (isNullable)
          GestureDetector(
            onTap: () => setNull(!isNull),
            child: const Text('Toggle Null'),
          )
      ],
    );
  }

  void setNull(bool value) {
    isNull = value;
    notifyListeners();
  }

  @override
  void setValue(value) => notifyListeners();

  @override
  T? get value => isNull ? null : marshal(controller.value.text);
}
