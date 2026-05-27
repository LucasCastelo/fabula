import 'package:flutter/material.dart';

typedef NullableInputBuilder<T> = Widget Function(
  NullableKnob<T> knob,
  VoidCallback toggleNull,
);

typedef InputBuilder<T> = Widget Function(Knob<T> knob);

class KnobLocation {
  const KnobLocation({this.section, this.order = 0});

  final String? section;
  final double order;
}

abstract class Knob<T> extends ValueNotifier<T> {
  Knob(
    super.value, {
    this.location = const KnobLocation(),
    this.onDispose,
  });

  final KnobLocation location;
  final void Function(T value)? onDispose;

  void setValue(T newValue);

  T getValue();

  Widget knob();

  @override
  void dispose() {
    onDispose?.call(value);
    super.dispose();
  }
}

class NullableKnob<T> extends Knob<T?> {
  NullableKnob({
    T? value,
    required NullableInputBuilder<T?> inputBuilder,
    super.location,
    super.onDispose,
  })  : lastKnowValue = value,
        _inputBuilder = inputBuilder,
        _isFieldEnabled = value != null,
        super(value);

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

class DefaultKnob<T> extends Knob<T> {
  DefaultKnob({
    required T initialValue,
    required InputBuilder<T> inputBuilder,
    super.location,
    super.onDispose,
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
