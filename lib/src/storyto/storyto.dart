import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:storyto/src/storyto/knob.dart';
import 'package:storyto/src/storyto/knobs/nullable_text_knob.dart';

class Storyto extends ValueNotifier<Map<String, Knob>> {
  Storyto() : super(<String, Knob>{});

  List<Knob> get knobs => value.values.toList();

  T? createKnob<T>({
    required String id,
    required Knob<T> knob,
  }) {
    knob.addListener(notifyListeners);
    value[id] = knob;
    notifyListeners();
    return knob.value;
  }

  T? customTextKnob<T>(
    String id, {
    required T? initialValue,
    required T? Function(String e) marshal,
    bool isNullable = true,
  }) {
    final knob = value[id];

    if (knob != null && knob is NullableTextKnob<T>) {
      return knob.value;
    } else {
      final customTextKnob = NullableTextKnob<T>(
        initialValue: initialValue,
        marshal: marshal,
        isNullable: isNullable,
      );

      createKnob(id: id, knob: customTextKnob);
      return customTextKnob.value;
    }
  }

  @override
  void dispose() {
    for (var knob in knobs) {
      knob.removeListener(notifyListeners);
    }

    super.dispose();
  }
}
