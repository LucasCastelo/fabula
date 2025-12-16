import 'package:flutter/material.dart';
import 'package:storyto/src/fields/animation_player.dart';
import 'package:storyto/src/fields/list_field.dart';
import 'package:storyto/src/widgets/toggler_field.dart';
import 'package:storyto/src/fields/bool_field.dart';
import 'package:storyto/src/fields/color_field.dart';
import 'package:storyto/src/fields/nullable_color_field.dart';
import 'package:storyto/src/fields/nullable_selector_field.dart';
import 'package:storyto/src/fields/nullable_string_field.dart';
import 'package:storyto/src/entities/knob.dart';
import 'package:storyto/src/fields/selector_field.dart';
import 'package:storyto/src/widgets/custom_text_field.dart';
import 'package:storyto/storyto.dart';

class KnobManager extends ChangeNotifier {
  KnobManager();

  final Map<String, KnobValue> knobs = {};
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
    Duration? duration,
  }) =>
      _evaluateKnob(
        id: id,
        knob: DefaultKnob<AnimationController>(
          initialValue: AnimationController(
            vsync: vsync,
            duration: duration ?? const Duration(seconds: 5),
          ),
          inputBuilder: (knob) => AnimationPlayer(knob: knob),
        ),
      );

  String? nString(
    String id, {
    KnobTextFieldDecoration? decoration,
    String? value,
  }) =>
      _evaluateKnob(
        id: id,
        knob: NullableKnob<String?>(
          value: value,
          inputBuilder: (knob, toggleNull) => NullableTextField(
            decoration: decoration ?? KnobTextFieldDecoration(label: id),
            initialValue: value ?? '',
            toggleNull: toggleNull,
            onChanged: knob.setValue,
            isEnabled: knob.isFieldEnabled,
          ),
        ),
      );

  bool boolean(
    String id, {
    required String label,
    bool? value,
  }) =>
      _evaluateKnob(
        id: id,
        knob: DefaultKnob<bool>(
          initialValue: value ?? true,
          inputBuilder: (knob) => BoolField(
            label: label,
            value: knob.getValue(),
            onChanged: knob.setValue,
          ),
        ),
      );

  T toggler<T>(
    String id, {
    required String label,
    required T onValue,
    required T offValue,
  }) =>
      _evaluateKnob(
        id: id,
        knob: DefaultKnob<T>(
          initialValue: onValue,
          inputBuilder: (knob) => TogglerField(
            getValue: knob.getValue,
            onChange: knob.setValue,
            offValue: offValue,
            onValue: onValue,
          ),
        ),
      );

  String string(
    String id, {
    String? value,
    KnobTextFieldDecoration? decoration,
  }) =>
      _evaluateKnob(
        id: id,
        knob: DefaultKnob<String>(
          initialValue: value ?? '',
          inputBuilder: (knob) => CustomTextField(
            onChanged: knob.setValue,
            isEnabled: true,
            initialValue: value,
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
          value: initialValue,
          inputBuilder: (knob, toggleNull) => NullableTextField<int?>(
            decoration: decoration ?? KnobTextFieldDecoration(label: id),
            initialValue: initialValue.toString(),
            toggleNull: toggleNull,
            onChanged: (v) => knob.setValue(int.parse(v)),
            isEnabled: knob.isFieldEnabled,
          ),
        ),
      );

  int integer(
    String id, {
    int? value,
    KnobTextFieldDecoration? decoration,
  }) =>
      _evaluateKnob(
        id: id,
        knob: DefaultKnob<int>(
          initialValue: value ?? 0,
          inputBuilder: (knob) => CustomTextField(
            decoration: decoration ?? KnobTextFieldDecoration(label: id),
            isEnabled: true,
            onChanged: (v) => knob.setValue(int.parse(v)),
            initialValue: value.toString(),
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
    Color? value,
    String? label,
  }) =>
      _evaluateKnob(
        id: id,
        knob: NullableKnob<Color>(
          value: value,
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
          value: values.isNotEmpty
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
    SelectorNameMarshal<T>? nameMarshal,
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

  List<T> listDefunct<T>(
    String id, {
    required ListItemBuilder<T> itemBuilder,
    int initialLength = 0,
  }) =>
      _evaluateKnob(
        id: id,
        knob: DefaultKnob<List<T>>(
          initialValue: List.generate(
            initialLength,
            (index) => itemBuilder('prefix'),
          ),
          inputBuilder: (knob) => ListField<T>(
              listId: id,
              knob: knob,
              itemBuilder: itemBuilder,
              onFieldCreated: (prefix) {
                knobs.keys
                    .where((key) => key.startsWith(prefix))
                    .forEach((key) {
                  knobs[key]?.addListener(rebuildExhibit.notifyListeners);
                });
              },
              onFieldDisposed: (prefix) {
                knobs.keys
                    .where((key) => key.startsWith(prefix))
                    .forEach((key) {
                  knobs[key]?.removeListener(rebuildExhibit.notifyListeners);
                });
              }),
        ),
      );

  T? _evaluateKnob<T>({
    required String id,
    required KnobValue knob,
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
    required KnobValue newKnob,
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
