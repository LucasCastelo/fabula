import 'package:flutter/widgets.dart';

/// A device the wide layout can simulate when previewing an exhibit.
class ExhibitDevice {
  const ExhibitDevice({
    required this.name,
    required this.size,
  });

  final String name;

  /// Logical size in portrait orientation.
  final Size size;

  static const presets = [
    ExhibitDevice(name: 'iPhone SE', size: Size(375, 667)),
    ExhibitDevice(name: 'iPhone 15', size: Size(393, 852)),
    ExhibitDevice(name: 'iPhone 15 Pro Max', size: Size(430, 932)),
    ExhibitDevice(name: 'Pixel 7', size: Size(412, 915)),
    ExhibitDevice(name: 'Galaxy S20', size: Size(360, 800)),
    ExhibitDevice(name: 'iPad mini', size: Size(744, 1133)),
  ];
}
