import 'package:flutter/material.dart';

extension IteratorSeparate on Iterable<Widget> {
  Iterable<Widget> separate(Widget separator) {
    final list = <Widget>[];
    for (var i = 0; i < length; i++) {
      list.add(elementAt(i));

      if (i == length - 1) {
        continue;
      }

      list.add(separator);
    }
    return list;
  }
}
