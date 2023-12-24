import 'package:storyto/src/storyto/storyto.dart';

extension StorytoStringBuilder on Storyto {
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
