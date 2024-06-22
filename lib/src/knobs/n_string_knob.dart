import 'package:flutter/material.dart';
import 'package:storyto/src/knobs/knob.dart';
import 'package:storyto/src/widgets/custom_checkbox.dart';
import 'package:storyto/src/widgets/custom_text_field.dart';

class NStringKnob extends NullableKnob<String?> {
  NStringKnob({
    required super.initialValue,
    required super.startAsNull,
  }) : super(
          inputBuilder: (knob, toggleNull) => Row(
            children: [
              Expanded(
                child: CustomTextField(
                  initialValue: initialValue,
                  isEnabled: knob.getValue() != null,
                  onChanged: knob.setValue,
                  keyboardType: TextInputType.text,
                ),
              ),
              Row(
                children: [
                  CustomCheckbox(
                    value: knob.value != null,
                    onChanged: (_) => toggleNull(),
                  )
                ],
              )
            ],
          ),
        );
}
