import 'package:flutter/material.dart';

class StringExample extends StatelessWidget {
  const StringExample({
    super.key,
    required this.place,
    required this.car,
  });

  final String place;
  final String? car;

  @override
  Widget build(BuildContext context) {
    return Text(
      car == null
          ? 'I couldnt go to $place because I dont have a car'
          : 'I went to $place in my $car',
      style: const TextStyle(fontSize: 20, color: Colors.black),
      textAlign: TextAlign.center,
    );
  }
}
