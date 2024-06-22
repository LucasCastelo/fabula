import 'package:flutter/material.dart';
import 'package:storyto/src/entities/knob_text_field_decoration.dart';
import 'package:storyto/src/knobs/bool_knob.dart';
import 'package:storyto/src/knobs/color_knob.dart';
import 'package:storyto/src/knobs/integer_knob.dart';
import 'package:storyto/src/knobs/knob.dart';
import 'package:storyto/src/knobs/n_integer_knob.dart';
import 'package:storyto/src/knobs/n_selector_knob.dart';
import 'package:storyto/src/knobs/n_string_knob.dart';
import 'package:storyto/src/knobs/selector_knob.dart';
import 'package:storyto/src/knobs/string_knob.dart';
import 'package:storyto/storyto.dart';

class KnobManager extends ChangeNotifier {
  KnobManager();

  final Map<String, Knob> knobs = {};
  final ChangeNotifier rebuildKnobs = ChangeNotifier();
  final ChangeNotifier rebuildExhibit = ChangeNotifier();

  @override
  void dispose() {
    knobs.values.map((e) => e.dispose());
    super.dispose();
  }

  String? nString(
    String id, {
    required KnobTextFieldDecoration decoration,
    required String initialValue,
    required bool startAsNull,
  }) {
    return _evaluateNullableKnob(
      id: id,
      knob: NStringKnob(
        decoration: decoration,
        initialValue: initialValue,
        startAsNull: startAsNull,
      ),
    );
  }

  bool boolean(
    String id, {
    required String label,
    required bool initialValue,
  }) {
    if (knobs.keys.contains(id)) {
      return knobs[id]!.value as bool;
    } else {
      final newKnob = BoolKnob(
        label: label,
        initialValue: initialValue,
      );

      _registerNewKnobById(
        id: id,
        newKnob: newKnob,
      );
      return newKnob.value;
    }
  }

  String string(
    String id, {
    required String initialValue,
    required KnobTextFieldDecoration decoration,
  }) {
    if (knobs.keys.contains(id)) {
      return knobs[id]!.value as String;
    } else {
      final newKnob = StringKnob(
        decoration: decoration,
        initialValue: initialValue,
      );

      _registerNewKnobById(
        id: id,
        newKnob: newKnob,
      );
      return newKnob.value;
    }
  }

  int? nInteger(
    String id, {
    required int initialValue,
    required bool startAsNull,
    required KnobTextFieldDecoration decoration,
  }) {
    return _evaluateNullableKnob(
      id: id,
      knob: NIntegerKnob(
        decoration: decoration,
        initialValue: initialValue,
        startAsNull: startAsNull,
      ),
    );
  }

  int integer(
    String id, {
    required int initialValue,
    required KnobTextFieldDecoration decoration,
  }) {
    if (knobs.keys.contains(id)) {
      return knobs[id]!.value as int;
    } else {
      final newKnob = IntegerKnob(
        decoration: decoration,
        initialValue: initialValue,
      );

      _registerNewKnobById(
        id: id,
        newKnob: newKnob,
      );
      return newKnob.value;
    }
  }

  Color color(
    String id, {
    required Color initialValue,
  }) {
    if (knobs.keys.contains(id)) {
      return knobs[id]!.value as Color;
    } else {
      final newKnob = ColorKnob(
        initialValue: initialValue,
      );

      _registerNewKnobById(
        id: id,
        newKnob: newKnob,
      );
      return newKnob.value;
    }
  }

  T? nSelectable<T>(
    String id, {
    required List<T> values,
    required bool startAsNull,
    required SelectorNameMarshal nameMarshal,
  }) {
    return _evaluateNullableKnob(
      id: id,
      knob: NSelectorKnob<T>(
        values: values,
        startAsNull: startAsNull,
        nameMarshal: nameMarshal,
      ),
    );
  }

  T selectable<T>(
    String id, {
    required List<T> values,
    required T initialValue,
    required SelectorNameMarshal nameMarshal,
  }) {
    if (knobs.keys.contains(id)) {
      return knobs[id]?.value as T;
    } else {
      final newKnob = SelectorKnob<T>(
        values: values,
        nameMarshal: nameMarshal,
        initialValue: initialValue,
      );

      _registerNewKnobById(
        id: id,
        newKnob: newKnob,
      );
      return newKnob.value!;
    }
  }

  T? _evaluateNullableKnob<T>({
    required String id,
    required Knob knob,
  }) {
    if (knobs.keys.contains(id)) {
      return _fetchNullableKnobValueById(id);
    } else {
      _registerNewKnobById(
        id: id,
        newKnob: knob,
      );

      return knob.value;
    }
  }

  void _registerNewKnobById({
    required String id,
    required Knob newKnob,
  }) {
    newKnob.addListener(rebuildExhibit.notifyListeners);

    knobs[id] = newKnob;

    rebuildKnobs.notifyListeners();
  }

  T? _fetchNullableKnobValueById<T>(String id) {
    final selectedKnobValue = knobs[id]?.value;

    if (selectedKnobValue == null) {
      return null;
    } else {
      return selectedKnobValue as T;
    }
  }
}
