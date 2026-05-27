import 'package:flutter/material.dart';
import 'package:fabula/src/widgets/general/touch.dart';

// TODO: Improve on design
// TODO: Create color library that allows to manage available colors 'globally'
class PredefinedColorsEntryPoint extends StatelessWidget {
  const PredefinedColorsEntryPoint({
    super.key,
    required this.colors,
    required this.onColorSelected,
  });

  final List<Color> colors;
  final ValueSetter<Color> onColorSelected;

  void showOverlay(BuildContext context) {
    showDialog(
      context: context,
      fullscreenDialog: false,
      barrierColor: Colors.transparent,
      builder: (context) => Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.all(16),
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.5,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.black12),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                spreadRadius: 4,
                offset: Offset(0, 10),
              ),
            ],
          ),
          child: ListView(
            shrinkWrap: true,
            children: [
              const Text(
                'Predefined Colors',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              ...colors
                  .map((color) => _PredefinedColorItem(
                        color: color,
                        onColorSelected: onColorSelected,
                      ))
                  .toList()
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Touch(
      semanticsLabel: 'Predefined colors',
      onTap: () => showOverlay(context),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        child: Text(
          'Predefined Colors',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

class _PredefinedColorItem extends StatelessWidget {
  const _PredefinedColorItem({
    required this.color,
    required this.onColorSelected,
  });

  final Color color;
  final ValueSetter<Color> onColorSelected;

  @override
  Widget build(BuildContext context) {
    return Touch(
      onTap: () => onColorSelected(color),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            color: color,
          ),
          const SizedBox(width: 8),
          Text(color.toARGB32().toRadixString(16).replaceRange(0, 2, '')),
        ],
      ),
    );
  }
}
