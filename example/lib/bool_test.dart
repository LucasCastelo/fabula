import 'package:example/sections_test.dart';
import 'package:flutter/material.dart';
import 'package:storyto/storyto.dart';

class BoolTest extends StatelessWidget {
  const BoolTest({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionTest(
      title: 'Bool',
      children: [
        ExhibitBuilder(builder: (e) {
          return _BoolExhibig(
            value: e.inputBool(
              'id',
              initialValue: true,
            ),
          );
        })
      ],
    );
  }
}

class _BoolExhibig extends StatelessWidget {
  const _BoolExhibig({required this.value});

  final bool value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 40,
      color: value ? Colors.greenAccent : Colors.redAccent,
    );
  }
}
