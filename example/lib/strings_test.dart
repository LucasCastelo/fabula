import 'package:example/sections_test.dart';
import 'package:flutter/material.dart';
import 'package:storyto/storyto.dart';

class StringsTest extends StatelessWidget {
  const StringsTest({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionTest(
      title: 'Strings',
      children: [
        ExhibitBuilder(
          builder: (e) => Text(
            e.string('id', initialValue: 'field-1'),
          ),
        ),
        ExhibitBuilder(
          builder: (e) => _NullableStringTest(
            text: e.nString('id-2', initialValue: 'field-2'),
          ),
        ),
      ],
    );
  }
}

class _NullableStringTest extends StatelessWidget {
  const _NullableStringTest({required this.text});

  final String? text;
  @override
  Widget build(BuildContext context) {
    return text == null ? const Text('Null') : Text(text!);
  }
}
