import 'package:flutter/material.dart';
import 'package:fabula/src/widgets/general/exhibit_tag_pill.dart';
import 'package:fabula/fabula.dart';

class GalleryController extends ChangeNotifier {
  final Set<ExhibitTag> availableTags = {};
  final Set<ExhibitTag> filterByTags = {};

  void toggleTag(ExhibitTag tag) {
    if (filterByTags.contains(tag)) {
      filterByTags.remove(tag);
    } else {
      filterByTags.add(tag);
    }
    notifyListeners();
  }

  void registerTags(List<ExhibitTag> tags) {
    var added = false;
    for (final tag in tags) {
      if (availableTags.add(tag)) added = true;
    }
    if (added) notifyListeners();
  }

  bool shouldShow(List<ExhibitTag> tags) {
    if (filterByTags.isEmpty) return true;
    return tags.any(filterByTags.contains);
  }
}

class ExhibitGallery extends StatefulWidget {
  const ExhibitGallery({
    super.key,
    required this.children,
    this.appBar,
  });

  final PreferredSizeWidget? appBar;
  final List<Widget> children;

  static GalleryController of(BuildContext context) {
    final scope =
        context.dependOnInheritedWidgetOfExactType<_GalleryScope>();
    assert(scope != null,
        'ExhibitGallery.of() called outside an ExhibitGallery widget.');
    return scope!.notifier!;
  }

  @override
  State<ExhibitGallery> createState() => _ExhibitGalleryState();
}

class _ExhibitGalleryState extends State<ExhibitGallery> {
  late final controller = GalleryController();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _GalleryScope(
      notifier: controller,
      child: Material(
        child: Scaffold(
          appBar: widget.appBar,
          resizeToAvoidBottomInset: true,
          body: SafeArea(
            child: _GalleryBody(children: widget.children),
          ),
        ),
      ),
    );
  }
}

class _GalleryScope extends InheritedNotifier<GalleryController> {
  const _GalleryScope({
    required super.notifier,
    required super.child,
  });
}

class _GalleryBody extends StatelessWidget {
  const _GalleryBody({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final controller = ExhibitGallery.of(context);
    final sortedTags = List<ExhibitTag>.from(controller.availableTags)
      ..sort((a, b) => a.label.compareTo(b.label));

    return ListView(
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
              children: sortedTags
                  .map(
                    (e) => ExhibitTagPill(
                      tag: e,
                      colored: controller.shouldShow([e]),
                      onTap: () => controller.toggleTag(e),
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
        ...children,
      ],
    );
  }
}
