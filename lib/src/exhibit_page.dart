import 'package:flutter/material.dart';
import 'package:storyto/src/knob_manager.dart';
import 'package:storyto/storyto.dart';

enum ExhibitPageKnobPosition {
  inPage,
  inDrawer,
}

class ExhibitPage extends StatefulWidget {
  const ExhibitPage({
    super.key,
    required this.builder,
    required this.knobManager,
    this.knobPosition = ExhibitPageKnobPosition.inPage,
  });

  final KnobManager knobManager;
  final KnobBuilder builder;
  final ExhibitPageKnobPosition knobPosition;

  @override
  State<ExhibitPage> createState() => _ExhibitPageState();
}

class _ExhibitPageState extends State<ExhibitPage> {
  final GlobalKey<ScaffoldState> _key = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final knobManager = widget.knobManager;

    return Scaffold(
      key: _key,
      drawerEdgeDragWidth: 100,
      floatingActionButton: FloatingActionButton(
        onPressed: () => _key.currentState!.openDrawer(),
        mini: true,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        backgroundColor: Colors.grey.withAlpha((255 * 0.2).toInt()),
        child: const Icon(
          Icons.menu,
          color: Colors.black,
        ),
      ),
      drawer: widget.knobPosition == ExhibitPageKnobPosition.inDrawer
          ? Drawer(
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: knobManager.knobs.values
                        .map<Widget>(
                          (e) => ListenableBuilder(
                            listenable: e,
                            builder: (_, __) => Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8,
                              ),
                              child: e.knob(),
                            ),
                          ),
                        )
                        .toList(),
                  ),
                ),
              ),
            )
          : null,
      body: SafeArea(
        child: Column(
          children: [
            ListenableBuilder(
              listenable: knobManager.rebuildExhibit,
              builder: (_, __) => widget.builder(knobManager),
            ),
            if (widget.knobPosition == ExhibitPageKnobPosition.inPage)
              ListenableBuilder(
                listenable: knobManager.rebuildKnobs,
                builder: (_, __) => Column(
                  children: knobManager.knobs.values
                      .map(
                        (e) => ListenableBuilder(
                          listenable: e,
                          builder: (_, __) => Padding(
                            padding: const EdgeInsets.symmetric(
                              vertical: 8,
                            ),
                            child: e.knob(),
                          ),
                        ),
                      )
                      .toList(),
                ),
              )
          ],
        ),
      ),
    );
  }
}
