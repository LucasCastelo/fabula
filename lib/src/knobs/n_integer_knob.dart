import 'package:flutter/material.dart';
import 'package:storyto/src/fields/custom_text_field.dart';
import 'package:storyto/src/knobs/knob.dart';

class NIntegerKnob extends NullableKnob<int> {
  NIntegerKnob({
    required super.initialValue,
    required super.startAsNull,
  }) : super(
          inputBuilder: (knob, toggleNull) => Row(
            children: [
              Expanded(
                child: KnobTextField(
                  knob: knob,
                  keyboardType: TextInputType.number,
                  marshal: (v) => int.parse(v),
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
