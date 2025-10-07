import 'package:flutter/material.dart';
import 'package:storyto/src/entities/knob.dart';
import 'package:storyto/src/widget/duration_changer.dart';

class AnimationPlayer extends StatefulWidget {
  const AnimationPlayer({super.key, required this.knob});

  final Knob<AnimationController> knob;

  @override
  State<AnimationPlayer> createState() => _AnimationPlayerState();
}

class _AnimationPlayerState extends State<AnimationPlayer> {
  RangeValues animationLoopRange = const RangeValues(0, 1);
  late final animationController = widget.knob.value;
  bool autoPlay = false;

  @override
  void initState() {
    super.initState();
    widget.knob.value.addListener(animationRangedLoop);
  }

  void changeAnimationLoopRange(RangeValues range) {
    setState(() => animationLoopRange = range);
    if (animationController.value > range.end) {
      animationController.value = range.end;
    }

    if (animationController.value < range.start) {
      animationController.value = range.start;
    }
  }

  void animationRangedLoop() {
    if (!autoPlay) return;

    final currentValue = animationController.value * 100;
    final start = animationLoopRange.start * 100;
    final end = animationLoopRange.end * 100;

    if (currentValue >= end) {
      animationController.value = animationLoopRange.start;
    }

    if (currentValue < start) {
      animationController.value = animationLoopRange.start;
    }

    animationController.forward();
  }

  void reset() {
    if (animationLoopRange.start == 0 && animationLoopRange.end == 1) {
      animationController.stop();
    } else {
      animationController.stop();
      animationController.value = animationLoopRange.end;
    }
  }

  void play() {
    if (animationController.value.round() != animationLoopRange.end.round()) {
      animationController.forward();
    } else {
      animationController.value = animationLoopRange.start;
      animationController.forward();
    }
  }

  String getAnimationStatus() {
    switch (animationController.status) {
      case AnimationStatus.dismissed:
        return 'Dismissed';
      case AnimationStatus.forward:
        return 'Forward';
      case AnimationStatus.reverse:
        return 'Reverse';
      case AnimationStatus.completed:
        return 'Completed';
    }
  }

  @override
  Widget build(BuildContext context) {
    const buttonSize = 32.0;
    return ValueListenableBuilder(
      valueListenable: widget.knob.value,
      builder: (context, value, _) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () => play(),
                  child: const Icon(
                    Icons.play_arrow,
                    size: buttonSize,
                  ),
                ),
                GestureDetector(
                  onTap: () => widget.knob.value.stop(),
                  child: const Icon(
                    Icons.pause,
                    size: buttonSize,
                  ),
                ),
                GestureDetector(
                  onTap: () => reset(),
                  child: const Icon(
                    Icons.stop,
                    size: buttonSize,
                  ),
                ),
                GestureDetector(
                  onTap: () => setState(() => autoPlay = !autoPlay),
                  child: Icon(
                    Icons.refresh,
                    size: buttonSize,
                    color: autoPlay ? Colors.black : Colors.black26,
                  ),
                ),
              ],
            ),
            Text(
              'Progress: ${(animationController.value * 100).toStringAsFixed(0)}%',
            ),
            Text(getAnimationStatus()),
            Text(
              'Duration: ${animationController.duration?.inMilliseconds}ms',
            ),
            DurationChanger(
              initialDuration:
                  animationController.duration ?? const Duration(seconds: 5),
              onChanged: (v) {
                setState(() => animationController.duration = v);
                animationController.stop();
                animationController.forward();
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                    '${(animationLoopRange.start * 100).toStringAsFixed(0).padLeft(3, '0')}%'),
                Expanded(
                  child: RangeSlider(
                    values: animationLoopRange,
                    onChanged: (v) => changeAnimationLoopRange(v),
                    labels: RangeLabels(
                      animationLoopRange.start.toString(),
                      animationLoopRange.end.toString(),
                    ),
                    activeColor: Colors.black,
                  ),
                ),
                Text(
                    '${(animationLoopRange.end * 100).toStringAsFixed(0).padLeft(3, '0')}%'),
              ],
            ),
          ],
        );
      },
    );
  }
}
