import 'package:storyto/src/storyto/knobs/list_knob.dart';
import 'package:storyto/src/storyto/knobs_listenable.dart';

extension StorytoListBuilder on KnobsListenable {
  List<T> list<T>(
    String id, {
    required T Function(KnobsListenable, int) builder,
  }) {
    final knob = value[id];

    if (knob != null && knob is NullableListKnob<T>) {
      return knob.value!;
    } else {
      final customTextKnob = NullableListKnob<T>(
        isNullable: false,
        builder: builder,
        storyto: this,
      );

      createKnob(id: id, knob: customTextKnob);
      return customTextKnob.value!;
    }
  }
}
