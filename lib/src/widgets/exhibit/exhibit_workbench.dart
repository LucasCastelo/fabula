import 'package:flutter/material.dart';
import 'package:fabula/src/entities/exhibit_device.dart';
import 'package:fabula/src/helpers/iterator_separate.dart';
import 'package:fabula/src/helpers/knob_manager_extensions.dart';
import 'package:fabula/src/widgets/exhibit/exhibit.dart';
import 'package:fabula/src/widgets/exhibit/exhibit_gallery.dart';
import 'package:fabula/src/widgets/knob_manager_provider.dart';

/// Wide-layout detail pane: the exhibit preview next to a fixed knobs panel.
class ExhibitWorkbench extends StatelessWidget {
  const ExhibitWorkbench({
    super.key,
    required this.label,
    required this.builder,
    required this.fill,
  });

  static const double knobsPanelWidth = 360;

  final String label;
  final KnobBuilder builder;

  /// Whether the preview fills the pane (raw exhibits) instead of scrolling
  /// with padding (page exhibits).
  final bool fill;

  @override
  Widget build(BuildContext context) {
    final controller = ExhibitGallery.of(context);
    final deviceSize = controller.deviceSize;

    return KnobManagerProvider(
      builder: (context, k) {
        final preview = ListenableBuilder(
          listenable: k,
          builder: (context, _) => ListenableBuilder(
            listenable: Listenable.merge(k.knobs.values),
            builder: (context, __) => builder(context, k),
          ),
        );
        final content = fill
            ? preview
            : SingleChildScrollView(
                padding: EdgeInsets.all(deviceSize == null ? 24 : 16),
                child: preview,
              );

        return Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _WorkbenchHeader(label: label, controller: controller),
                  const Divider(height: 1),
                  Expanded(
                    child: deviceSize == null
                        ? content
                        : _DeviceFrame(size: deviceSize, child: content),
                  ),
                ],
              ),
            ),
            ListenableBuilder(
              listenable: k,
              builder: (context, _) {
                if (k.knobs.isEmpty) return const SizedBox.shrink();

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const VerticalDivider(width: 1),
                    SizedBox(
                      width: knobsPanelWidth,
                      child: ListView(
                        padding: const EdgeInsets.all(16),
                        children: k
                            .viewKnobs()
                            .separate(const SizedBox(height: 16))
                            .toList(),
                      ),
                    ),
                  ],
                );
              },
            ),
          ],
        );
      },
    );
  }
}

class _WorkbenchHeader extends StatelessWidget {
  const _WorkbenchHeader({
    required this.label,
    required this.controller,
  });

  final String label;
  final GalleryController controller;

  @override
  Widget build(BuildContext context) {
    final device = controller.device;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
          DropdownButton<ExhibitDevice?>(
            value: device,
            underline: const SizedBox.shrink(),
            style: const TextStyle(fontSize: 14, color: Colors.black87),
            onChanged: controller.setDevice,
            items: [
              const DropdownMenuItem(
                value: null,
                child: Text('Responsive'),
              ),
              for (final d in controller.devices)
                DropdownMenuItem(
                  value: d,
                  child: Text(
                    '${d.name}  ${d.size.width.round()}×${d.size.height.round()}',
                  ),
                ),
            ],
          ),
          IconButton(
            tooltip: controller.landscape ? 'Portrait' : 'Landscape',
            onPressed: device == null ? null : controller.toggleLandscape,
            icon: const Icon(Icons.screen_rotation_outlined),
          ),
        ],
      ),
    );
  }
}

/// Renders [child] at the logical [size] of a device, scaled down to fit the
/// available space, with a matching [MediaQuery].
class _DeviceFrame extends StatelessWidget {
  const _DeviceFrame({
    required this.size,
    required this.child,
  });

  static const double _bezel = 10;

  final Size size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Container(
            padding: const EdgeInsets.all(_bezel),
            decoration: BoxDecoration(
              color: Colors.black87,
              borderRadius: BorderRadius.circular(36),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(36 - _bezel),
              child: MediaQuery(
                data: MediaQuery.of(context).copyWith(
                  size: size,
                  padding: EdgeInsets.zero,
                  viewPadding: EdgeInsets.zero,
                  viewInsets: EdgeInsets.zero,
                ),
                child: SizedBox.fromSize(
                  size: size,
                  child: ColoredBox(
                    color: Colors.white,
                    child: child,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
