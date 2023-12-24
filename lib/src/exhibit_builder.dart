import 'package:flutter/material.dart';
import 'package:storyto/src/storyto/knobs_listenable.dart';

typedef ExhibitBuilderCallback = Widget Function(KnobsListenable e);

class ExhibitBuilder extends StatefulWidget {
  const ExhibitBuilder({
    super.key,
    required this.builder,
  });

  final ExhibitBuilderCallback builder;

  @override
  State<ExhibitBuilder> createState() => _ExhibitBuilderState();
}

class _ExhibitBuilderState extends State<ExhibitBuilder> {
  final storyto = KnobsListenable();
  List<Widget> inputs = [];

  @override
  void initState() {
    storyto.addListener(updateFields);
    updateFields();
    super.initState();
  }

  @override
  void dispose() {
    storyto.removeListener(updateFields);
    storyto.dispose();
    super.dispose();
  }

  void updateFields() {
    setState(() {
      inputs = storyto.knobs.map((e) => e.knob()).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        widget.builder(storyto),
        ...inputs,
      ],
    );
  }
}
