import 'package:flutter/material.dart';
import 'package:fabula/src/entities/color_holster.dart';
import 'package:fabula/src/entities/knob.dart';
import 'package:fabula/src/entities/knob_text_field_decoration.dart';
import 'package:fabula/src/helpers/hex_color.dart';
import 'package:fabula/src/widgets/color_holster_picker.dart';
import 'package:fabula/src/widgets/general/custom_text_field.dart';
import 'package:fabula/src/widgets/general/hsv_sliders.dart';
import 'package:fabula/src/widgets/general/touch.dart';
import 'package:fabula/src/widgets/nullable_toggler.dart';

class NullableColorField extends StatefulWidget {
  const NullableColorField({
    super.key,
    required this.knob,
    required this.label,
    required this.toggleNull,
    this.keyboardType,
    this.holsters,
    this.description,
  });

  final String label;
  final NullableKnob<Color?> knob;
  final TextInputType? keyboardType;
  final VoidCallback toggleNull;
  final List<ColorHolster>? holsters;
  final String? description;

  @override
  State<NullableColorField> createState() => _NullableColorFieldState();
}

class _NullableColorFieldState extends State<NullableColorField> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final knob = widget.knob;
    final color = knob.getValue();
    final currentHex = color == null ? null : hexStringFor(color);
    final holsters = widget.holsters;
    final canShowSliders = color != null && knob.isFieldEnabled;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        CustomTextField(
          maxLength: 8,
          suffix: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(4),
              color: (color ?? knob.lastKnowValue)
                  ?.withAlpha((knob.isFieldEnabled ? 255 : 50).toInt()),
            ),
            height: 18,
            width: 18,
          ),
          onChanged: (v) {
            final parsed = tryParseHexColor(v);
            if (parsed != null) knob.setValue(parsed);
          },
          description: widget.description,
          keyboardType: TextInputType.text,
          isEnabled: knob.isFieldEnabled,
          initialValue: currentHex,
          decoration: KnobTextFieldDecoration(label: widget.label),
          value: currentHex,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (holsters != null && holsters.isNotEmpty)
                  ColorHolsterPicker(
                    holsters: holsters,
                    onColorSelected: knob.setValue,
                  ),
                if (canShowSliders)
                  _SlidersToggle(
                    expanded: _expanded,
                    onTap: () => setState(() => _expanded = !_expanded),
                  ),
              ],
            ),
            NullableToggler(
              onClick: widget.toggleNull,
              isEnabled: knob.isFieldEnabled,
            ),
          ],
        ),
        ClipRect(
          child: AnimatedAlign(
            alignment: Alignment.topCenter,
            heightFactor: (_expanded && canShowSliders) ? 1 : 0,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            child: color == null
                ? const SizedBox.shrink()
                : HsvSliders(
                    color: color,
                    onChanged: knob.setValue,
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
