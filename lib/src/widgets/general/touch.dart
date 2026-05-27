import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Tappable wrapper with a press-scale animation and no ripple.
///
/// Use in place of [GestureDetector] for anything conceptually a button.
/// Provides:
///   * Animated scale-down on press (no ink splash).
///   * `Semantics(button: true)` for screen readers.
///   * Keyboard activation via Enter / Space when focused.
class Touch extends StatefulWidget {
  const Touch({
    super.key,
    required this.onTap,
    required this.child,
    this.pressedScale = 0.95,
    this.duration = const Duration(milliseconds: 100),
    this.semanticsLabel,
  });

  final VoidCallback? onTap;
  final Widget child;
  final double pressedScale;
  final Duration duration;
  final String? semanticsLabel;

  @override
  State<Touch> createState() => _TouchState();
}

class _TouchState extends State<Touch> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  void _activateFromKeyboard() {
    _setPressed(true);
    Future.delayed(widget.duration, () {
      if (mounted) _setPressed(false);
    });
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onTap != null;
    return Semantics(
      button: true,
      enabled: enabled,
      label: widget.semanticsLabel,
      child: FocusableActionDetector(
        enabled: enabled,
        mouseCursor:
            enabled ? SystemMouseCursors.click : MouseCursor.defer,
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
        },
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<Intent>(
            onInvoke: (_) {
              _activateFromKeyboard();
              return null;
            },
          ),
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: enabled ? (_) => _setPressed(true) : null,
          onTapUp: enabled ? (_) => _setPressed(false) : null,
          onTapCancel: enabled ? () => _setPressed(false) : null,
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: _pressed ? widget.pressedScale : 1.0,
            duration: widget.duration,
            curve: Curves.easeOut,
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
