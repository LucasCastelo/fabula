import 'package:flutter/cupertino.dart';
import 'package:storyto/src/fields/custom_text_field.dart';
import 'package:storyto/src/storyto/knob.dart';

// Can probably be merged with string using generics for parsing ?
class IntKnob with ChangeNotifier implements Knob {
  IntKnob({
    this.initialValue = 0,
  }) {
    controller = TextEditingController();
    controller.text = initialValue.toString();
  }

  late TextEditingController controller;
  final int initialValue;

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
  int get value => int.tryParse(controller.value.text) ?? 0;
}
