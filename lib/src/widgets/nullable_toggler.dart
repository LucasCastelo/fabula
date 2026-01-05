import 'package:flutter/material.dart';

class NullableToggler extends StatelessWidget {
  const NullableToggler({
    super.key,
    required this.onClick,
    required this.isEnabled,
  });

  final VoidCallback onClick;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onClick,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  const TextSpan(
                    text: 'Status: ',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                  TextSpan(
                    text: isEnabled ? 'Enabled' : 'Disabled',
                    style: TextStyle(
                      fontSize: 12,
                      color: isEnabled ? Colors.green : Colors.redAccent,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.grey.withAlpha((255 * 0.2).toInt()),
                  ),
                  height: 15,
                  width: 15,
                  child: isEnabled
                      ? const Icon(
                          Icons.check,
                          color: Colors.black,
                          size: 12,
                        )
                      : const SizedBox.shrink(),
                ),
                const SizedBox(width: 4),
                const Text(
                  'Optional',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
