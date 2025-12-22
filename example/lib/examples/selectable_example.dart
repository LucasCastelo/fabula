import 'package:flutter/material.dart';

class Food {
  Food({required this.name});

  final String name;
}

enum Restaurant {
  elPolloLoco,
  tacoBell,
  chipotle,
  pizzaHut,
  burgerKing,
  kfc,
  mcdonalds,
  subway,
  wendys,
  jackInTheBox,
  sonic,
  inNOut,
  culvers,
}

class SelectableExample extends StatelessWidget {
  const SelectableExample({
    super.key,
    required this.food,
    required this.restaurant,
  });

  final Food food;
  final Restaurant? restaurant;

  @override
  Widget build(BuildContext context) {
    return restaurant == null
        ? Text(
            'I didnt found a place to eat ${food.name}',
            style: const TextStyle(fontSize: 20, color: Colors.black),
            textAlign: TextAlign.center,
          )
        : Text(
            'I ate ${food.name} at ${restaurant!.name}',
            style: const TextStyle(fontSize: 20, color: Colors.black),
            textAlign: TextAlign.center,
          );
  }
}
