import 'package:flutter/material.dart';
import 'package:fabula/src/entities/color_holster.dart';
import 'package:fabula/src/helpers/hex_color.dart';
import 'package:fabula/src/widgets/general/touch.dart';

/// Entry button that opens a searchable, grouped picker over a list of
/// [ColorHolster]s.
class ColorHolsterPicker extends StatelessWidget {
  const ColorHolsterPicker({
    super.key,
    required this.holsters,
    required this.onColorSelected,
  });

  final List<ColorHolster> holsters;
  final ValueSetter<Color> onColorSelected;

  void _open(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withAlpha(40),
      builder: (_) => _PickerDialog(
        holsters: holsters,
        onColorSelected: onColorSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Touch(
      semanticsLabel: 'Open color palette',
      onTap: () => _open(context),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.palette_outlined, size: 14, color: Colors.black54),
            SizedBox(width: 4),
            Text(
              'Palette',
              style: TextStyle(fontSize: 12, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }
}

class _PickerDialog extends StatefulWidget {
  const _PickerDialog({
    required this.holsters,
    required this.onColorSelected,
  });

  final List<ColorHolster> holsters;
  final ValueSetter<Color> onColorSelected;

  @override
  State<_PickerDialog> createState() => _PickerDialogState();
}

class _PickerDialogState extends State<_PickerDialog> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  bool _matches(PaletteColor p) {
    if (_query.isEmpty) return true;
    if (p.label.toLowerCase().contains(_query)) return true;
    final hex = hexStringFor(p.color);
    return hex.contains(_query);
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final filtered = [
      for (final holster in widget.holsters)
        (
          holster,
          holster.properties.where(_matches).toList(),
        ),
    ].where((entry) => entry.$2.isNotEmpty).toList();

    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 64),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: size.height * 0.7, maxWidth: 420),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  const Icon(Icons.palette_outlined,
                      size: 18, color: Colors.black87),
                  const SizedBox(width: 8),
                  const Text(
                    'Palette',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  Touch(
                    semanticsLabel: 'Close palette',
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.close,
                      size: 18,
                      color: Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                style: const TextStyle(fontSize: 13),
                decoration: InputDecoration(
                  hintText: 'Search colors',
                  hintStyle: const TextStyle(fontSize: 13, color: Colors.black38),
                  prefixIcon:
                      const Icon(Icons.search, size: 16, color: Colors.black54),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 32,
                    minHeight: 32,
                  ),
                  isDense: true,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide:
                        const BorderSide(color: Colors.black12, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide:
                        const BorderSide(color: Colors.black12, width: 1),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide:
                        const BorderSide(color: Colors.black54, width: 1.2),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Flexible(
              child: filtered.isEmpty
                  ? const Padding(
                      padding: EdgeInsets.all(32),
                      child: Center(
                        child: Text(
                          'No colors match.',
                          style:
                              TextStyle(fontSize: 12, color: Colors.black54),
                        ),
                      ),
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      children: [
                        for (final (holster, properties) in filtered)
                          _Section(
                            label: holster.label,
                            properties: properties,
                            onColorSelected: (c) {
                              widget.onColorSelected(c);
                              Navigator.of(context).pop();
                            },
                          ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({
    required this.label,
    required this.properties,
    required this.onColorSelected,
  });

  final String label;
  final List<PaletteColor> properties;
  final ValueSetter<Color> onColorSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 12, bottom: 6),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
              letterSpacing: 0.3,
            ),
          ),
        ),
        for (final p in properties)
          Touch(
            semanticsLabel: 'Select ${p.label}',
            onTap: () => onColorSelected(p.color),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: p.color,
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(color: Colors.black12),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      p.label,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                  Text(
                    hexStringFor(p.color),
                    style: const TextStyle(
                      fontFamily: 'monospace',
                      fontSize: 11,
                      color: Colors.black38,
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
