import 'package:flutter/material.dart';
import 'package:storyto/src/fields/custom_text_field.dart';
import 'package:storyto/src/storyto/knob.dart';

class StringKnob with ChangeNotifier implements Knob<String> {
  StringKnob({
    this.initialValue = '',
  }) {
    controller = TextEditingController();
    controller.text = initialValue;
  }

  late TextEditingController controller;
  final String initialValue;

  @override
  void setValue(String value) => notifyListeners();

  @override
  String get value => controller.value.text;

  @override
  Widget knob() {
    return CustomTextField(
      controller: controller,
      onChanged: setValue,
    );
  }
}
