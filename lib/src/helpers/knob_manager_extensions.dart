import 'package:flutter/material.dart';
import 'package:fabula/src/knob_manager.dart';

extension KnobManagerExtensions on KnobManager {
  List<Widget> viewKnobs() {
    final widgets = <Widget>[];
    for (final entry in knobsBySection.entries) {
      final knobWidgets = [
        for (final knob in entry.value)
          ListenableBuilder(
            listenable: knob,
            builder: (context, __) => knob.knob(),
          ),
      ];

      if (entry.key.isEmpty) {
        widgets.addAll(knobWidgets);
      } else {
        widgets.add(
          _SectionView(
            key: ValueKey('section-${entry.key}'),
            title: entry.key,
            children: knobWidgets,
          ),
        );
      }
    }
    return widgets;
  }
}

class _SectionView extends StatefulWidget {
  const _SectionView({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  State<_SectionView> createState() => _SectionViewState();
}

class _SectionViewState extends State<_SectionView> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        InkWell(
          onTap: () => setState(() => _expanded = !_expanded),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: [
                AnimatedRotation(
                  turns: _expanded ? 0 : -0.25,
                  duration: const Duration(milliseconds: 150),
                  child: const Icon(
                    Icons.expand_more,
                    size: 22,
                    color: Colors.black54,
                  ),
                ),
                const SizedBox(width: 4),
                Expanded(
                  child: Text(
                    widget.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      letterSpacing: 0.3,
                      color: Colors.black87,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withAlpha(20),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${widget.children.length}',
                    style: const TextStyle(
                      fontSize: 11,
                      color: Colors.black54,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        ClipRect(
          child: AnimatedAlign(
            alignment: Alignment.topCenter,
            heightFactor: _expanded ? 1 : 0,
            duration: const Duration(milliseconds: 150),
            curve: Curves.easeInOut,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                for (var i = 0; i < widget.children.length; i++) ...[
                  widget.children[i],
                  if (i < widget.children.length - 1)
                    const SizedBox(height: 8),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
