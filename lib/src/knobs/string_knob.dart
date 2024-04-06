import 'package:storyto/src/fields/custom_text_field.dart';
import 'package:storyto/src/knobs/knob.dart';

class StringKnob extends DefaultKnob {
  StringKnob({
    required super.initialValue,
  }) : super(inputBuilder: (knob) => KnobTextField(knob: knob));
}
