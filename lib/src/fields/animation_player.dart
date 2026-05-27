import 'package:flutter/material.dart';
import 'package:fabula/src/entities/knob.dart';
import 'package:fabula/src/widgets/general/knob_label.dart';
import 'package:fabula/src/widgets/general/touch.dart';

enum _RepeatMode { off, loop, pingPong }

class AnimationPlayer extends StatefulWidget {
  const AnimationPlayer({
    super.key,
    required this.knob,
    required this.label,
  });

  final Knob<AnimationController> knob;
  final String label;

  @override
  State<AnimationPlayer> createState() => _AnimationPlayerState();
}

class _AnimationPlayerState extends State<AnimationPlayer> {
  late final AnimationController controller = widget.knob.value;
  late Duration _baseDuration =
      controller.duration ?? const Duration(seconds: 1);
  RangeValues loopRange = const RangeValues(0, 1);
  _RepeatMode repeatMode = _RepeatMode.off;
  double _speed = 1.0;
  bool _advancedExpanded = false;

  static const _speedOptions = <double>[-5, -3, 1, 3, 5];
  static const _durationDeltasMs = <int>[-1000, -500, -100, 100, 500, 1000];
  static const _minDurationMs = 50;
  static const _maxDurationMs = 600000;
  static const _stepDelta = 0.05;
  static const _buttonSize = 22.0;

  @override
  void initState() {
    super.initState();
    controller.addStatusListener(_onStatusChanged);
  }

  @override
  void dispose() {
    controller.removeStatusListener(_onStatusChanged);
    super.dispose();
  }

  void _onStatusChanged(AnimationStatus status) {
    if (!mounted) return;
    setState(() {});
    if (status == AnimationStatus.completed) {
      switch (repeatMode) {
        case _RepeatMode.off:
          break;
        case _RepeatMode.loop:
          controller.value = loopRange.start;
          controller.animateTo(loopRange.end);
        case _RepeatMode.pingPong:
          controller.animateBack(loopRange.start);
      }
    } else if (status == AnimationStatus.dismissed) {
      if (repeatMode == _RepeatMode.pingPong) {
        controller.animateTo(loopRange.end);
      }
    }
  }

  Duration _scaledDuration(double speed) {
    final ms = _baseDuration.inMilliseconds;
    final scaled = speed > 0 ? ms / speed : ms * speed.abs();
    return Duration(milliseconds: scaled.round().clamp(1, 600000));
  }

  void _setSpeed(double speed) {
    setState(() => _speed = speed);
    controller.duration = _scaledDuration(speed);
    _play();
  }

  void _adjustBaseDuration(int deltaMs) {
    final next = (_baseDuration.inMilliseconds + deltaMs)
        .clamp(_minDurationMs, _maxDurationMs);
    setState(() => _baseDuration = Duration(milliseconds: next));
    controller.duration = _scaledDuration(_speed);

    // Re-issue the in-flight animation so the new duration takes effect now,
    // not on the next play action.
    if (controller.isAnimating) {
      switch (controller.status) {
        case AnimationStatus.forward:
          controller.animateTo(loopRange.end);
        case AnimationStatus.reverse:
          controller.animateBack(loopRange.start);
        case AnimationStatus.completed:
        case AnimationStatus.dismissed:
          break;
      }
    }
  }

  String _formatBaseDuration() {
    final ms = _baseDuration.inMilliseconds;
    if (ms < 1000) return '${ms}ms';
    final s = ms / 1000;
    final str = s == s.truncate() ? s.toInt().toString() : s.toStringAsFixed(1);
    return '${str}s';
  }

  String _formatDelta(int ms) {
    final sign = ms >= 0 ? '+' : '−';
    final abs = ms.abs();
    if (abs >= 1000 && abs % 1000 == 0) return '$sign${abs ~/ 1000}s';
    return '$sign${abs}ms';
  }

