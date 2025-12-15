import 'package:flutter/material.dart';
import 'package:storyto/src/entities/knob.dart';
import 'package:storyto/src/knob_manager.dart';

class ListField<T> extends StatelessWidget {
  const ListField({
    super.key,
    required this.knob,
    required this.itemBuilder,
    required this.knobManager,
  });
  final KnobValue<List<T>> knob;
  final T Function(KnobManager) itemBuilder;
  final KnobManager knobManager;

  List<T> get items => knob.getValue();

  void _increaseLength() {
    final currentItems = List<T>.from(items);
    currentItems.add(itemBuilder(knobManager));
    knob.setValue(currentItems);
  }

  void _decreaseLength() {
    final currentItems = List<T>.from(items);
    currentItems.removeLast();
    knob.setValue(currentItems);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: _increaseLength,
          child: const Text('Increase'),
        ),
        GestureDetector(
          onTap: _decreaseLength,
          child: const Text('Decrease'),
        ),
      ],
    );
  }
}
