import 'package:flutter/material.dart';
import 'package:storyto/src/knob_manager.dart';
import 'package:storyto/storyto.dart';

enum ExhibitPageKnobPosition {
  inPage,
  inDrawer,
}

class ExhibitRaw extends StatefulWidget {
  const ExhibitRaw({
    super.key,
    required this.builder,
  });

  final KnobBuilder builder;

  @override
  State<ExhibitRaw> createState() => _ExhibitRawState();
}

class _ExhibitRawState extends State<ExhibitRaw> {
  late final knobManager = KnobManager();

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
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                      ),
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
