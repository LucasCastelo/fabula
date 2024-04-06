import 'package:flutter/material.dart';

typedef NullableInputBuilder = Widget Function(
  Knob knob,
  VoidCallback toggleNull,
);

typedef InputBuilder = Widget Function(Knob knob);

abstract class Knob<T> extends ValueNotifier<T> {
  Knob(super.value);

  void setValue(T newValue);

  T getValue();

  Widget knob();
}

class NullableKnob<T> extends Knob<T?> {
  NullableKnob({
    required T defaultValue,
    required bool startAsNull,
    required NullableInputBuilder inputBuilder,
  })  : _defaultValue = defaultValue,
        _inputBuilder = inputBuilder,
        super(startAsNull ? null : defaultValue);

  final T _defaultValue;
  final NullableInputBuilder _inputBuilder;

  @override
  T? getValue() => value;

  @override
  void setValue(T? newValue) => value = newValue;

  void toggleNull() => value == null ? value = _defaultValue : value = null;

  @override
  Widget knob() => _inputBuilder(this, toggleNull);
}

class DefaultKnob<T> extends Knob<T> {
  DefaultKnob({
    required T initialValue,
    required InputBuilder inputBuilder,
  })  : _inputBuilder = inputBuilder,
        super(initialValue);

  final InputBuilder _inputBuilder;

  @override
  T getValue() => value;

  @override
  void setValue(T newValue) => value = newValue;

  @override
  Widget knob() => _inputBuilder(this);
}