  void _play() {
    if (controller.value >= loopRange.end) {
      controller.value = loopRange.start;
    }
    controller.animateTo(loopRange.end);
  }

  void _reverse() {
    if (controller.value <= loopRange.start) {
      controller.value = loopRange.end;
    }
    controller.animateBack(loopRange.start);
  }

  void _pause() => controller.stop();

  void _reset() {
    controller.stop();
    controller.value = loopRange.start;
  }

  void _step(double delta) {
    controller.stop();
    controller.value = (controller.value + delta).clamp(
      loopRange.start,
      loopRange.end,
    );
  }

  void _scrub(double v) {
    controller.stop();
    controller.value = v.clamp(loopRange.start, loopRange.end);
  }

  void _cycleRepeatMode() {
    setState(() {
      repeatMode = _RepeatMode
          .values[(repeatMode.index + 1) % _RepeatMode.values.length];
    });
  }

  void _changeLoopRange(RangeValues range) {
    setState(() => loopRange = range);
    if (controller.value > range.end) controller.value = range.end;
    if (controller.value < range.start) controller.value = range.start;
  }

  IconData get _repeatIcon {
    switch (repeatMode) {
      case _RepeatMode.off:
      case _RepeatMode.loop:
        return Icons.repeat;
      case _RepeatMode.pingPong:
        return Icons.compare_arrows;
    }
  }

  Color get _repeatColor =>
      repeatMode == _RepeatMode.off ? Colors.black26 : Colors.black;

  Color get _statusColor {
    switch (controller.status) {
      case AnimationStatus.forward:
        return Colors.green;
      case AnimationStatus.reverse:
        return Colors.orange;
      case AnimationStatus.completed:
      case AnimationStatus.dismissed:
        return Colors.black54;
    }
  }

  String _formatTime(Duration d) {
    final ms = d.inMilliseconds;
    final s = (ms / 1000).floor();
    final mm = s ~/ 60;
    final ss = s % 60;
    final hh = (ms % 1000) ~/ 10;
    final mmStr = mm.toString().padLeft(2, '0');
    final ssStr = ss.toString().padLeft(2, '0');
    final hhStr = hh.toString().padLeft(2, '0');
    return '$mmStr:$ssStr.$hhStr';
  }

