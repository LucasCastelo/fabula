import 'package:flutter/material.dart';
import 'package:storyto/src/entities/knob_text_field_decoration.dart';
import 'package:storyto/src/knobs/knob.dart';
import 'package:storyto/src/widgets/custom_text_field.dart';

class IntegerKnob extends DefaultKnob<int> {
  IntegerKnob({
    required KnobTextFieldDecoration decoration,
    required super.initialValue,
  }) : super(
          inputBuilder: (knob) => CustomTextField(
            decoration: decoration,
            isEnabled: true,
            onChanged: (v) => knob.setValue(int.parse(v)),
            initialValue: initialValue.toString(),
            keyboardType: TextInputType.number,
          ),
        );
}
