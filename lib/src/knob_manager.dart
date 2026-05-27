import 'package:flutter/material.dart';
import 'package:fabula/src/fields/animation_player.dart';
import 'package:fabula/src/helpers/debouncer.dart';
import 'package:fabula/src/widgets/general/toggler_field.dart';
import 'package:fabula/src/fields/bool_field.dart';
import 'package:fabula/src/fields/color_field.dart';
import 'package:fabula/src/fields/nullable_color_field.dart';
import 'package:fabula/src/fields/nullable_selector_field.dart';
import 'package:fabula/src/fields/nullable_string_field.dart';
import 'package:fabula/src/fields/selector_field.dart';
import 'package:fabula/src/widgets/general/custom_text_field.dart';
import 'package:fabula/fabula.dart';

class KnobManager extends ChangeNotifier {
  KnobManager();

  final Map<String, Knob> knobs = {};
  final ChangeNotifier rebuildKnobs = ChangeNotifier();
  final ChangeNotifier rebuildExhibit = ChangeNotifier();
  final Debouncer rebuildExhibitDebouncer = Debouncer(milliseconds: 300);
  final Debouncer rebuildKnobsDebouncer = Debouncer(milliseconds: 300);

  Map<String, List<Knob>> get knobsBySection {
    final sorted = knobs.values.toList()
      ..sort((a, b) => (a.sectionOrderingPriority ?? double.maxFinite)
          .compareTo(b.sectionOrderingPriority ?? double.maxFinite));

    final knobsBySection = <String, List<Knob>>{};
    for (final knob in sorted) {
      final key = knob.section ?? '';
      knobsBySection.putIfAbsent(key, () => []).add(knob);
    }

    knobsBySection.forEach((_, value) {
      value.sort((a, b) => (a.orderingPriority ?? double.maxFinite)
          .compareTo(b.orderingPriority ?? double.maxFinite));
    });

    return knobsBySection;
  }

  @override
  void dispose() {
    rebuildExhibitDebouncer.dispose();
    rebuildKnobsDebouncer.dispose();
    rebuildExhibit.dispose();
    rebuildKnobs.dispose();
    for (final knob in knobs.values) {
      knob.dispose();
    }
    super.dispose();
  }

  AnimationController animationController(
    String id, {
    required TickerProvider vsync,
    Duration? duration,
    String? section,
    int? orderingPriority = 0,
    int? sectionOrderingPriority = 0,
  }) =>
      _evaluateKnob(
        id: id,
        knob: DefaultKnob<AnimationController>(
          initialValue: AnimationController(
            vsync: vsync,
            duration: duration ?? const Duration(seconds: 5),
          ),
          section: section,
          orderingPriority: orderingPriority,
          sectionOrderingPriority: sectionOrderingPriority,
          inputBuilder: (knob) => AnimationPlayer(knob: knob),
          onDispose: (controller) => controller.dispose(),
        ),
      );

  bool boolean(
    String id, {
    required String label,
    String? description,
    bool? initialValue,
    String? section,
    int? orderingPriority = 0,
    int? sectionOrderingPriority = 0,
  }) =>
      _evaluateKnob(
        id: id,
        knob: DefaultKnob<bool>(
          initialValue: initialValue ?? true,
          section: section,
          orderingPriority: orderingPriority,
          sectionOrderingPriority: sectionOrderingPriority,
          inputBuilder: (knob) => BoolField(
            label: label,
            description: description,
            value: knob.getValue(),
            onChanged: knob.setValue,
          ),
        ),
      );

  // TODO: improve on toggler design
  T toggler<T>(
    String id, {
    required String label,
    required T onValue,
    required T offValue,
    String? section,
    int? orderingPriority = 0,
    int? sectionOrderingPriority = 0,
  }) =>
      _evaluateKnob(
        id: id,
        knob: DefaultKnob<T>(
          initialValue: onValue,
          section: section,
          orderingPriority: orderingPriority,
          sectionOrderingPriority: sectionOrderingPriority,
          inputBuilder: (knob) => TogglerField(
            label: label,
            getValue: knob.getValue,
            onChange: knob.setValue,
            offValue: offValue,
            onValue: onValue,
          ),
        ),
      );

  String string(
    String id, {
    String? initialValue,
    String? section,
    int? orderingPriority = 0,
    int? sectionOrderingPriority = 0,
    KnobTextFieldDecoration? decoration,
    String? description,
  }) =>
      _evaluateKnob(
        id: id,
        knob: DefaultKnob<String>(
          initialValue: initialValue ?? '',
          section: section,
          orderingPriority: orderingPriority,
          sectionOrderingPriority: sectionOrderingPriority,
          inputBuilder: (knob) => CustomTextField(
            description: description,
            onChanged: knob.setValue,
            isEnabled: true,
            initialValue: initialValue,
            decoration: decoration ??
                KnobTextFieldDecoration(
                  label: id,
                  placeholder: id,
                ),
            keyboardType: TextInputType.text,
          ),
        ),
      );

