import 'package:flutter/material.dart';
import 'package:storyto/src/entities/knob_text_field_decoration.dart';
import 'package:storyto/src/knobs/knob.dart';
import 'package:storyto/src/widgets/custom_text_field.dart';

class StringKnob extends DefaultKnob {
  StringKnob({
    required super.initialValue,
    required KnobTextFieldDecoration decoration,
  }) : super(
          inputBuilder: (knob) => CustomTextField(
            onChanged: knob.setValue,
            isEnabled: true,
            initialValue: initialValue,
            decoration: decoration,
            keyboardType: TextInputType.text,
          ),
        );
}
