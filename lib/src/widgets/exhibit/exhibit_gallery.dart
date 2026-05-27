import 'package:flutter/material.dart';
import 'package:fabula/fabula.dart';
import 'package:fabula/src/widgets/general/exhibit_tag_pill.dart';

class GalleryController extends ChangeNotifier {
  final Set<ExhibitTag> availableTags = {};
  final Set<ExhibitTag> filterByTags = {};
  String _searchQuery = '';
  bool _registerNotifyScheduled = false;

  String get searchQuery => _searchQuery;

  bool get hasActiveFilter =>
      _searchQuery.isNotEmpty || filterByTags.isNotEmpty;

  void toggleTag(ExhibitTag tag) {
    if (filterByTags.contains(tag)) {
      filterByTags.remove(tag);
    } else {
      filterByTags.add(tag);
    }
    notifyListeners();
  }

  void setSearchQuery(String query) {
    final next = query.trim();
    if (_searchQuery == next) return;
    _searchQuery = next;
    notifyListeners();
  }

  void clearFilters() {
    if (!hasActiveFilter) return;
    _searchQuery = '';
    filterByTags.clear();
    notifyListeners();
  }

  void registerTags(List<ExhibitTag> tags) {
    var added = false;
    for (final tag in tags) {
      if (availableTags.add(tag)) added = true;
    }
    if (!added || _registerNotifyScheduled) return;
    // registerTags is typically called from `didChangeDependencies` during
    // the first build; defer the notify to post-frame so InheritedNotifier
    // dependents pick it up cleanly.
    _registerNotifyScheduled = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _registerNotifyScheduled = false;
      if (hasListeners) notifyListeners();
    });
  }

  /// True if the given tag set passes the current tag filter (independent of
  /// the text search). Used for chip highlighting in the filter sheet.
  bool matchesTagFilter(List<ExhibitTag> tags) {
    if (filterByTags.isEmpty) return true;
    return tags.any(filterByTags.contains);
  }

  /// True if an exhibit with [label] and [tags] should be visible under the
  /// current filter state (text + tags combined).
  bool shouldShow({required String label, required List<ExhibitTag> tags}) {
    if (_searchQuery.isNotEmpty &&
        !label.toLowerCase().contains(_searchQuery.toLowerCase())) {
      return false;
    }
    return matchesTagFilter(tags);
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
    final scope = context.dependOnInheritedWidgetOfExactType<_GalleryScope>();
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
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: widget.children,
            ),
          ),
          floatingActionButton: const _FilterFab(),
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

class _FilterFab extends StatelessWidget {
  const _FilterFab();

  void _open(BuildContext context, GalleryController controller) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _FilterSheet(controller: controller),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = ExhibitGallery.of(context);
    final active = controller.hasActiveFilter;
    return FloatingActionButton(
      onPressed: () => _open(context, controller),
      tooltip: 'Filter',
      backgroundColor: active ? Colors.black : Colors.white,
      foregroundColor: active ? Colors.white : Colors.black87,
      elevation: 2,
      child: Icon(active ? Icons.filter_alt : Icons.filter_alt_outlined),
    );
  }
}

class _FilterSheet extends StatefulWidget {
  const _FilterSheet({required this.controller});

  final GalleryController controller;

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late final _searchController =
      TextEditingController(text: widget.controller.searchQuery);

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onControllerChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onControllerChanged() {
    if (!mounted) return;
    setState(() {});
    // Sync the search field if the query was cleared externally.
    if (_searchController.text != widget.controller.searchQuery) {
      _searchController.text = widget.controller.searchQuery;
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final sortedTags = List<ExhibitTag>.from(controller.availableTags)
      ..sort((a, b) => a.label.compareTo(b.label));

    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
        top: 4,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Text(
                'Filter',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              if (controller.hasActiveFilter)
                Touch(
                  semanticsLabel: 'Clear all filters',
                  onTap: controller.clearFilters,
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: Text(
                      'Clear',
                      style: TextStyle(fontSize: 12, color: Colors.black54),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _searchController,
            onChanged: controller.setSearchQuery,
            autofocus: true,
            style: const TextStyle(fontSize: 13),
            decoration: InputDecoration(
              hintText: 'Search exhibits',
              hintStyle: const TextStyle(fontSize: 13, color: Colors.black38),
              prefixIcon:
                  const Icon(Icons.search, size: 16, color: Colors.black54),
              prefixIconConstraints:
                  const BoxConstraints(minWidth: 32, minHeight: 32),
              isDense: true,
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Colors.black12, width: 1),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Colors.black12, width: 1),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(6),
                borderSide: const BorderSide(color: Colors.black54, width: 1.2),
              ),
            ),
          ),
          if (sortedTags.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text(
              'Tags',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Colors.black54,
                letterSpacing: 0.3,
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: sortedTags
                  .map(
                    (e) => ExhibitTagPill(
                      tag: e,
                      colored: controller.matchesTagFilter([e]),
                      onTap: () => controller.toggleTag(e),
                    ),
                  )
                  .toList(),
            ),
          ],
        ],
      ),
    );
  }
}