  String? nString(
    String id, {
    KnobTextFieldDecoration? decoration,
    String? initialValue,
    String? description,
    String? section,
    int? orderingPriority = 0,
    int? sectionOrderingPriority = 0,
  }) =>
      _evaluateKnob(
        id: id,
        knob: NullableKnob<String?>(
          value: initialValue,
          section: section,
          orderingPriority: orderingPriority,
          sectionOrderingPriority: sectionOrderingPriority,
          inputBuilder: (knob, toggleNull) => NullableTextField(
            decoration: decoration ??
                KnobTextFieldDecoration(
                  label: id,
                  placeholder: id,
                ),
            initialValue: initialValue,
            description: description,
            toggleNull: toggleNull,
            onChanged: knob.setValue,
            isEnabled: knob.isFieldEnabled,
          ),
        ),
      );

  int? nInteger(
    String id, {
    int? initialValue,
    KnobTextFieldDecoration? decoration,
    String? section,
    int? orderingPriority = 0,
    int? sectionOrderingPriority = 0,
  }) =>
      _evaluateKnob(
        id: id,
        knob: NullableKnob<int>(
          value: initialValue ?? 0,
          section: section,
          orderingPriority: orderingPriority,
          sectionOrderingPriority: sectionOrderingPriority,
          inputBuilder: (knob, toggleNull) => NullableTextField<int?>(
            decoration: decoration ?? KnobTextFieldDecoration(label: id),
            initialValue: initialValue?.toString() ?? '0',
            toggleNull: toggleNull,
            onChanged: (v) => knob.setValue(int.tryParse(v) ?? 0),
            isEnabled: knob.isFieldEnabled,
          ),
        ),
      );

  int integer(
    String id, {
    int? value,
    KnobTextFieldDecoration? decoration,
    String? section,
    int? orderingPriority = 0,
    int? sectionOrderingPriority = 0,
  }) =>
      _evaluateKnob(
        id: id,
        knob: DefaultKnob<int>(
          initialValue: value ?? 0,
          section: section,
          orderingPriority: orderingPriority,
          sectionOrderingPriority: sectionOrderingPriority,
          inputBuilder: (knob) => CustomTextField(
            decoration: decoration ?? KnobTextFieldDecoration(label: id),
            isEnabled: true,
            onChanged: (v) => knob.setValue(int.tryParse(v) ?? knob.value),
            initialValue: value?.toString() ?? '0',
            keyboardType: TextInputType.number,
          ),
        ),
      );

  Color color(
    String id, {
    Color? initialValue,
    String? label,
    String? description,
    List<Color>? predefinedColors,
    String? section,
    int? orderingPriority = 0,
    int? sectionOrderingPriority = 0,
  }) =>
      _evaluateKnob(
        id: id,
        knob: DefaultKnob<Color>(
          initialValue: initialValue ?? Colors.black,
          section: section,
          orderingPriority: orderingPriority,
          sectionOrderingPriority: sectionOrderingPriority,
          inputBuilder: (knob) => ColorField(
            label: label ?? id,
            knob: knob,
            predefinedColors: predefinedColors,
            description: description,
          ),
        ),
      );

  Color? nColor(
    String id, {
    Color? value,
    String? label,
    String? description,
    List<Color>? predefinedColors,
    String? section,
    int? orderingPriority = 0,
    int? sectionOrderingPriority = 0,
  }) =>
      _evaluateKnob(
        id: id,
        knob: NullableKnob<Color>(
          value: value ?? Colors.black,
          section: section,
          orderingPriority: orderingPriority,
          sectionOrderingPriority: sectionOrderingPriority,
          inputBuilder: (knob, toggleNull) => NullableColorField(
            label: label ?? id,
            knob: knob,
            toggleNull: toggleNull,
            predefinedColors: predefinedColors,
            description: description,
          ),
        ),
      );

  T? nSelectable<T>(
    String id, {
    required List<T> values,
    SelectorNameMarshal? nameMarshal,
    String? section,
    int? orderingPriority = 0,
    int? sectionOrderingPriority = 0,
  }) =>
      _evaluateKnob(
        id: id,
        knob: NullableKnob<T>(
          value: values.isNotEmpty ? values[0] : null,
          section: section,
          orderingPriority: orderingPriority,
          sectionOrderingPriority: sectionOrderingPriority,
          inputBuilder: (knob, toggleNull) => NullableSelectorField<T?>(
            knob: knob,
            values: values,
            nameMarshal: nameMarshal ?? (v) => v.toString(),
          ),
        ),
      );

  T selectable<T>(
    String id, {
    required List<T> values,
    SelectorNameMarshal<T>? nameMarshal,
    String? section,
    int? orderingPriority = 0,
    int? sectionOrderingPriority = 0,
  }) {
    if (values.isEmpty) {
      throw ArgumentError(
        "selectable '$id' requires non-empty values. "
        'Use nSelectable if values can be empty.',
      );
    }
    return _evaluateKnob(
      id: id,
      knob: DefaultKnob<T>(
        initialValue: values[0],
        section: section,
        orderingPriority: orderingPriority,
        sectionOrderingPriority: sectionOrderingPriority,
        inputBuilder: (knob) => SelectorField<T>(
          knob: knob,
          options: values,
          nameMarshal: nameMarshal ?? (v) => v.toString(),
        ),
      ),
    );
  }

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

    rebuildKnobsDebouncer.call(() {
      rebuildKnobs.notifyListeners();
    });
  }

  T _fetchKnobValueById<T>(String id) {
    final selectedKnobValue = knobs[id]?.value;

    return selectedKnobValue as T;
  }
}
