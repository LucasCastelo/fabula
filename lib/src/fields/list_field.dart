import 'package:flutter/material.dart';
import 'package:fabula/src/entities/knob.dart';

typedef ListItemBuilder<T> = T Function(String prefixId);

class ListField<T> extends StatelessWidget {
  const ListField({
    super.key,
    required this.listId,
    required this.knob,
    required this.itemBuilder,
    required this.onFieldCreated,
    required this.onFieldDisposed,
  });

  final String listId;
  final KnobValue<List<T>> knob;
  final ListItemBuilder itemBuilder;
  final Function(String prefix) onFieldCreated;
  final Function(String prefix) onFieldDisposed;

  List<T> get items => knob.getValue();

  void _increaseLength() {
    final currentItems = List<T>.from(items);
    final prefix = '$listId-${items.length + 1}';
    currentItems.add(itemBuilder(prefix));
    knob.setValue(currentItems);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      onFieldCreated(prefix);
    });
  }

  void _decreaseLength() {
    final currentItems = List<T>.from(items);
    currentItems.removeLast();
    knob.setValue(currentItems);
    onFieldDisposed('$listId-${items.length + 1}');
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
