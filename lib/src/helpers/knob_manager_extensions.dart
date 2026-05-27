import 'package:flutter/material.dart';
import 'package:fabula/src/knob_manager.dart';

extension KnobManagerExtensions on KnobManager {
  List<Widget> viewKnobs() {
    final widgets = <Widget>[];
    for (final entry in knobsBySection.entries) {
      if (entry.key.isNotEmpty) {
        widgets.add(
          Row(
            children: [
              const Icon(Icons.arrow_drop_down),
              const SizedBox(width: 8),
              Text(entry.key),
            ],
          ),
        );
      }
      for (final knob in entry.value) {
        widgets.add(
          ListenableBuilder(
            listenable: knob,
            builder: (context, __) => knob.knob(),
          ),
        );
      }
    }
    return widgets;
  }
}
