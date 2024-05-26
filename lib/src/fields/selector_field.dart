import 'package:flutter/material.dart';
import 'package:storyto/src/knobs/knob.dart';
import 'package:storyto/src/knobs/n_selector_knob.dart';

class SelectorField<T> extends StatelessWidget {
  const SelectorField({
    super.key,
    required this.knob,
    required this.options,
    required this.nameMarshal,
  });

  final Knob<T?> knob;
  final List<T> options;
  final SelectorNameMarshal<T> nameMarshal;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: knob,
      builder: (context, value, _) {
        return DropdownButton<T>(
          value: value,
          onChanged: (v) => v != null ? knob.setValue(v) : null,
          items: List.generate(
            options.length,
            (index) => DropdownMenuItem(
              value: options[index],
              child: Text(
                nameMarshal(options[index]),
              ),
            ),
          ),
        );
      },
    );
  }
}
