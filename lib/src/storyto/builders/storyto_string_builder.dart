import 'package:storyto/src/storyto/knobs_listenable.dart';

extension StorytoStringBuilder on KnobsListenable {
  String? nString(
    String id, {
    required String initialValue,
  }) =>
      customTextKnob(
        id,
        initialValue: initialValue,
        marshal: (e) => e,
      );

  String string(
    String id, {
    required String initialValue,
  }) =>
      customTextKnob(
        id,
        initialValue: initialValue,
        marshal: (e) => e,
        isNullable: false,
      )!;
}
