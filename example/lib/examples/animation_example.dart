import 'package:flutter/material.dart';

class AnimationExample extends StatelessWidget {
  const AnimationExample({
    super.key,
    required this.controller,
    required this.color,
  });

  final AnimationController controller;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, child) => Container(
        color: color.withAlpha((255 * controller.value).toInt()),
        height: 100,
        width: 100,
      ),
    );
  }
}
