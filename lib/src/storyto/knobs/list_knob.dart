import 'package:flutter/material.dart';
import 'package:storyto/src/storyto/knob.dart';
import 'package:storyto/src/storyto/knobs_listenable.dart';

class NullableListKnob<T> with ChangeNotifier implements Knob<List<T>> {
  NullableListKnob({
    required this.isNullable,
    required this.storyto,
    required this.builder,
  }) {
    storyto.addListener(notifyListeners);
  }

  final bool isNullable;
  final KnobsListenable storyto;
  final T Function(KnobsListenable, int) builder;

  List<T> _value = [];
  bool _isNull = false;
  int _length = 0;

  @override
  Widget knob() {
    return Row();
  }

  void _buildList() {
    setValue(
      List.generate(
        _length,
        (index) => builder(storyto, index),
      ),
    );
  }

  @override
  void setValue(List<T> value) {
    _value = value;
    notifyListeners();
  }

  @override
  List<T>? get value => _isNull ? null : _value;
}
