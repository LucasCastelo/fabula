import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:storyto/src/storyto/knob.dart';
import 'package:storyto/src/storyto/knobs/text_knob.dart';

class Storyto extends ValueNotifier<Map<String, Knob>> {
  Storyto() : super(<String, Knob>{});

  List<Knob> get knobs => value.values.toList();

  String string(
    String id, {
    required String initialValue,
  }) =>
      textKnob(
        id,
        initialValue: initialValue,
        marshal: (e) => e,
      );

  int integer(
    String id, {
    required int initialValue,
  }) =>
      textKnob(
        id,
        initialValue: initialValue,
        marshal: (e) => int.tryParse(e) ?? 0,
      );

  double float(
    String id, {
    required double initialValue,
  }) =>
      textKnob(
        id,
        initialValue: initialValue,
        marshal: (e) => double.tryParse(e) ?? 0,
      );

  T textKnob<T>(
    String id, {
    required T initialValue,
    required T Function(String e) marshal,
  }) {
    // Fetch the potential knob
    final knob = value[id];

    // Check if exists, and if it is the same
    if (knob != null && knob is TextKnob<T>) {
      notifyListeners();
      return knob.value;
    } else {
      final newIntKnob = TextKnob<T>(
        initialValue: initialValue,
        marshal: marshal,
      );

      value[id] = newIntKnob;

      notifyListeners();
      return newIntKnob.value;
    }
  }
}
