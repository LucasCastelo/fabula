import 'package:flutter/material.dart';
import 'package:fabula/src/entities/color_holster.dart';
import 'package:fabula/src/entities/knob.dart';
import 'package:fabula/src/entities/knob_text_field_decoration.dart';
import 'package:fabula/src/helpers/hex_color.dart';
import 'package:fabula/src/widgets/color_holster_picker.dart';
import 'package:fabula/src/widgets/general/custom_text_field.dart';
import 'package:fabula/src/widgets/general/hsv_sliders.dart';
import 'package:fabula/src/widgets/general/touch.dart';

class ColorField extends StatefulWidget {
  const ColorField({
    super.key,
    required this.knob,
    required this.label,
    this.keyboardType,
    this.holsters,
    this.description,
  });

  final String label;
  final Knob<Color> knob;
  final TextInputType? keyboardType;
  final List<ColorHolster>? holsters;
  final String? description;

  @override
  State<ColorField> createState() => _ColorFieldState();
}

class _ColorFieldState extends State<ColorField> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final color = widget.knob.getValue();
    final currentHex = hexStringFor(color);
    final holsters = widget.holsters;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextField(
          value: currentHex,
          description: widget.description,
          maxLength: 8,
          suffix: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: color,
            ),
            height: 18,
            width: 18,
          ),
          onChanged: (v) {
            final parsed = tryParseHexColor(v);
            if (parsed != null) widget.knob.setValue(parsed);
          },
          keyboardType: widget.keyboardType,
          isEnabled: true,
          initialValue: currentHex,
          decoration: KnobTextFieldDecoration(label: widget.label),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (holsters != null && holsters.isNotEmpty)
              ColorHolsterPicker(
                holsters: holsters,
                onColorSelected: widget.knob.setValue,
              )
            else
              const SizedBox.shrink(),
            _SlidersToggle(
              expanded: _expanded,
              onTap: () => setState(() => _expanded = !_expanded),
            ),
          ],
        ),
        ClipRect(
          child: AnimatedAlign(
            alignment: Alignment.topCenter,
            heightFactor: _expanded ? 1 : 0,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            child: HsvSliders(
              color: color,
              onChanged: widget.knob.setValue,
            ),
          ),
        ),
      ],
    );
  }
}

class _SlidersToggle extends StatelessWidget {
  const _SlidersToggle({required this.expanded, required this.onTap});

  final bool expanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Touch(
      semanticsLabel: 'Toggle HSV sliders',
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedRotation(
              turns: expanded ? 0 : -0.25,
              duration: const Duration(milliseconds: 150),
              child: const Icon(
                Icons.expand_more,
                size: 14,
                color: Colors.black54,
              ),
            ),
            const SizedBox(width: 2),
            const Text(
              'HSV',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}
