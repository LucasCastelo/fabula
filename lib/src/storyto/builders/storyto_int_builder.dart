import 'package:storyto/src/storyto/knobs_listenable.dart';

extension StorytoIntBuilder on KnobsListenable {
  int inputInt(
    String id, {
    required int initialValue,
  }) =>
      customTextKnob(
        id,
        initialValue: initialValue,
        marshal: (e) => int.tryParse(e) ?? 0,
        isNullable: false,
      )!;

  int? nInputInt(
    String id, {
    required int initialValue,
  }) =>
      customTextKnob(
        id,
        initialValue: initialValue,
        marshal: (e) => int.tryParse(e) ?? 0,
        isNullable: true,
      );
}
