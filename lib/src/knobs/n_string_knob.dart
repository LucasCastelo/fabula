import 'package:flutter/material.dart';
import 'package:storyto/src/fields/custom_text_field.dart';
import 'package:storyto/src/knobs/knob.dart';

class NStringKnob extends NullableKnob<String?> {
  NStringKnob({
    required super.defaultValue,
    required super.startAsNull,
  }) : super(
          inputBuilder: <String>(knob, toggleNull) => Row(
            children: [
              Expanded(
                child: KnobTextField(
                  knob: knob,
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
