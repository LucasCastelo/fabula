import 'package:example/sections_test.dart';
import 'package:flutter/material.dart';
import 'package:storyto/storyto.dart';

class IntTest extends StatelessWidget {
  const IntTest({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionTest(
      title: 'Int',
      children: [
        ExhibitBuilder(
          builder: (e) {
            final v = e.inputInt('id', initialValue: 1);
            return Text(
              '10 + $v = ${v + 10}',
            );
          },
        ),
        ExhibitBuilder(
          builder: (e) {
            final v = e.nInputInt('id', initialValue: 1);
            return Text(
              '10 + ${v ?? 'Null'} = ${v ?? 0 + 10}',
            );
          },
        ),
      ],
    );
  }
}
