import 'package:flutter/material.dart';
import 'package:fabula/src/widgets/knob_manager_provider.dart';
import 'package:fabula/fabula.dart';

enum ExhibitPageKnobPosition {
  inPage,
  inDrawer,
}

class ExhibitRaw extends StatelessWidget {
  const ExhibitRaw({
    super.key,
    required this.builder,
    this.overlayBuilder,
  });

  final KnobBuilder builder;
  final Widget Function(BuildContext context, List<Knob> knobs)?
      overlayBuilder;

  @override
  Widget build(BuildContext context) {
    final overlay = overlayBuilder;
    return KnobManagerProvider(builder: (context, k) {
      return Material(
        child: Stack(
          children: [
            Positioned.fill(
              bottom: 0,
              child: ListenableBuilder(
                listenable: k,
                builder: (context, _) => ListenableBuilder(
                  listenable: Listenable.merge(k.knobs.values),
                  builder: (context, __) => builder(context, k),
                ),
              ),
            ),
            if (overlay != null)
              Positioned.fill(
                child: ListenableBuilder(
                  listenable: k,
                  builder: (context, _) =>
                      overlay(context, k.knobs.values.toList()),
                ),
              ),
          ],
        ),
      );
    });
  }
}
