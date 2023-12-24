import 'package:storyto/src/storyto/storyto.dart';

extension StorytoIntBuilder on Storyto {
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
