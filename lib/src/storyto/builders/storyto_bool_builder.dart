import 'package:storyto/src/storyto/knobs/bool_knob.dart';
import 'package:storyto/src/storyto/knobs_listenable.dart';

extension StorytoBoolBuilder on KnobsListenable {
  bool inputBool(
    String id, {
    required bool initialValue,
  }) {
    final knob = value[id];

    if (knob != null && knob is BoolKnob) {
      return knob.value!;
    } else {
      final newBoolKnob = BoolKnob(
        initialValue: initialValue,
        isNullable: false,
      );

      return createKnob(id: id, knob: newBoolKnob)!;
    }
  }
}
