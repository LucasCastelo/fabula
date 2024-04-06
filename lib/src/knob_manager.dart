import 'package:flutter/material.dart';
import 'package:storyto/src/knobs/knob.dart';
import 'package:storyto/src/knobs/n_string_knob.dart';

class KnobManager extends ChangeNotifier {
  KnobManager();

  final Map<String, Knob> knobs = {};
  final ChangeNotifier rebuildKnobs = ChangeNotifier();
  final ChangeNotifier rebuildExhibit = ChangeNotifier();

  String? nString(
    String id, {
    required String defaultValue,
    required bool startAsNull,
  }) {
    if (knobs.keys.contains(id)) {
      final selectedKnob = knobs[id];
      if (selectedKnob?.value == null) {
        return null;
      } else {
        return knobs[id]?.value as String;
      }
    } else {
      final newKnob = NStringKnob(
        defaultValue: defaultValue,
        startAsNull: startAsNull,
      );

      newKnob.addListener(rebuildExhibit.notifyListeners);

      knobs[id] = newKnob;

      rebuildKnobs.notifyListeners();
      return newKnob.value;
    }
  }
}
