import 'package:flutter/material.dart';
import 'package:storyto/src/knob_manager.dart';

extension KnobManagerExtensions on KnobManager {
  List<Widget> viewKnobs() {
    return knobs.values
        .map(
          (e) => ListenableBuilder(
            listenable: e,
            builder: (context, __) => e.knob(),
          ),
        )
        .toList();
  }
}
