import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:storyto/src/storyto/knob.dart';
import 'package:storyto/src/storyto/knobs/text_knob.dart';

class KnobsListenable extends ChangeNotifier {
  Map<String, Knob> value = {};
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

  void deleteKnob(String id) {}

  T? customTextKnob<T>(
    String id, {
    required T? initialValue,
    required T? Function(String e) marshal,
    bool isNullable = true,
  }) {
    final knob = value[id];

    if (knob != null && knob is TextKnob<T>) {
      return knob.value;
    } else {
      final customTextKnob = TextKnob<T>(
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
