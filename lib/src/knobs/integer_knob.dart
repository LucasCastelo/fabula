import 'package:flutter/material.dart';
import 'package:storyto/src/fields/custom_text_field.dart';
import 'package:storyto/src/knobs/knob.dart';

class IntegerKnob extends DefaultKnob<int> {
  IntegerKnob({
    required super.initialValue,
  }) : super(
          inputBuilder: (knob) => KnobTextField(
            knob: knob,
            keyboardType: TextInputType.number,
            marshal: (v) => int.parse(v),
          ),
        );
}
