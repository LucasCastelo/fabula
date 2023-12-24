import 'package:example/sections_test.dart';
import 'package:flutter/material.dart';
import 'package:storyto/storyto.dart';

class ListTest extends StatelessWidget {
  const ListTest({super.key});

  @override
  Widget build(BuildContext context) {
    return SectionTest(
      title: 'List',
      children: [
        ExhibitBuilder(
          builder: (e) => Column(
            mainAxisSize: MainAxisSize.min,
            children: e.list(
              'id',
              builder: (_, index) => Container(),
            ),
          ),
        )
      ],
    );
  }
}
