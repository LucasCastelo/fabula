import 'package:flutter/material.dart';

class DurationChanger extends StatefulWidget {
  const DurationChanger({
    super.key,
    required this.initialDuration,
    required this.onChanged,
  });

  final Duration initialDuration;
  final void Function(Duration) onChanged;

  @override
  State<DurationChanger> createState() => _DurationChangerState();
}

class _DurationChangerState extends State<DurationChanger> {
  double durationMultiplier = 1;
  late final int initialDurationMilliseconds =
      widget.initialDuration.inMilliseconds;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Slider(
            value: durationMultiplier,
            min: 0.5,
            max: 5,
            activeColor: Colors.black,
            onChanged: (v) {
              setState(() {
                durationMultiplier = v;
              });
              widget.onChanged(
                Duration(
                  milliseconds: (v * initialDurationMilliseconds).toInt(),
                ),
              );
            },
          ),
        ),
        GestureDetector(
          onTap: () {
            if (durationMultiplier == 1) return;

            setState(() {
              durationMultiplier = 1;
            });
            widget.onChanged(
              Duration(
                milliseconds:
                    (durationMultiplier * initialDurationMilliseconds).toInt(),
              ),
            );
          },
          child: const Icon(Icons.replay),
        ),
      ],
    );
  }
}
