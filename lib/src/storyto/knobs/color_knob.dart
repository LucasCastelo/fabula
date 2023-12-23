import 'package:flutter/material.dart';
import 'package:storyto/src/storyto/knob.dart';

// Opacity 0xFF FF FF FF
class ColorKnob with ChangeNotifier implements Knob<Color> {
  @override
  Widget knob() {
    return Container();
  }

  @override
  void setValue(Color value) {}

  @override
  Color get value => throw UnimplementedError();
}
