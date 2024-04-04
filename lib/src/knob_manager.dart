import 'package:flutter/material.dart';
import 'package:storyto/src/fields/custom_text_field.dart';
import 'package:storyto/src/knob.dart';

class KnobManager extends ChangeNotifier {
  KnobManager();

  final Map<String, Knob> knobs = {};

  String? nString(String id) {
    if (knobs.keys.contains(id)) {
      return knobs[id]?.value as String;
    } else {
      final newKnob = NullableKnob(
        defaultValue: 'asdaa',
        startAsNull: false,
        inputBuilder: <String>(setValue, toggleNull) => Row(
          children: [
            Expanded(
              child: CustomTextField(
                controller: TextEditingController(),
                onChanged: (v) => setValue(v as String),
              ),
            ),
            Container(
              color: Colors.red,
              child: GestureDetector(
                onTap: toggleNull,
                child: const Text(
                  "NULL",
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            )
          ],
        ),
      );

      knobs[id] = newKnob;

      return newKnob.value;
    }
  }
}

// final k = const KnobManager();
