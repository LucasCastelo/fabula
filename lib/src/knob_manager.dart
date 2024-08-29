import 'dart:math';

import 'package:flutter/material.dart';
import 'package:storyto/src/entities/knob_text_field_decoration.dart';
import 'package:storyto/src/fields/bool_field.dart';
import 'package:storyto/src/fields/color_field.dart';
import 'package:storyto/src/fields/nullable_color_field.dart';
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

  AnimationController animationController({
    required String id,
    required TickerProvider vsync,
    required Duration duration,
  }) =>
      _evaluateKnob(
        id: id,
        knob: DefaultKnob<AnimationController>(
          initialValue: AnimationController(
            vsync: vsync,
            duration: duration,
          ),
          inputBuilder: (knob) => Column(
            children: [
              GestureDetector(
                onTap: () =>
                    knob.value.value = Random().nextDouble().clamp(0, 1),
                child: const Text('CHANGE ANIMATION'),
              ),
              GestureDetector(
                onTap: () => knob.value.forward(from: 0),
                child: const Text('Play'),
              )
            ],
          ),
        ),
      );

  String? nString(
    String id, {
    KnobTextFieldDecoration? decoration,
    String? initialValue,
  }) =>
      _evaluateKnob(
        id: id,
        knob: NullableKnob<String?>(
          initialValue: initialValue,
          startAsNull: initialValue == null,
          inputBuilder: (knob, toggleNull) => NullableTextField(
            decoration: decoration ?? KnobTextFieldDecoration(label: id),
            initialValue: initialValue ?? '',
            toggleNull: toggleNull,
            valueGetter: knob.getValue,
            onChanged: knob.setValue,
          ),
        ),
      );

  bool boolean(
    String id, {
    required String label,
    bool? initialValue,
  }) =>
      _evaluateKnob(
        id: id,
        knob: DefaultKnob<bool>(
          initialValue: initialValue ?? true,
          inputBuilder: (knob) => BoolField(
            label: label,
            value: knob.getValue(),
            onChanged: knob.setValue,
          ),
        ),
      );

  String string(
    String id, {
    String? initialValue,
    KnobTextFieldDecoration? decoration,
  }) =>
      _evaluateKnob(
        id: id,
        knob: DefaultKnob<String>(
          initialValue: initialValue ?? '',
          inputBuilder: (knob) => CustomTextField(
            onChanged: knob.setValue,
            isEnabled: true,
            initialValue: initialValue,
            decoration: decoration ?? KnobTextFieldDecoration(label: id),
            keyboardType: TextInputType.text,
          ),
        ),
      );

  int? nInteger(
    String id, {
    int? initialValue,
    KnobTextFieldDecoration? decoration,
  }) =>
      _evaluateKnob(
        id: id,
        knob: NullableKnob<int>(
          initialValue: initialValue ?? 0,
          startAsNull: initialValue == null,
          inputBuilder: (knob, toggleNull) => NullableTextField<int?>(
            decoration: decoration ?? KnobTextFieldDecoration(label: id),
            initialValue: initialValue.toString(),
            toggleNull: toggleNull,
            valueGetter: knob.getValue,
            onChanged: (v) => knob.setValue(int.parse(v)),
          ),
        ),
      );

  int integer(
    String id, {
    int? initialValue,
    KnobTextFieldDecoration? decoration,
  }) =>
      _evaluateKnob(
        id: id,
        knob: DefaultKnob<int>(
          initialValue: initialValue ?? 0,
          inputBuilder: (knob) => CustomTextField(
            decoration: decoration ?? KnobTextFieldDecoration(label: id),
            isEnabled: true,
            onChanged: (v) => knob.setValue(int.parse(v)),
            initialValue: initialValue.toString(),
            keyboardType: TextInputType.number,
          ),
        ),
      );

  Color color(
    String id, {
    Color? initialValue,
    String? label,
  }) =>
      _evaluateKnob(
        id: id,
        knob: DefaultKnob<Color>(
          initialValue: initialValue ?? Colors.black,
          inputBuilder: (knob) => ColorField(
            label: label ?? id,
            knob: knob,
          ),
        ),
      );

  Color? nColor(
    String id, {
    Color? initialValue,
    String? label,
  }) =>
      _evaluateKnob(
        id: id,
        knob: NullableKnob<Color>(
          startAsNull: initialValue == null,
          initialValue: initialValue ?? Colors.black,
          inputBuilder: (knob, toggleNull) => NullableColorField(
            label: label ?? id,
            knob: knob,
            toggleNull: toggleNull,
          ),
        ),
      );

  T? nSelectable<T>(
    String id, {
    required List<T> values,
    SelectorNameMarshal? nameMarshal,
  }) =>
      _evaluateKnob(
        id: id,
        knob: NullableKnob<T>(
          startAsNull: false,
          initialValue: values.isNotEmpty
              ? values[0]
              : throw Exception('Selectable of id $id cant have empty values'),
          inputBuilder: (knob, toggleNull) => NullableSelectorField<T?>(
            knob: knob,
            values: values,
            nameMarshal: nameMarshal ?? (v) => v.toString(),
            toggleNull: toggleNull,
          ),
        ),
      );

  T selectable<T>(
    String id, {
    required List<T> values,
    T? initialValue,
    SelectorNameMarshal? nameMarshal,
  }) =>
      _evaluateKnob(
        id: id,
        knob: DefaultKnob<T>(
          initialValue: values.isNotEmpty
              ? values[0]
              : throw Exception('Selectable of id $id cant have empty values'),
          inputBuilder: (knob) => SelectorField<T>(
            knob: knob,
            options: values,
            nameMarshal: nameMarshal ?? (v) => v.toString(),
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
