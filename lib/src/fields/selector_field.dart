import 'package:flutter/material.dart';
import 'package:storyto/src/entities/knob.dart';
import 'package:storyto/src/fields/nullable_selector_field.dart';

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
    final isNull = knob.getValue() == null;
    return Container(
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          border: Border.all(
            color: isNull ? Colors.grey : Colors.black,
            width: 1,
          ),
          borderRadius: BorderRadius.circular(4)),
      child: knob.getValue() == null
          ? Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 14,
              ),
              child: Text(
                'Disabled',
                style: TextStyle(
                  color: isNull ? Colors.grey : Colors.black,
                ),
              ),
            )
          : DropdownButton<T>(
              value: knob.getValue(),
              onChanged: (v) => v != null ? knob.setValue(v) : null,
              underline: const SizedBox.shrink(),
              items: List.generate(
                options.length,
                (index) => DropdownMenuItem(
                  value: options[index],
                  child: Text(
                    nameMarshal(options[index]),
                  ),
                ),
              ),
            ),
    );
  }
}
