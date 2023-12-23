import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:storyto/src/storyto/knob.dart';
import 'package:storyto/src/storyto/knobs/int_knob.dart';
import 'package:storyto/src/storyto/knobs/string_knob.dart';

// TODO: This is ugly, refactor
class Storyto extends ValueNotifier<Map<String, Knob>> {
  Storyto() : super(<String, Knob>{});

  List<Knob> get knobs => value.values.toList();

  String string(
    String id, {
    required String initialValue,
  }) {
    final stringKnob = value[id];
    String _value = '';

    if (stringKnob != null && stringKnob is StringKnob) {
      _value = stringKnob.value;
    } else {
      final newStringKnob = StringKnob(initialValue: initialValue);
      value[id] = newStringKnob;
      _value = newStringKnob.value;
    }

    notifyListeners();
    return _value;
  }

  int integer(
    String id, {
    required int initialValue,
  }) {
    final intKnob = value[id];
    int _value = 0;

    if (intKnob != null && intKnob is IntKnob) {
      _value = intKnob.value;
    } else {
      final newIntKnob = IntKnob(initialValue: initialValue);
      value[id] = newIntKnob;
      _value = newIntKnob.value;
    }

    notifyListeners();
    return _value;
  }
}
