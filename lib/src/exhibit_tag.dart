import 'package:flutter/material.dart';

class ExhibitTag {
  ExhibitTag({required String label, required this.color}) {
    _label = label.toLowerCase();
  }

  late final String _label;
  final Color color;

  String get label => _label;

  @override
  bool operator ==(Object other) {
    return other is ExhibitTag && other._label == _label;
  }

  @override
  int get hashCode => _label.hashCode;
}
