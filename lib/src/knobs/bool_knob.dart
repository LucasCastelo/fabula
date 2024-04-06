import 'package:flutter/material.dart';
import 'package:storyto/src/knobs/knob.dart';

class BoolKnob extends DefaultKnob<bool> {
  BoolKnob({
    required super.initialValue,
  }) : super(
          inputBuilder: (knob) => GestureDetector(
            onTap: () => knob.setValue(!knob.getValue()),
            child: const Text('TOGGLE'),
          ),
        );
}
