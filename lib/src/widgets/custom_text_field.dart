import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.isEnabled,
    required this.onChanged,
    required this.initialValue,
    required this.keyboardType,
  });

  final bool isEnabled;
  final String? initialValue;
  final ValueSetter<String> onChanged;
  final TextInputType? keyboardType;

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

  @override
  Widget build(BuildContext context) {
    return TextField(
      enabled: widget.isEnabled,
      controller: controller,
      onChanged: widget.onChanged,
      style: const TextStyle(),
      keyboardType: widget.keyboardType,
    );
  }
}
