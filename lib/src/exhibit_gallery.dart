import 'package:flutter/material.dart';
import 'package:storyto/src/widgets/exhibit_tag_pill.dart';
import 'package:storyto/storyto.dart';

class ExhibitGallery extends StatefulWidget {
  const ExhibitGallery({
    super.key,
    required this.children,
    this.appBar,
  });

  final PreferredSizeWidget? appBar;
  final List<Widget> children;

  @override
  State<ExhibitGallery> createState() => ExhibitGalleryState();
}

class ExhibitGalleryState extends State<ExhibitGallery> {
  final Set<ExhibitTag> availableTags = {};
  final Set<ExhibitTag> filterByTags = {};

  static ExhibitGalleryState? of(BuildContext context) {
    return context.findAncestorStateOfType<ExhibitGalleryState>();
  }

  void toggleTag(ExhibitTag tag) {
    if (filterByTags.contains(tag)) {
      filterByTags.remove(tag);
    } else {
      filterByTags.add(tag);
    }
    setState(() {});
  }

  void addTagToHolster(List<ExhibitTag> tags) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      availableTags.addAll(tags);
      setState(() {});
    });
  }

  bool shouldTagGreyOut(ExhibitTag tag) {
    return filterByTags.isEmpty || filterByTags.contains(tag);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Scaffold(
        appBar: widget.appBar,
        resizeToAvoidBottomInset: true,
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Filter by tags:',
                    style: TextStyle(
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    spacing: 4,
                    runSpacing: 4,
                    alignment: WrapAlignment.start,
                    children: availableTags
                        .map(
                          (e) => ExhibitTagPill(
                            tag: e,
                            colored: shouldTagGreyOut(e),
                            onTap: () => toggleTag(e),
                          ),
                        )
                        .toList(),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              const Text(
                'Exhibits:',
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              ...widget.children,
            ],
          ),
        ),
      ),
    );
  }
}
