# Fabula

A Flutter widget gallery for iterating on components with live, tweakable knobs.

Build a page of exhibits, expose each component's props as knobs (strings, colors, integers, selectables, animation controllers, …), and edit them live in a side panel. Useful for design review, QA, and rapid iteration.

## Getting started

Add Fabula to your `pubspec.yaml`:

```yaml
dependencies:
  fabula: ^0.0.1
```

Wrap your gallery in an `ExhibitGallery` and declare each component as an `Exhibit`:

```dart
import 'package:flutter/material.dart';
import 'package:fabula/fabula.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ExhibitGallery(
        appBar: AppBar(title: const Text('Component Gallery')),
        children: [
          Exhibit.page(
            label: 'Button',
            tags: [ExhibitTag(label: 'Atom', color: Colors.blue)],
            builder: (context, k) => MyButton(
              label: k.string('label', initialValue: 'Press me'),
              color: k.color('color', initialValue: Colors.indigo),
              enabled: k.boolean('enabled', label: 'Enabled', initialValue: true),
            ),
          ),
        ],
      ),
    );
  }
}
```

## Knobs

Knobs are typed inputs that the gallery surfaces as editable controls:

| Method | Returns | Notes |
|--------|---------|-------|
| `k.string(id)` | `String` | Plain text field |
| `k.nString(id)` | `String?` | Toggleable null |
| `k.integer(id)` | `int` | Numeric input, tolerates invalid input |
| `k.nInteger(id)` | `int?` | Toggleable null |
| `k.boolean(id)` | `bool` | Checkbox |
| `k.color(id)` | `Color` | Hex input + optional predefined palette |
| `k.nColor(id)` | `Color?` | Toggleable null |
| `k.selectable(id, values: [...])` | `T` | Dropdown, requires non-empty values |
| `k.nSelectable(id, values: [...])` | `T?` | Dropdown, empty values allowed |
| `k.toggler(id, onValue, offValue)` | `T` | Two-state toggle |
| `k.animationController(id, vsync: this)` | `AnimationController` | Play/pause/loop scrubber |

## Sections & ordering

Group knobs and control their position with a `KnobLocation`:

```dart
k.string('title',
  initialValue: 'Hi',
  location: const KnobLocation(section: 'Content', order: 0));
k.color('background',
  initialValue: Colors.indigo,
  location: const KnobLocation(section: 'Style', order: 10));
```

Sections are collapsible. A section's slot is derived from its first (lowest-`order`) knob.

## Tags & filtering

Each `Exhibit` can carry `ExhibitTag`s. The gallery shows them as filter chips so you can narrow large galleries down to one slice.

## Example

A full example app lives in `example/`. Run with:

```sh
cd example
flutter run
```
