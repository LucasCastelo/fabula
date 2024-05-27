import 'package:flutter/material.dart';
import 'package:storyto/src/fields/color_field.dart';
import 'package:storyto/src/knobs/knob.dart';

class ColorKnob extends DefaultKnob<Color> {
  ColorKnob({
    required super.initialValue,
  }) : super(
          inputBuilder: (knob) => ColorField(knob: knob),
        );
}
