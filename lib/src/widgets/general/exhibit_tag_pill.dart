import 'package:flutter/material.dart';
import 'package:fabula/fabula.dart';

class ExhibitTagPill extends StatelessWidget {
  const ExhibitTagPill({
    super.key,
    required this.tag,
    required this.colored,
    required this.onTap,
  });

  final ExhibitTag tag;
  final bool colored;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Touch(
      semanticsLabel: tag.label,
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.fromLTRB(8, 2, 8, 4),
        decoration: BoxDecoration(
          color: (colored ? tag.color : Colors.grey)
              .withAlpha((255 * 0.2).toInt()),
          borderRadius: BorderRadius.circular(800),
        ),
        child: Text(
          tag.label.toLowerCase(),
          style: TextStyle(
            fontSize: 10,
            color: colored ? tag.color : Colors.grey,
          ),
        ),
      ),
    );
  }
}
