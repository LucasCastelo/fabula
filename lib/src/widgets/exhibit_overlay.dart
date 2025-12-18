import 'package:flutter/material.dart';
import 'package:storyto/src/entities/knob.dart';

// Improvements:
// Make this directional
// Better design
/// A full page overlay that hides knobs to avoid for example when the
/// exhibit is full screen.
class ExhibitOverlay extends StatefulWidget {
  const ExhibitOverlay({super.key, required this.knobs});

  final List<KnobValue> knobs;

  @override
  State<ExhibitOverlay> createState() => _ExhibitOverlayState();
}

class _ExhibitOverlayState extends State<ExhibitOverlay> {
  bool _showKnobs = false;
  late double _openButtonTopOffset = MediaQuery.of(context).size.height / 2;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedPositioned(
          duration: const Duration(milliseconds: 300),
          left: _showKnobs ? MediaQuery.of(context).size.width * 0.8 : 0,
          top: _openButtonTopOffset.clamp(
            10,
            MediaQuery.of(context).size.height - 50,
          ),
          child: GestureDetector(
            onTap: () => setState(() => _showKnobs = !_showKnobs),
            onVerticalDragUpdate: (details) =>
                setState(() => _openButtonTopOffset += details.delta.dy),
            child: Container(
              width: 18,
              height: 40,
              decoration: const BoxDecoration(
                color: Colors.lightBlue,
                borderRadius: BorderRadius.horizontal(
                  right: Radius.circular(20),
                ),
              ),
              child: Icon(
                _showKnobs ? Icons.chevron_left : Icons.chevron_right,
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
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(8),
              ),
            ),
            child: ListView(
              children: widget.knobs
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
        )
      ],
    );
  }
}
