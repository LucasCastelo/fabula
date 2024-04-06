import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:storyto/src/fields/selector_field.dart';
import 'package:storyto/src/knobs/knob.dart';

typedef SelectorNameMarshal<T> = String Function(T element);

class NSelectorKnob<T> extends NullableKnob<T> {
  NSelectorKnob({
    required List<T> values,
    required super.startAsNull,
    required SelectorNameMarshal<T> nameMarshal,
  }) : super(
          defaultValue: values[0],
          inputBuilder: (knob, toggleNull) => Row(
            children: [
              Expanded(
                child: SelectorField(
                  options: values,
                  setValue: knob.setValue,
                  nameMarshal: nameMarshal,
                ),
              ),
              GestureDetector(
                onTap: toggleNull,
                child: const Text('NULL'),
              )
            ],
          ),
        );
}
