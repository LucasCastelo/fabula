import 'package:flutter/material.dart';
import 'package:storyto/src/helpers/knob_manager_extensions.dart';
import 'package:storyto/storyto.dart';
import 'package:storyto/src/widgets/knob_manager_provider.dart';

class ExhibitList extends StatelessWidget {
  const ExhibitList({super.key, required this.builder});

  final KnobBuilder builder;

  @override
  Widget build(BuildContext context) {
    return KnobManagerProvider(
      builder: (k) {
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            ListenableBuilder(
              listenable: k.rebuildExhibit,
              builder: (context, __) => builder(k),
            ),
            const SizedBox(
              height: 16,
            ),
            ListenableBuilder(
              listenable: k.rebuildKnobs,
              builder: (context, __) => Column(
                children: [
                  ...k.viewKnobs(),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
