import 'package:flutter/painting.dart';

/// A named color within a [ColorHolster].
class PaletteColor {
  const PaletteColor({required this.label, required this.color});

  final String label;
  final Color color;
}

/// A semantically grouped collection of [PaletteColor]s.
///
/// Use to organize a color palette by intent — e.g. brand colors, status colors,
/// product variants. Surfaced as a labeled section in the color picker menu.
class ColorHolster {
  const ColorHolster({required this.label, required this.properties});

  final String label;
  final List<PaletteColor> properties;
}
