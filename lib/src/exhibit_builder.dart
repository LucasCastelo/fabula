import 'package:flutter/material.dart';
import 'package:storyto/src/storyto/storyto.dart';

typedef ExhibitBuilderCallback = Widget Function(Storyto e);

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
  final storyto = Storyto();
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
