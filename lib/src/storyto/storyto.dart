import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:storyto/src/storyto/knob.dart';
import 'package:storyto/src/storyto/knobs/nullable_text_knob.dart';

class Storyto extends ValueNotifier<Map<String, Knob>> {
  Storyto() : super(<String, Knob>{});

  List<Knob> get knobs => value.values.toList();

  String? nString(
    String id, {
    required String initialValue,
  }) =>
      nTextKnob(
        id,
        initialValue: initialValue,
        marshal: (e) => e,
      );

  String string(
    String id, {
    required String initialValue,
  }) =>
      nTextKnob(
        id,
        initialValue: initialValue,
        marshal: (e) => e,
        isNullable: false,
      )!;

  int inputInt(
    String id, {
    required int initialValue,
  }) =>
      nTextKnob(
        id,
        initialValue: initialValue,
        marshal: (e) => int.tryParse(e) ?? 0,
        isNullable: false,
      )!;

  int? nInputInt(
    String id, {
    required int initialValue,
  }) =>
      nTextKnob(
        id,
        initialValue: initialValue,
        marshal: (e) => int.tryParse(e) ?? 0,
        isNullable: true,
      );

  double inputDouble(
    String id, {
    required double initialValue,
  }) =>
      nTextKnob(
        id,
        initialValue: initialValue,
        marshal: (e) => double.tryParse(e) ?? 0,
        isNullable: false,
      )!;

  double? nInputDouble(
    String id, {
    required double initialValue,
  }) =>
      nTextKnob(
        id,
        initialValue: initialValue,
        marshal: (e) => double.tryParse(e) ?? 0,
        isNullable: true,
      );

  T? nTextKnob<T>(
    String id, {
    required T? initialValue,
    required T? Function(String e) marshal,
    bool isNullable = true,
  }) {
    // Fetch the potential knob
    final knob = value[id];

    // Check if exists, and if it is the same
    if (knob != null && knob is NullableTextKnob<T>) {
      notifyListeners();
      return knob.value;
    } else {
      final newIntKnob = NullableTextKnob<T>(
        initialValue: initialValue,
        marshal: marshal,
        isNullable: isNullable,
      );

      value[id] = newIntKnob;

      notifyListeners();
      return newIntKnob.value;
    }
  }
}
