import 'package:flutter/material.dart';
import 'package:storyto/src/knob_manager.dart';
import 'package:storyto/storyto.dart';

typedef KnobBuilder = Widget Function(KnobManager);
typedef CustomButtonBuilder = Widget Function(String label, List<Widget> tags);

class KnobTag {
  const KnobTag({required this.label, required this.color});

  final String label;
  final Color color;
}

class ExhibitBuilder2 extends StatelessWidget {
  const ExhibitBuilder2({
    super.key,
    required this.builder,
    required this.label,
    this.tags = const [],
    this.buttonBuilder,
  });

  final String label;
  final KnobBuilder builder;
  final List<KnobTag> tags;
  final CustomButtonBuilder? buttonBuilder;

  @override
  Widget build(BuildContext context) {
    final tags = this
        .tags
        .map((e) => _ExhibitTag(label: e.label.toLowerCase(), color: e.color))
        .toList();

    return buttonBuilder?.call(label, tags) ??
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ExhibitPage(
                  builder: builder,
                ),
              ),
            );
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(width: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 4,
                  runSpacing: 4,
                  alignment: WrapAlignment.start,
                  children: tags,
                ),
                const SizedBox(height: 18),
              ],
            ),
          ),
        );
  }
}

class _ExhibitTag extends StatelessWidget {
  const _ExhibitTag({required this.label, required this.color});

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha((255 * 0.2).toInt()),
        borderRadius: BorderRadius.circular(800),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          color: color,
        ),
      ),
    );
  }
}
