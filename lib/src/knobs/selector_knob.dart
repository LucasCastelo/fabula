import 'package:storyto/src/fields/selector_field.dart';
import 'package:storyto/src/knobs/knob.dart';
import 'package:storyto/src/knobs/n_selector_knob.dart';

class SelectorKnob<T> extends DefaultKnob<T> {
  SelectorKnob({
    required super.initialValue,
    required SelectorNameMarshal<T> nameMarshal,
    required List<T> values,
  }) : super(
          inputBuilder: (knob) => SelectorField<T>(
            knob: knob,
            options: values,
            nameMarshal: nameMarshal,
          ),
        );
}
