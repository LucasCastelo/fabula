import 'package:flutter/material.dart';
import 'package:storyto/src/knobs/knob.dart';
import 'package:storyto/src/widgets/custom_text_field.dart';

typedef InputMarshal<T> = T Function(String v);

class KnobTextField extends StatefulWidget {
  const KnobTextField({
    super.key,
    required this.knob,
    this.keyboardType,
    this.marshal,
  });

  final Knob knob;
  final TextInputType? keyboardType;
  final InputMarshal? marshal;

  @override
  State<KnobTextField> createState() => _KnobTextFieldState();
}

class _KnobTextFieldState extends State<KnobTextField> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // REMOVE LISTENER
    return ValueListenableBuilder(
      valueListenable: widget.knob,
      builder: (BuildContext context, value, Widget? child) {
        if (value != controller.value.text) {
          controller.text = value is! String ? value.toString() : value;
        }

        return CustomTextField(
          key: ValueKey(widget.knob),
          initialValue: '',
          isEnabled: value != null,
          onChanged: widget.marshal != null
              ? (v) => widget.knob.setValue(widget.marshal!(v))
              : widget.knob.setValue,
          keyboardType: widget.keyboardType,
        );
      },
    );
  }
}
