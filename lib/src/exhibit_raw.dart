import 'package:flutter/material.dart';
import 'package:storyto/src/entities/knob.dart';
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
    this.overlayBuilder,
  });

  final KnobBuilder builder;
  final Widget Function(BuildContext context, List<KnobValue> knobs)?
      overlayBuilder;

  @override
  State<ExhibitRaw> createState() => _ExhibitRawState();
}

class _ExhibitRawState extends State<ExhibitRaw> {
  late final knobManager = KnobManager();

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
    final overlay = widget.overlayBuilder;
    return Material(
      child: Stack(
        children: [
          Positioned.fill(
            bottom: 0,
            child: ListenableBuilder(
              listenable: knobManager.rebuildExhibit,
              builder: (_, __) => widget.builder(knobManager),
            ),
          ),
          if (overlay != null)
            Positioned.fill(
              child: ListenableBuilder(
                listenable: knobManager.rebuildKnobs,
                builder: (context, __) {
                  return overlay(context, knobManager.knobs.values.toList());
                },
              ),
            ),
        ],
      ),
    );
  }
}
