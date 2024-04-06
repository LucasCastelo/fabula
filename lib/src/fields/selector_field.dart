import 'package:flutter/material.dart';
import 'package:storyto/src/knobs/n_selector_knob.dart';

class SelectorField<T> extends StatelessWidget {
  const SelectorField({
    super.key,
    required this.options,
    required this.setValue,
    required this.nameMarshal,
  });

  final ValueSetter<T> setValue;
  final List<T> options;
  final SelectorNameMarshal<T> nameMarshal;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<T>(
      onChanged: (v) => v != null ? setValue(v) : null,
      items: List.generate(
        options.length,
        (index) => DropdownMenuItem(
          child: Text(
            nameMarshal(options[index]),
          ),
        ),
      ),
    );
  }
}
