import 'package:flutter/material.dart';

abstract class Knob<T> with ChangeNotifier {
  T get value;

  void setValue(T value);

  Widget knob();
}
