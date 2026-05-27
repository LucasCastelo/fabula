import 'package:flutter/painting.dart';

/// Parses a hex color string into a [Color], tolerating optional `#`, optional
/// whitespace, mixed case, and 3 / 6 / 8 character forms.
///
/// 3 chars → CSS shorthand, each digit doubled, alpha forced to FF.
/// 6 chars → RGB, alpha forced to FF.
/// 8 chars → AARRGGBB.
///
/// Returns `null` if the input doesn't match one of the accepted forms.
Color? tryParseHexColor(String input) {
  final cleaned =
      input.replaceAll(RegExp(r'\s'), '').replaceAll('#', '').toLowerCase();
  if (!RegExp(r'^[0-9a-f]+$').hasMatch(cleaned)) return null;

  final String full;
  switch (cleaned.length) {
    case 3:
      full = 'ff${cleaned.split('').map((c) => '$c$c').join()}';
    case 6:
      full = 'ff$cleaned';
    case 8:
      full = cleaned;
    default:
      return null;
  }
  final argb = int.tryParse(full, radix: 16);
  if (argb == null) return null;
  return Color(argb);
}

/// Formats a [Color] back to a canonical hex string. Returns 6 chars when the
/// alpha is fully opaque, 8 chars (AARRGGBB) otherwise.
String hexStringFor(Color color) {
  final argb = color.toARGB32();
  final alpha = (argb >> 24) & 0xff;
  final rgb = (argb & 0xffffff).toRadixString(16).padLeft(6, '0');
  if (alpha == 0xff) return rgb;
  return '${alpha.toRadixString(16).padLeft(2, '0')}$rgb';
}
