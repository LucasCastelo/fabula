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
  bool _showKnobs = true;

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
    return Material(
      child: Stack(
        children: [
          Positioned.fill(
            bottom: 0,
            child: GestureDetector(
              onTap: () => setState(() => _showKnobs = false),
              child: ListenableBuilder(
                listenable: knobManager.rebuildExhibit,
                builder: (_, __) => widget.builder(knobManager),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left: _showKnobs ? MediaQuery.of(context).size.width * 0.8 : 0,
            top: MediaQuery.of(context).size.height / 2,
            child: GestureDetector(
              onTap: () => setState(() => _showKnobs = !_showKnobs),
              child: Container(
                width: 18,
                height: 28,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.horizontal(
                    right: Radius.circular(14),
                  ),
                ),
                child: const Icon(
                  Icons.chevron_right,
                  size: 16,
                ),
              ),
            ),
          ),
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            bottom: 0,
            top: 0,
            left: _showKnobs ? 0 : -MediaQuery.of(context).size.width * 0.8,
            width: MediaQuery.of(context).size.width * 0.8,
            child: ListenableBuilder(
              listenable: knobManager.rebuildKnobs,
              builder: (_, __) => Container(
                color: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView(
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
              ),
            ),
          )
        ],
      ),
    );
  }
}
