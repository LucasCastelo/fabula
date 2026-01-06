import 'package:flutter/material.dart';

typedef NullableInputBuilder<T> = Widget Function(
  NullableKnob<T> knob,
  VoidCallback toggleNull,
);

typedef InputBuilder<T> = Widget Function(KnobValue<T> knob);

sealed class Knob<T> extends ChangeNotifier {
  final String? section;
  final int? orderingPriority;
  final int? sectionOrderingPriority;

  Knob({
    this.section,
    this.orderingPriority,
    this.sectionOrderingPriority,
  });

  Widget knob();
}

abstract class KnobValue<T> extends ValueNotifier<T> implements Knob {
  KnobValue(super.value);

  void setValue(T newValue);

  T getValue();
}

class NullableKnob<T> extends KnobValue<T?> {
  NullableKnob({
    T? value,
    required NullableInputBuilder<T?> inputBuilder,
    this.section,
    this.orderingPriority,
    this.sectionOrderingPriority,
  })  : lastKnowValue = value,
        _inputBuilder = inputBuilder,
        _isFieldEnabled = value != null,
        super(value);

  @override
  final String? section;

  @override
  final int? orderingPriority;

  @override
  final int? sectionOrderingPriority;

  T? lastKnowValue;
  final NullableInputBuilder<T?> _inputBuilder;

  bool _isFieldEnabled;
  bool get isFieldEnabled => _isFieldEnabled;

  @override
  T? getValue() => value;

  @override
  void setValue(T? newValue) => value = newValue;

  void toggleNull() {
    final currentValue = value;

    if (currentValue == null) {
      value = lastKnowValue;
    } else {
      lastKnowValue = currentValue;
      value = null;
    }

    _isFieldEnabled = !_isFieldEnabled;

    notifyListeners();
  }

  @override
  Widget knob() => _inputBuilder(this, toggleNull);
}

class DefaultKnob<T> extends KnobValue<T> {
  DefaultKnob({
    required T initialValue,
    required InputBuilder<T> inputBuilder,
    this.section,
    this.orderingPriority,
    this.sectionOrderingPriority,
  })  : _inputBuilder = inputBuilder,
        super(initialValue);

  final InputBuilder<T> _inputBuilder;

  @override
  final String? section;

  @override
  final int? orderingPriority;

  @override
  final int? sectionOrderingPriority;

  @override
  T getValue() => value;

  @override
  void setValue(T newValue) => value = newValue;

  @override
  Widget knob() => _inputBuilder(this);
}
