import 'package:flutter/material.dart';

class ExhibitTag {
  const ExhibitTag({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  bool operator ==(Object other) {
    return other is ExhibitTag && other.label == label;
  }

  @override
  int get hashCode => label.hashCode ^ color.hashCode;
}
