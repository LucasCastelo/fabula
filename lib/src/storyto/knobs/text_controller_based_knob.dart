import 'package:flutter/material.dart';
import 'package:storyto/src/fields/custom_text_field.dart';
import 'package:storyto/src/storyto/knob.dart';

class GenericKnob<T> with ChangeNotifier implements Knob {
  GenericKnob({
    required this.initialValue,
    required this.marshal,
  }) {
    controller = TextEditingController();
    controller.text = initialValue.toString();
  }

  late TextEditingController controller;
  final T initialValue;
  final T Function(String e) marshal;

  @override
  Widget knob() {
    return CustomTextField(
      controller: controller,
      onChanged: setValue,
    );
  }

  @override
  void setValue(value) => notifyListeners();

  @override
  T get value => marshal(controller.value.text);
}
