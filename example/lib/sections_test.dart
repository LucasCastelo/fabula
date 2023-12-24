import 'package:flutter/material.dart';

class SectionTest extends StatelessWidget {
  const SectionTest({
    super.key,
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        children: [
          const _Separator(),
          _SectionTitle(text: title),
          ...List.generate(
            children.length,
            (i) => Container(
              padding: const EdgeInsets.all(10),
              color: i % 2 == 0 ? Colors.grey[300] : Colors.grey[400],
              child: children[i],
            ),
          )
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.text,
  });

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class _Separator extends StatelessWidget {
  const _Separator();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black,
      height: 2,
      width: MediaQuery.of(context).size.width,
    );
  }
}

class BoolTest extends StatelessWidget {
  const BoolTest({
    super.key,
    required this.value,
  });

  final bool value;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      color: value ? Colors.black : Colors.blueGrey,
    );
  }
}
