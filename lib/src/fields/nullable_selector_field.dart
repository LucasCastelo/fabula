import 'package:flutter/material.dart';
import 'package:storyto/src/entities/knob.dart';
import 'package:storyto/src/fields/selector_field.dart';

typedef SelectorNameMarshal<T> = String Function(T element);

class NullableSelectorField<T> extends StatelessWidget {
  const NullableSelectorField({
    super.key,
    required this.knob,
    required this.values,
    required this.nameMarshal,
    required this.toggleNull,
  });

  final Knob<T> knob;
  final List<T> values;
  final SelectorNameMarshal<T> nameMarshal;
  final VoidCallback toggleNull;

  @override
  Widget build(BuildContext context) {
    return Row(
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
    );
  }
}
