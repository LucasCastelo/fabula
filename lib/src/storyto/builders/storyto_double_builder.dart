import 'package:storyto/src/storyto/storyto.dart';

extension StorytoDoubleBuilder on Storyto {
  double inputDouble(
    String id, {
    required double initialValue,
  }) =>
      customTextKnob(
        id,
        initialValue: initialValue,
        marshal: (e) => double.tryParse(e) ?? 0,
        isNullable: false,
      )!;

  double? nInputDouble(
    String id, {
    required double initialValue,
  }) =>
      customTextKnob(
        id,
        initialValue: initialValue,
        marshal: (e) => double.tryParse(e) ?? 0,
        isNullable: true,
      );
}
