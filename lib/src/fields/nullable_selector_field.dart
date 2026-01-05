import 'package:flutter/material.dart';
import 'package:fabula/src/entities/knob.dart';
import 'package:fabula/src/fields/selector_field.dart';

import 'package:fabula/src/widgets/nullable_toggler.dart';

typedef SelectorNameMarshal<T> = String Function(T element);

class NullableSelectorField<T> extends StatelessWidget {
  const NullableSelectorField({
    super.key,
    required this.knob,
    required this.values,
    required this.nameMarshal,
  });

  final NullableKnob<T> knob;
  final List<T> values;
  final SelectorNameMarshal<T> nameMarshal;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        ListenableBuilder(
          listenable: knob,
          builder: (context, __) => SelectorField<T>(
            knob: knob,
            options: values,
            nameMarshal: nameMarshal,
            isEnabled: knob.isFieldEnabled,
          ),
        ),
        NullableToggler(
          onClick: knob.toggleNull,
          isEnabled: knob.isFieldEnabled,
        )
      ],
    );
  }
}
