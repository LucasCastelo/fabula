import 'package:flutter/material.dart';

/// HSV + alpha slider stack for editing a [Color]. Each change is fed back to
/// [onChanged] as a fresh [Color] value.
class HsvSliders extends StatelessWidget {
  const HsvSliders({
    super.key,
    required this.color,
    required this.onChanged,
  });

  final Color color;
  final ValueSetter<Color> onChanged;

  @override
  Widget build(BuildContext context) {
    final hsv = HSVColor.fromColor(color);
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _row(
          label: 'Hue',
          value: hsv.hue,
          min: 0,
          max: 360,
          format: (v) => v.round().toString(),
          onChanged: (v) => onChanged(hsv.withHue(v).toColor()),
        ),
        _row(
          label: 'Sat',
          value: hsv.saturation,
          min: 0,
          max: 1,
          format: (v) => v.toStringAsFixed(2),
          onChanged: (v) => onChanged(hsv.withSaturation(v).toColor()),
        ),
        _row(
          label: 'Val',
          value: hsv.value,
          min: 0,
          max: 1,
          format: (v) => v.toStringAsFixed(2),
          onChanged: (v) => onChanged(hsv.withValue(v).toColor()),
        ),
        _row(
          label: 'Alpha',
          value: hsv.alpha,
          min: 0,
          max: 1,
          format: (v) => v.toStringAsFixed(2),
          onChanged: (v) => onChanged(hsv.withAlpha(v).toColor()),
        ),
      ],
    );
  }

  Widget _row({
    required String label,
    required double value,
    required double min,
    required double max,
    required String Function(double) format,
    required ValueChanged<double> onChanged,
  }) {
    return Row(
      children: [
        SizedBox(
          width: 44,
          child: Text(
            label,
            style: const TextStyle(fontSize: 11, color: Colors.black54),
          ),
        ),
        Expanded(
          child: SliderTheme(
            data: SliderThemeData(
              trackHeight: 2,
              activeTrackColor: Colors.black54,
              inactiveTrackColor: Colors.black12,
              thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 5),
              overlayShape: const RoundSliderOverlayShape(overlayRadius: 10),
            ),
            child: Slider(
              value: value.clamp(min, max),
              min: min,
              max: max,
              onChanged: onChanged,
            ),
          ),
        ),
        SizedBox(
          width: 36,
          child: Text(
            format(value),
            textAlign: TextAlign.right,
            style: const TextStyle(
              fontFamily: 'monospace',
              fontSize: 11,
              color: Colors.black54,
            ),
          ),
        ),
      ],
    );
  }
}
