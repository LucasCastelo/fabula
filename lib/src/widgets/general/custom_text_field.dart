import 'package:flutter/material.dart';
import 'package:storyto/src/entities/knob_text_field_decoration.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.isEnabled,
    required this.onChanged,
    required this.initialValue,
    required this.decoration,
    required this.keyboardType,
    this.suffix,
    this.value,
    this.description,
    this.maxLength,
  });

  final bool isEnabled;
  final String? initialValue;
  final Widget? suffix;
  final ValueSetter<String> onChanged;
  final KnobTextFieldDecoration decoration;
  final TextInputType? keyboardType;
  final String? value;
  final String? description;
  final int? maxLength;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  final controller = TextEditingController();

  @override
  void initState() {
    if (widget.initialValue != null) {
      controller.text = widget.initialValue!;
    }
    super.initState();
  }

  int get textLength => controller.text.length;

  @override
  Widget build(BuildContext context) {
    final description = widget.description;
    final placeholder =
        widget.decoration.placeholder ?? widget.decoration.label;
    const enabledBorder = OutlineInputBorder(
      borderSide: BorderSide(
        color: Colors.black38,
        width: 1.2,
      ),
    );

    if (widget.value != null) {
      controller.text = widget.value!;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          widget.decoration.label,
          style: TextStyle(
            color: widget.isEnabled ? Colors.black : Colors.grey,
          ),
        ),
        if (description != null)
          Text(
            description,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        const SizedBox(height: 4),
        TextField(
          enabled: widget.isEnabled,
          controller: controller,
          onChanged: widget.onChanged,
          style: const TextStyle(),
          minLines: 1,
          maxLines: null,
          keyboardType: widget.keyboardType ?? TextInputType.multiline,
          decoration: InputDecoration(
            suffix: ValueListenableBuilder(
              valueListenable: controller,
              builder: (context, value, child) {
                final maxLengthExceeded =
                    widget.maxLength != null && textLength > widget.maxLength!;

                return Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (widget.suffix != null) widget.suffix!,
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      margin: const EdgeInsetsDirectional.only(start: 8),
                      decoration: BoxDecoration(
                        color: maxLengthExceeded
                            ? Colors.red
                            : Colors.grey.withAlpha((255 * 0.2).toInt()),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        widget.maxLength != null
                            ? '$textLength/${widget.maxLength}'
                            : textLength.toString(),
                        style: TextStyle(
                          fontSize: 12,
                          color: widget.isEnabled
                              ? maxLengthExceeded
                                  ? Colors.white
                                  : Colors.black
                              : Colors.grey,
                        ),
                      ),
                    )
                  ],
                );
              },
            ),
            contentPadding: const EdgeInsets.all(8),
            hintText: placeholder,
            hintStyle: TextStyle(
              color: widget.isEnabled ? Colors.grey : Colors.black12,
            ),
            border: enabledBorder,
            enabledBorder: enabledBorder,
            focusedBorder: enabledBorder,
          ),
        ),
      ],
    );
  }
}
