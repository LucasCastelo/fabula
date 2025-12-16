import 'package:flutter/material.dart';
import 'package:storyto/src/knob_manager.dart';
import 'package:storyto/src/widgets/exhibit_tag_pill.dart';
import 'package:storyto/storyto.dart';

typedef KnobBuilder = Widget Function(KnobManager);
typedef CustomButtonBuilder = Widget Function(String label, List<Widget> tags);

enum ExhibitEntryType {
  page,
  bottomSheet,
  popupMenu,
}

class ExhibitBuilder extends StatefulWidget {
  const ExhibitBuilder({
    super.key,
    required this.builder,
    required this.label,
    this.entryType = ExhibitEntryType.page,
    this.tags = const [],
    this.buttonBuilder,
  });

  final String label;
  final KnobBuilder builder;
  final List<ExhibitTag> tags;
  final CustomButtonBuilder? buttonBuilder;
  final ExhibitEntryType entryType;

  @override
  State<ExhibitBuilder> createState() => _ExhibitBuilderState();
}

class _ExhibitBuilderState extends State<ExhibitBuilder> {
  late final galleryState = ExhibitGalleryState.of(context);
  bool shouldShow = true;
  KnobManager? knobManager;

  @override
  void initState() {
    super.initState();
    galleryState?.addTagToHolster(widget.tags);
    galleryState?.addListener(() => setState(() {
          shouldShow = galleryState?.shouldShow(widget.tags) ?? true;
        }));
  }

  @override
  void dispose() {
    galleryState?.removeListener(() => setState(() {}));
    knobManager?.dispose();
    super.dispose();
  }

  Future<void> onTap() async {
    knobManager ??= KnobManager();

    await switch (widget.entryType) {
      ExhibitEntryType.page => await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ExhibitPage(builder: widget.builder, knobManager: knobManager!),
          ),
        ),
      ExhibitEntryType.bottomSheet => await showModalBottomSheet(
          // ignore: use_build_context_synchronously
          context: context,
          builder: (context) => ExhibitPage(
            builder: widget.builder,
            knobManager: knobManager!,
          ),
        ),
      ExhibitEntryType.popupMenu => await Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(
            builder: (context) => ExhibitPage(
              builder: widget.builder,
              knobManager: knobManager!,
              knobPosition: ExhibitPageKnobPosition.inDrawer,
            ),
          ),
        ),
    };

    knobManager?.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pillTags = widget.tags
        .map(
          (e) => ExhibitTagPill(
            tag: e,
            colored: galleryState?.shouldShow([e]) ?? false,
            onTap: () => galleryState?.toggleTag(e),
          ),
        )
        .toList();

    return AnimatedCrossFade(
      crossFadeState:
          shouldShow ? CrossFadeState.showFirst : CrossFadeState.showSecond,
      duration: const Duration(milliseconds: 200),
      secondChild: const SizedBox.shrink(),
      firstChild: Container(
        child: widget.buttonBuilder?.call(widget.label, pillTags) ??
            GestureDetector(
              onTap: onTap,
              child: Container(
                decoration: const BoxDecoration(
                  border: Border(bottom: BorderSide(color: Colors.black12)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 12),
                    Text(
                      widget.label,
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
                      children: pillTags,
                    ),
                    const SizedBox(height: 18),
                  ],
                ),
              ),
            ),
      ),
    );
  }
}
