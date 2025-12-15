import 'package:flutter/material.dart';
import 'package:storyto/src/knob_manager.dart';
import 'package:storyto/storyto.dart';

class ExhibitPage extends StatefulWidget {
  const ExhibitPage({
    super.key,
    required this.builder,
  });

  final KnobBuilder builder;

  @override
  State<ExhibitPage> createState() => _ExhibitPageState();
}

class _ExhibitPageState extends State<ExhibitPage> {
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
    return Scaffold(
      body: SafeArea(
        child: Column(
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
        ),
      ),
    );
  }
}
