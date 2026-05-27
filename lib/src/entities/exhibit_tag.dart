import 'package:flutter/material.dart';

class ExhibitTag {
  ExhibitTag({required String label, this.color = Colors.lightBlueAccent}) {
    _label = label.toLowerCase();
  }

  late final String _label;
  final Color color;

  String get label => _label;

  @override
  bool operator ==(Object other) {
    return other is ExhibitTag &&
        other._label == _label &&
        other.color == color;
  }

  @override
  int get hashCode => Object.hash(_label, color);
}
