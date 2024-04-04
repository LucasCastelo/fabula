import 'package:flutter/material.dart';

typedef NullableInputBuilder = Widget Function<T>(
  ValueSetter<T> setValue,
  VoidCallback toggleNull,
);

typedef InputBuilder = Widget Function<T>(ValueSetter<T> setValue);

abstract class Knob<T> extends ValueNotifier<T> {
  Knob(super.value);

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

  T? getValue() => value;

  void _setValue(T newValue) => value = newValue;

  void toggleNull() => value == null ? value = _defaultValue : value = null;

  @override
  Widget knob() => _inputBuilder(_setValue, toggleNull);
}

class DefaultKnob<T> extends Knob<T> {
  DefaultKnob({
    required T initialValue,
    required InputBuilder inputBuilder,
  })  : _inputBuilder = inputBuilder,
        super(initialValue);

  final InputBuilder _inputBuilder;

  T getValue() => value;

  void _setValue(T newValue) => value = newValue;

  @override
  Widget knob() => _inputBuilder(_setValue);
}
