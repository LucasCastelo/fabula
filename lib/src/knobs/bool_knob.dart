import 'package:storyto/src/fields/bool_field.dart';
import 'package:storyto/src/knobs/knob.dart';

class BoolKnob extends DefaultKnob<bool> {
  BoolKnob({
    required String label,
    required super.initialValue,
  }) : super(
          inputBuilder: (knob) => BoolField(
            label: label,
            value: knob.getValue(),
            onChanged: (v) {
              knob.setValue(v);
            },
          ),
        );
}
