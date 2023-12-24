import 'package:example/sections_test.dart';
import 'package:flutter/material.dart';
import 'package:storyto/storyto.dart';

class DoubleTest extends StatelessWidget {
  const DoubleTest({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionTest(
      title: 'Double',
      children: [
        ExhibitBuilder(
          builder: (e) {
            final v = e.inputDouble('id', initialValue: 0.1);
            return Text(
              '0.6 + $v = ${v + 0.6}',
            );
          },
        ),
        ExhibitBuilder(
          builder: (e) {
            final v = e.nInputDouble('id', initialValue: 0.2);
            return Text(
              '0.1 + ${v ?? 'Null'} = ${(v ?? 0) + 0.1}',
            );
          },
        ),
      ],
    );
  }
}
