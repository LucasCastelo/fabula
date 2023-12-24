import 'package:storyto/src/storyto/knobs/nullable_bool_knob.dart';
import 'package:storyto/src/storyto/storyto.dart';

extension StorytoBoolBuilder on Storyto {
  bool inputBool(
    String id, {
    required bool initialValue,
  }) {
    final knob = value[id];

    if (knob != null && knob is NullableBoolKnob) {
      return knob.value!;
    } else {
      final newBoolKnob = NullableBoolKnob(
        initialValue: initialValue,
        isNullable: false,
      );

      return createKnob(id: id, knob: newBoolKnob)!;
    }
  }
}
