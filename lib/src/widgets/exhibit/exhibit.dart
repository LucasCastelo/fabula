import 'package:flutter/material.dart';
import 'package:storyto/src/knob_manager.dart';
import 'package:storyto/src/widgets/exhibit/exhibit_list.dart';
import 'package:storyto/src/widgets/exhibit/exhibit_overlay.dart';
import 'package:storyto/src/widgets/general/exhibit_tag_pill.dart';
import 'package:storyto/storyto.dart';

typedef KnobBuilder = Widget Function(KnobManager);
typedef CustomEntryDesign = Widget Function(String label, List<Widget> tags);
typedef ContextCallback = void Function(BuildContext context);

enum ExhibitEntryType {
  page,
  bottomSheet,
  popupMenu,
}

class Exhibit extends StatefulWidget {
  const Exhibit._({
    required this.label,
    this.tags = const [],
    this.displayBuilder,
    this.onTap,
  });

  factory Exhibit.raw({
    required String label,
    required KnobBuilder builder,
    List<ExhibitTag> tags = const [],
    CustomEntryDesign? customEntryDesign,
  }) =>
      Exhibit._(
        label: label,
        tags: tags,
        displayBuilder: customEntryDesign,
        onTap: (context) => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ExhibitRaw(
              builder: builder,
              overlayBuilder: (context, knobs) => ExhibitOverlay(knobs: knobs),
            ),
          ),
        ),
      );

  factory Exhibit.page({
    required String label,
    required KnobBuilder builder,
    List<ExhibitTag> tags = const [],
    CustomEntryDesign? customEntryDesign,
    PreferredSizeWidget? appBar,
  }) =>
      Exhibit._(
        label: label,
        tags: tags,
        displayBuilder: customEntryDesign,
        onTap: (context) => Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => Scaffold(
              appBar: appBar ??
                  AppBar(
                    title: Text(label),
                    scrolledUnderElevation: 0,
                    elevation: 0,
                    shadowColor: Colors.black,
                    backgroundColor: Colors.white,
                  ),
              body: SafeArea(
                child: ExhibitList(builder: builder),
              ),
            ),
          ),
        ),
      );

  final String label;
  final List<ExhibitTag> tags;
  final CustomEntryDesign? displayBuilder;
  final ContextCallback? onTap;

  @override
  State<Exhibit> createState() => _ExhibitState();
}

class _ExhibitState extends State<Exhibit> {
  late final galleryState = ExhibitGalleryState.of(context);
  bool shouldShow = true;

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final pillTags = (widget.tags..sort((a, b) => a.label.compareTo(b.label)))
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
      firstChild: GestureDetector(
        onTap: () => widget.onTap?.call(context),
        child: widget.displayBuilder?.call(widget.label, pillTags) ??
            Container(
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
    );
  }
}
