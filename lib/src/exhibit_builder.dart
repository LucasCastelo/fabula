import 'package:flutter/material.dart';
import 'package:storyto/src/knob_manager.dart';
import 'package:storyto/src/widgets/exhibit_tag_pill.dart';
import 'package:storyto/storyto.dart';

typedef KnobBuilder = Widget Function(KnobManager);
typedef CustomButtonBuilder = Widget Function(String label, List<Widget> tags);

class ExhibitBuilder extends StatelessWidget {
  const ExhibitBuilder({
    super.key,
    required this.builder,
    required this.label,
    this.tags = const [],
    this.buttonBuilder,
  });

  final String label;
  final KnobBuilder builder;
  final List<ExhibitTag> tags;
  final CustomButtonBuilder? buttonBuilder;

  @override
  Widget build(BuildContext context) {
    final galleryState = ExhibitGalleryState.of(context);
    galleryState?.addTagToHolster(this.tags);
    final tags = this
        .tags
        .map(
          (e) => ExhibitTagPill(
            tag: e,
            colored: galleryState?.shouldTagGreyOut(e) ?? false,
            onTap: () => galleryState?.toggleTag(e),
          ),
        )
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
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: Colors.black12)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),
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
