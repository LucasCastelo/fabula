import 'package:flutter/material.dart';
import 'package:storyto/src/storyto/storyto.dart';

class StorytoProvider extends StatelessWidget {
  StorytoProvider({
    super.key,
    required this.child,
  });

  final Storyto storyto = Storyto();
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return child;
  }
}
