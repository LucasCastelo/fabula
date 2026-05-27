import 'package:flutter/material.dart';
import 'package:fabula/src/helpers/iterator_separate.dart';
import 'package:fabula/src/helpers/knob_manager_extensions.dart';
import 'package:fabula/fabula.dart';
import 'package:fabula/src/widgets/knob_manager_provider.dart';

class ExhibitList extends StatelessWidget {
  const ExhibitList({super.key, required this.builder});

  final KnobBuilder builder;

  @override
  Widget build(BuildContext context) {
    return KnobManagerProvider(
      builder: (context, k) {
        return ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            ListenableBuilder(
              listenable: k,
              builder: (context, _) => ListenableBuilder(
                listenable: Listenable.merge(k.knobs.values),
                builder: (context, __) => builder(context, k),
              ),
            ),
            const SizedBox(height: 16),
            ListenableBuilder(
              listenable: k,
              builder: (context, _) => Column(
                children: k
                    .viewKnobs()
                    .separate(const SizedBox(height: 16))
                    .toList(),
              ),
            ),
          ],
        );
      },
    );
  }
}
