import 'package:flutter/material.dart';
import 'package:fabula/src/entities/knob.dart';
import 'package:fabula/src/fields/nullable_selector_field.dart';
import 'package:fabula/src/widgets/general/knob_label.dart';

class SelectorField<T> extends StatelessWidget {
  const SelectorField({
    super.key,
    required this.knob,
    required this.options,
    required this.nameMarshal,
    required this.label,
    this.description,
    this.isEnabled = true,
  });

  final Knob<T?> knob;
  final List<T> options;
  final SelectorNameMarshal<T> nameMarshal;
  final String label;
  final String? description;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final isNull = knob.getValue() == null;
    final field = Container(
      width: double.infinity,
      padding: const EdgeInsetsDirectional.symmetric(horizontal: 8),
      decoration: BoxDecoration(
          border: Border.all(
            color: isEnabled ? Colors.black38 : Colors.black12,
            width: 1.2,
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
              isExpanded: true,
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        KnobLabel(
          label: label,
          description: description,
          style: TextStyle(color: isEnabled ? Colors.black : Colors.grey),
        ),
        const SizedBox(height: 4),
        field,
      ],
    );
  }
}
