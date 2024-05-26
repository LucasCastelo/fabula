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
          inputBuilder: (knob, toggleNull) => ValueListenableBuilder(
            valueListenable: knob,
            builder: (context, value, _) => Row(
              children: [
                Expanded(
                  child: knob.value == null
                      ? const Text(
                          'Value set to NULL',
                          textAlign: TextAlign.center,
                        )
                      : SelectorField<T>(
                          knob: knob,
                          options: values,
                          nameMarshal: nameMarshal,
                        ),
                ),
                GestureDetector(
                  onTap: toggleNull,
                  child: const Text('NULL'),
                )
              ],
            ),
          ),
        );
}
