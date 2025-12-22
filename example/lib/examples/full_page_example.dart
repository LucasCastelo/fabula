import 'dart:math';

import 'package:flutter/material.dart';

class FullPageExample extends StatelessWidget {
  const FullPageExample({
    super.key,
    required this.title,
    required this.description,
    required this.color,
    required this.gradientColors,
    required this.animationController,
  });

  final String title;
  final String description;
  final Color color;
  final List<Color> gradientColors;
  final AnimationController animationController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Page Example'),
      ),
      backgroundColor: color,
      body: ListView(
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            description,
            style: const TextStyle(fontSize: 16),
          ),
          AnimatedBuilder(
            animation: animationController,
            builder: (context, child) => Transform.rotate(
              angle: animationController.value * 2 * pi,
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: gradientColors,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
