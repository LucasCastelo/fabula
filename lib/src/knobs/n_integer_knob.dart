import 'package:flutter/material.dart';
import 'package:storyto/src/entities/knob_text_field_decoration.dart';
import 'package:storyto/src/knobs/knob.dart';
import 'package:storyto/src/widgets/custom_text_field.dart';

class NIntegerKnob extends NullableKnob<int> {
  NIntegerKnob({
    required KnobTextFieldDecoration decoration,
    required super.initialValue,
    required super.startAsNull,
  }) : super(
          inputBuilder: (knob, toggleNull) => Row(
            children: [
              Expanded(
                child: CustomTextField(
                  isEnabled: knob.getValue() != null,
                  onChanged: (v) => knob.setValue(int.parse(v)),
                  initialValue: initialValue.toString(),
                  decoration: decoration,
                  keyboardType: TextInputType.number,
                ),
              ),
              Builder(
                builder: (context) {
                  return Container(
                    color: Colors.red,
                    child: GestureDetector(
                      onTap: () {
                        FocusScope.of(context).unfocus();
                        toggleNull();
                      },
                      child: const Text(
                        "NULL",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  );
                },
              )
            ],
          ),
        );
}
