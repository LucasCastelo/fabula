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
  final knobManager = KnobManager();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    knobManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ListenableBuilder(
          listenable: knobManager.rebuildExhibit,
          builder: (_, __) => widget.builder(knobManager),
        ),
        ListenableBuilder(
          listenable: knobManager.rebuildKnobs,
          builder: (_, __) => Column(
            children: knobManager.knobs.values
                .map(
                  (e) => ListenableBuilder(
                    listenable: e,
                    builder: (_, __) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: e.knob(),
                    ),
                  ),
                )
                .toList(),
          ),
        )
      ],
    );
  }
}
