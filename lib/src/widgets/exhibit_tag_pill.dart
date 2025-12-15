import 'package:flutter/material.dart';
import 'package:storyto/storyto.dart';

class ExhibitTagPill extends StatefulWidget {
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
  State<ExhibitTagPill> createState() => _ExhibitTagPillState();
}

class _ExhibitTagPillState extends State<ExhibitTagPill> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
        decoration: BoxDecoration(
          color: (widget.colored ? widget.tag.color : Colors.grey)
              .withAlpha((255 * 0.2).toInt()),
          borderRadius: BorderRadius.circular(800),
        ),
        child: Text(
          widget.tag.label.toLowerCase(),
          style: TextStyle(
            fontSize: 10,
            color: widget.colored ? widget.tag.color : Colors.grey,
          ),
        ),
      ),
    );
  }
}