  Widget _iconButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
    Color? color,
  }) {
    return Touch(
      semanticsLabel: label,
      onTap: onTap,
      child: Icon(icon, size: _buttonSize, color: color),
    );
  }

  Widget _speedButton(double speed) {
    final sign = speed < 0 ? '-' : '';
    final label = '$sign${speed.abs().toInt()}x';
    return _pillButton(
      label: label,
      isActive: _speed == speed,
      semantics: 'Play at $label',
      onTap: () => _setSpeed(speed),
    );
  }

  Widget _durationDeltaButton(int deltaMs) {
    final label = _formatDelta(deltaMs);
    return _pillButton(
      label: label,
      isActive: false,
      semantics: 'Adjust duration by $label',
      onTap: () => _adjustBaseDuration(deltaMs),
    );
  }

  Widget _pillButton({
    required String label,
    required bool isActive,
    required String semantics,
    required VoidCallback onTap,
  }) {
    return Touch(
      semanticsLabel: semantics,
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? Colors.black : Colors.black.withAlpha(15),
          borderRadius: BorderRadius.circular(4),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isActive ? Colors.white : Colors.black87,
            fontSize: 11,
            fontWeight: FontWeight.w500,
            fontFamily: 'monospace',
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: controller,
      builder: (context, value, _) {
        final duration = controller.duration ?? Duration.zero;
        final elapsed = Duration(
          milliseconds: (duration.inMilliseconds * value).toInt(),
        );

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            KnobLabel(
              label: widget.label,
              description: widget.knob.description,
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                _iconButton(
                  icon: Icons.chevron_left,
                  label: 'Step back',
                  onTap: () => _step(-_stepDelta),
                ),
                _iconButton(
                  icon: Icons.fast_rewind,
                  label: 'Reverse',
                  onTap: _reverse,
                ),
                const SizedBox(width: 2),
                _iconButton(
                  icon: Icons.play_arrow,
                  label: 'Play',
                  onTap: _play,
                ),
                _iconButton(
                  icon: Icons.pause,
                  label: 'Pause',
                  onTap: _pause,
                ),
                _iconButton(
                  icon: Icons.replay,
                  label: 'Reset',
                  onTap: _reset,
                ),
                const SizedBox(width: 2),
                _iconButton(
                  icon: Icons.chevron_right,
                  label: 'Step forward',
                  onTap: () => _step(_stepDelta),
                ),
                const Spacer(),
                _iconButton(
                  icon: _repeatIcon,
                  label: 'Repeat ${repeatMode.name}',
                  onTap: _cycleRepeatMode,
                  color: _repeatColor,
                ),
              ],
            ),
            SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3,
                thumbShape:
                    const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape:
                    const RoundSliderOverlayShape(overlayRadius: 12),
                activeTrackColor: _statusColor,
                inactiveTrackColor: Colors.black12,
                thumbColor: _statusColor,
              ),
              child: Slider(
                value: value.clamp(0.0, 1.0),
                onChanged: _scrub,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  _formatTime(elapsed),
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    color: Colors.black87,
                  ),
                ),
                Text(
                  _formatTime(duration),
                  style: const TextStyle(
                    fontFamily: 'monospace',
                    fontSize: 11,
                    color: Colors.black54,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                for (final option in _speedOptions) ...[
                  Expanded(child: _speedButton(option)),
                  if (option != _speedOptions.last)
                    const SizedBox(width: 4),
                ],
              ],
            ),
            const SizedBox(height: 4),
            Touch(
              semanticsLabel: 'Toggle advanced controls',
              onTap: () =>
                  setState(() => _advancedExpanded = !_advancedExpanded),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    AnimatedRotation(
                      turns: _advancedExpanded ? 0 : -0.25,
                      duration: const Duration(milliseconds: 150),
                      child: const Icon(
                        Icons.expand_more,
                        size: 16,
                        color: Colors.black54,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Text(
                      'Advanced',
                      style: TextStyle(fontSize: 11, color: Colors.black54),
                    ),
                  ],
                ),
              ),
            ),
            ClipRect(
              child: AnimatedAlign(
                alignment: Alignment.topCenter,
                heightFactor: _advancedExpanded ? 1 : 0,
                duration: const Duration(milliseconds: 150),
                curve: Curves.easeInOut,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 4, bottom: 4),
                      child: Row(
                        children: [
                          const Text(
                            'Duration',
                            style: TextStyle(
                                fontSize: 11, color: Colors.black54),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatBaseDuration(),
                            style: const TextStyle(
                              fontFamily: 'monospace',
                              fontSize: 11,
                              color: Colors.black38,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        for (final delta in _durationDeltasMs) ...[
                          Expanded(child: _durationDeltaButton(delta)),
                          if (delta != _durationDeltasMs.last)
                            const SizedBox(width: 4),
                        ],
                      ],
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text(
                          'Loop',
                          style:
                              TextStyle(fontSize: 11, color: Colors.black54),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${(loopRange.start * 100).toStringAsFixed(0)}–'
                          '${(loopRange.end * 100).toStringAsFixed(0)}%',
                          style: const TextStyle(
                            fontFamily: 'monospace',
                            fontSize: 11,
                            color: Colors.black38,
                          ),
                        ),
                      ],
                    ),
                    SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 2,
                        activeTrackColor: Colors.black54,
                        inactiveTrackColor: Colors.black12,
                        rangeThumbShape: const RoundRangeSliderThumbShape(
                            enabledThumbRadius: 5),
                        overlayShape:
                            const RoundSliderOverlayShape(overlayRadius: 10),
                      ),
                      child: RangeSlider(
                        values: loopRange,
                        onChanged: _changeLoopRange,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
