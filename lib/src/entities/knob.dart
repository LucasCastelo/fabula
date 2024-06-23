import 'package:flutter/material.dart';

typedef NullableInputBuilder<T> = Widget Function(
  Knob<T> knob,
  VoidCallback toggleNull,
);

typedef InputBuilder<T> = Widget Function(Knob<T> knob);

abstract class Knob<T> extends ValueNotifier<T> {
  Knob(super.value);

  void setValue(T newValue);

  T getValue();

  Widget knob();
}

class NullableKnob<T> extends Knob<T?> {
  NullableKnob({
    required T initialValue,
    required bool startAsNull,
    required NullableInputBuilder<T?> inputBuilder,
  })  : lastKnowValue = initialValue,
        _inputBuilder = inputBuilder,
        super(startAsNull ? null : initialValue);

  T lastKnowValue;
  final NullableInputBuilder<T?> _inputBuilder;

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
  }

  @override
  Widget knob() => _inputBuilder(this, toggleNull);
}

class DefaultKnob<T> extends Knob<T> {
  DefaultKnob({
    required T initialValue,
    required InputBuilder<T> inputBuilder,
  })  : _inputBuilder = inputBuilder,
        super(initialValue);

  final InputBuilder<T> _inputBuilder;

  @override
  T getValue() => value;

  @override
  void setValue(T newValue) => value = newValue;

  @override
  Widget knob() => _inputBuilder(this);
}
