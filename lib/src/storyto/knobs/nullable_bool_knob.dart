import 'package:flutter/material.dart';
import 'package:storyto/src/fields/bool_field.dart';
import 'package:storyto/src/storyto/knob.dart';

class NullableBoolKnob with ChangeNotifier implements Knob<bool> {
  NullableBoolKnob({
    required this.initialValue,
    required this.isNullable,
  });

  final bool? initialValue;
  final bool isNullable;

  late bool _value = initialValue ?? false;
  bool isNull = false;

  @override
  Widget knob() {
    return BoolField(
      value: value,
      onChanged: setValue,
    );
  }

  void setNull(bool value) {
    isNull = value;
    notifyListeners();
  }

  @override
  void setValue(bool value) {
    _value = value;
    notifyListeners();
  }

  @override
  bool? get value => isNull ? null : _value;
}
