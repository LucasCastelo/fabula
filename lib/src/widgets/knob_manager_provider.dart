import 'package:flutter/widgets.dart';
import 'package:fabula/src/knob_manager.dart';
import 'package:fabula/src/widgets/exhibit/exhibit.dart';

class KnobManagerProvider extends StatefulWidget {
  const KnobManagerProvider({
    super.key,
    required this.builder,
  });

  final KnobBuilder builder;

  @override
  State<KnobManagerProvider> createState() => _KnobManagerProviderState();
}

class _KnobManagerProviderState extends State<KnobManagerProvider> {
  late final knobManager = KnobManager();

  @override
  void dispose() {
    knobManager.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, knobManager);
  }
}
