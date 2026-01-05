import 'package:flutter/material.dart';
import 'package:storyto/src/entities/knob.dart';
import 'package:storyto/src/fields/selector_field.dart';

import 'package:storyto/src/widgets/nullable_toggler.dart';

typedef SelectorNameMarshal<T> = String Function(T element);

class NullableSelectorField<T> extends StatelessWidget {
  const NullableSelectorField({
    super.key,
    required this.knob,
    required this.values,
    required this.nameMarshal,
    required this.toggleNull,
  });

  final NullableKnob<T> knob;
  final List<T> values;
  final SelectorNameMarshal<T> nameMarshal;
  final VoidCallback toggleNull;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SelectorField<T>(
          knob: knob,
          options: values,
          nameMarshal: nameMarshal,
        ),
        NullableToggler(
          onClick: toggleNull,
          isEnabled: knob.isFieldEnabled,
        )
      ],
    );
  }
}
