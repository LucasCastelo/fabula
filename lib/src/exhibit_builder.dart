import 'package:flutter/material.dart';
import 'package:storyto/src/knob_manager.dart';

typedef CustomBuilder = Widget Function(KnobManager);

class ExhibitBuilder extends StatefulWidget {
  const ExhibitBuilder({
    super.key,
    required this.builder,
  });

  final CustomBuilder builder;

  @override
  State<ExhibitBuilder> createState() => _ExhibitBuilderState();
}

class _ExhibitBuilderState extends State<ExhibitBuilder> {
  final km = KnobManager();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.builder(km),
        ...km.knobs.values.map(
          (e) => e.knob(),
        )
      ],
    );
  }
}
