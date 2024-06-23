import 'package:flutter/material.dart';
import 'package:storyto/src/entities/knob_text_field_decoration.dart';
import 'package:storyto/src/fields/bool_field.dart';
import 'package:storyto/src/fields/color_field.dart';
import 'package:storyto/src/fields/nullable_selector_field.dart';
import 'package:storyto/src/fields/nullable_string_field.dart';
import 'package:storyto/src/entities/knob.dart';
import 'package:storyto/src/fields/selector_field.dart';
import 'package:storyto/src/widgets/custom_text_field.dart';

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
  }) =>
      _evaluateKnob(
        id: id,
        knob: NullableKnob<String?>(
          initialValue: initialValue,
          startAsNull: startAsNull,
          inputBuilder: (knob, toggleNull) => NullableTextField(
            decoration: decoration,
            initialValue: initialValue,
            toggleNull: toggleNull,
            valueGetter: knob.getValue,
            onChanged: knob.setValue,
          ),
        ),
      );

  bool boolean(
    String id, {
    required String label,
    required bool initialValue,
  }) =>
      _evaluateKnob(
        id: id,
        knob: DefaultKnob<bool>(
          initialValue: initialValue,
          inputBuilder: (knob) => BoolField(
            label: label,
            value: knob.getValue(),
            onChanged: knob.setValue,
          ),
        ),
      );

  String string(
    String id, {
    required String initialValue,
    required KnobTextFieldDecoration decoration,
  }) =>
      _evaluateKnob(
        id: id,
        knob: DefaultKnob<String>(
          initialValue: initialValue,
          inputBuilder: (knob) => CustomTextField(
            onChanged: knob.setValue,
            isEnabled: true,
            initialValue: initialValue,
            decoration: decoration,
            keyboardType: TextInputType.text,
          ),
        ),
      );

  int? nInteger(
    String id, {
    required int initialValue,
    required bool startAsNull,
    required KnobTextFieldDecoration decoration,
  }) =>
      _evaluateKnob(
        id: id,
        knob: NullableKnob<int>(
          initialValue: initialValue,
          startAsNull: startAsNull,
          inputBuilder: (knob, toggleNull) => NullableTextField<int?>(
            decoration: decoration,
            initialValue: initialValue.toString(),
            toggleNull: toggleNull,
            valueGetter: knob.getValue,
            onChanged: (v) => knob.setValue(int.parse(v)),
          ),
        ),
      );

  int integer(
    String id, {
    required int initialValue,
    required KnobTextFieldDecoration decoration,
  }) =>
      _evaluateKnob(
        id: id,
        knob: DefaultKnob<int>(
          initialValue: initialValue,
          inputBuilder: (knob) => CustomTextField(
            decoration: decoration,
            isEnabled: true,
            onChanged: (v) => knob.setValue(int.parse(v)),
            initialValue: initialValue.toString(),
            keyboardType: TextInputType.number,
          ),
        ),
      );

  Color color(
    String id, {
    required Color initialValue,
  }) =>
      _evaluateKnob(
        id: id,
        knob: DefaultKnob<Color>(
          initialValue: initialValue,
          inputBuilder: (knob) => ColorField(
            knob: knob,
          ),
        ),
      );

  T? nSelectable<T>(
    String id, {
    required List<T> values,
    required bool startAsNull,
    required SelectorNameMarshal nameMarshal,
  }) =>
      _evaluateKnob(
        id: id,
        knob: NullableKnob<T>(
          startAsNull: startAsNull,
          initialValue: values[0],
          inputBuilder: (knob, toggleNull) => NullableSelectorField<T?>(
            knob: knob,
            values: values,
            nameMarshal: nameMarshal,
            toggleNull: toggleNull,
          ),
        ),
      );

  T selectable<T>(
    String id, {
    required List<T> values,
    required T initialValue,
    required SelectorNameMarshal nameMarshal,
  }) =>
      _evaluateKnob(
        id: id,
        knob: DefaultKnob<T>(
          initialValue: initialValue,
          inputBuilder: (knob) => SelectorField<T>(
            knob: knob,
            options: values,
            nameMarshal: nameMarshal,
          ),
        ),
      );

  T? _evaluateKnob<T>({
    required String id,
    required Knob knob,
  }) {
    if (knobs.keys.contains(id)) {
      return _fetchKnobValueById(id);
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

  T _fetchKnobValueById<T>(String id) {
    final selectedKnobValue = knobs[id]?.value;

    return selectedKnobValue as T;
  }
}
