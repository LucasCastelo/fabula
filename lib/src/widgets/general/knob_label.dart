import 'package:flutter/material.dart';

/// A knob label with an inline info icon that reveals [description] on tap.
class KnobLabel extends StatelessWidget {
  const KnobLabel({
    super.key,
    required this.label,
    this.description,
    this.style,
  });

  final String label;
  final String? description;
  final TextStyle? style;

  @override
  Widget build(BuildContext context) {
    final description = this.description;
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Flexible(child: Text(label, style: style)),
        if (description != null) ...[
          const SizedBox(width: 4),
          Tooltip(
            message: description,
            triggerMode: TooltipTriggerMode.tap,
            showDuration: const Duration(seconds: 4),
            preferBelow: false,
            child: const Icon(
              Icons.info_outline,
              size: 14,
              color: Colors.black54,
            ),
          ),
        ],
      ],
    );
  }
}
