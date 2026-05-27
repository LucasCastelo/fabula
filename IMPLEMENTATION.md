# Fabula — Implementation Guide

A practical guide to wiring Fabula into a Flutter app: gallery layout, knob types, ordering, filtering, color palettes, and the animation player.

For the high-level pitch, see `README.md`. This doc is the deep dive.

---

## 1. Installation

```yaml
dependencies:
  fabula: ^0.0.1
```

```dart
import 'package:fabula/fabula.dart';
```

The single import pulls in everything you'll need: `ExhibitGallery`, `Exhibit`, `Knob`, `KnobManager`, `KnobLocation`, `ColorHolster`, `PaletteColor`, `ExhibitTag`, `Touch`, plus all field widgets.

---

## 2. Quickstart

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
        appBar: AppBar(title: const Text('Components')),
        children: [
          Exhibit.page(
            label: 'Button',
            tags: [ExhibitTag(label: 'Atom', color: Colors.indigo)],
            builder: (context, k) => MyButton(
              label: k.string('label', initialValue: 'Press me'),
              color: k.color('color', initialValue: Colors.indigo),
              enabled: k.boolean(
                'enabled',
                label: 'Enabled',
                initialValue: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
```

That's a working gallery with one exhibit, three knobs, and a tag. Tap the FAB to open the filter sheet.

---

## 3. Building Blocks

### `ExhibitGallery`

The root widget. Holds a `GalleryController` (state for tags + search), wraps the body in an `InheritedNotifier` so descendants can react to filter changes.

```dart
ExhibitGallery(
  appBar: AppBar(title: const Text('Gallery')),
  children: [
    Exhibit.page(...),
    Exhibit.raw(...),
    // ...
  ],
)
```

`children` is `List<Widget>`. Anything goes here, but only `Exhibit` widgets participate in filtering.

`ExhibitGallery.of(context)` returns the live `GalleryController` and subscribes the caller to filter changes via `InheritedNotifier`. Useful if you need to read filter state from a custom child widget.

### `Exhibit`

Represents one component on the gallery list. Three factories:

| Factory | What it does |
|---------|--------------|
| `Exhibit.page(label, builder, tags?, appBar?, customEntryDesign?)` | Tapping opens a `Scaffold` route with an `AppBar` and your widget. Knob panel appears as a `ListView` below the exhibit. |
| `Exhibit.raw(label, builder, tags?, customEntryDesign?)` | Tapping opens a full-screen `Stack` route. Knobs render as an overlay drawer. Use for fullscreen / floating UIs. |
| `Exhibit._` (private) | Internal base used by the factories. Don't call directly. |

```dart
Exhibit.page(
  label: 'Order Card',
  tags: [
    ExhibitTag(label: 'Card', color: Colors.blue),
    ExhibitTag(label: 'Order', color: Colors.green),
  ],
  builder: (context, k) => OrderCard(
    title: k.string('title', initialValue: 'Order #123'),
    color: k.color('background', initialValue: Colors.white),
  ),
)
```

#### `customEntryDesign`

If you want the gallery row to look different from the default (label + tag chips), pass a `customEntryDesign`:

```dart
Exhibit.page(
  label: 'Custom row',
  customEntryDesign: (label, tagChips) => Card(
    child: ListTile(
      leading: const Icon(Icons.widgets),
      title: Text(label),
      trailing: Wrap(spacing: 4, children: tagChips),
    ),
  ),
  builder: (context, k) => MyWidget(...),
)
```

### `KnobBuilder`

```dart
typedef KnobBuilder = Widget Function(BuildContext context, KnobManager knobs);
```

This is what you pass as `builder:`. Both `context` and the knob manager are available — call `k.string(...)`, `k.color(...)` etc. to register knobs, and use any context-dependent APIs (`Theme.of(context)`, `context.get<X>()`, localization helpers).

The builder is called on **every rebuild** of the exhibit. Knob registrations are idempotent — calling `k.string('id', initialValue: 'A')` after the first time returns the existing knob's *current value*, not the initial value. **Keep your builder idempotent**: register the same set of knobs every call.

---

## 4. Knob Reference

All knob methods take a string `id` (required, must be unique within an exhibit) and these common optional parameters:

| Param | Type | Purpose |
|-------|------|---------|
| `description` | `String?` | Rendered as an info icon tooltip next to the label. |
| `location` | `KnobLocation` | Section + ordering. See §5. |

Plus knob-specific parameters listed below.

### Text

```dart
String s = k.string('id',
  initialValue: 'hello',
  decoration: KnobTextFieldDecoration(label: 'Greeting'),
);

String? ns = k.nString('id', initialValue: null);
```

### Numeric

```dart
int n = k.integer('id', value: 42);
int? nn = k.nInteger('id', initialValue: null);
```

Invalid input is silently ignored (the knob keeps its previous value), so users typing partial numbers don't crash anything.

### Boolean

```dart
bool b = k.boolean('id',
  label: 'Enabled',
  initialValue: true,
);
```

### Toggler (two-state)

A boolean with two arbitrary value types.

```dart
String mode = k.toggler('id',
  label: 'Mode',
  onValue: 'live',
  offValue: 'preview',
);
```

### Color

```dart
Color c = k.color('id',
  initialValue: Colors.indigo,
  holsters: myPalette,         // List<ColorHolster>?
);

Color? nc = k.nColor('id',
  value: null,
  holsters: myPalette,
);
```

The hex input accepts 3, 6, or 8 character hex (CSS shorthand, RGB, or AARRGGBB), with optional `#` prefix. Tap the "HSV ▶" toggle for slider-based editing.

See §7 for `ColorHolster` / palette grouping.

### Selectable (enum / option list)

```dart
Food f = k.selectable<Food>('id',
  values: Food.values,
  nameMarshal: (v) => v.label,
);

Food? nf = k.nSelectable<Food>('id',
  values: Food.values,
);
```

`selectable` requires a non-empty `values` list — calling with an empty list throws an `ArgumentError` (use `nSelectable` if values may be empty). `nSelectable` shows a "Disabled" or "No options" inert state when null or empty.

### Animation controller

```dart
AnimationController controller = k.animationController('id',
  vsync: this,                   // your TickerProvider
  duration: const Duration(seconds: 3),
  label: 'My Animation',         // shown in the player UI
);
```

The player UI has: scrub slider, transport (play/pause/reverse/reset/step), speed buttons (`-5x` … `5x`), repeat mode (off / loop / ping-pong), and an Advanced section with duration deltas and a loop range. See §8.

Note: `animationController` defaults to `KnobLocation(order: -1000)` so it bubbles to the top of the knob list. Pass an explicit `location` to override.

---

## 5. Sections & Ordering

Every knob carries a `KnobLocation`:

```dart
class KnobLocation {
  const KnobLocation({this.section, this.order = 0});
  final String? section;
  final double order;
}
```

- `section` (optional): groups knobs under a labeled, collapsible header.
- `order` (default 0): global sort key. **A section's slot is derived from the lowest-`order` knob in it.** Lower `order` → appears earlier.

```dart
k.string('title',
  location: const KnobLocation(section: 'Content', order: 0));
k.string('subtitle',
  location: const KnobLocation(section: 'Content', order: 1));
k.color('bg',
  location: const KnobLocation(section: 'Style', order: 10));
k.color('fg',
  location: const KnobLocation(section: 'Style', order: 11));
```

Render order: `Content` (orders 0, 1), then `Style` (orders 10, 11). Sections are collapsed by default; tap the header to expand. Negative orders work too — useful for "always on top" knobs like an `AnimationController`.

---

## 6. Tags & Filtering

### Defining tags

```dart
ExhibitTag(label: 'Card', color: Colors.blue)
```

Tags are value types. **Identity = (lowercased label, color).** Two `ExhibitTag(label: 'X', color: red)` instances are equal. `ExhibitTag(label: 'X', color: red)` ≠ `ExhibitTag(label: 'X', color: blue)`.

Pass them per exhibit:

```dart
Exhibit.page(
  label: 'My Card',
  tags: [
    ExhibitTag(label: 'Card', color: Colors.blue),
    ExhibitTag(label: 'Featured', color: Colors.orange),
  ],
  builder: ...
)
```

### The filter sheet

A FAB at the bottom-right of the gallery opens a modal bottom sheet with:

- **Search input** — case-insensitive substring match against the `Exhibit.label`.
- **Tag chips** — all tags registered across all exhibits. Tap to toggle. Multiple selected tags act as OR.

When any filter is active, the FAB icon becomes filled (highlighted). Tap "Clear" inside the sheet to reset.

Filter state lives on `GalleryController` and is automatically applied to every `Exhibit` via the `InheritedNotifier`. Exhibits that don't pass the filter cross-fade out.

---

## 7. Color Palettes

Pass curated color sets to `k.color` / `k.nColor` via `holsters: List<ColorHolster>?`.

```dart
const brandPalette = ColorHolster(
  label: 'Brand',
  properties: [
    PaletteColor(label: 'Brand Red',  color: Color(0xFFE53935)),
    PaletteColor(label: 'Brand Blue', color: Color(0xFF1E88E5)),
  ],
);

const statusPalette = ColorHolster(
  label: 'Status',
  properties: [
    PaletteColor(label: 'Success', color: Colors.green),
    PaletteColor(label: 'Warning', color: Colors.orange),
    PaletteColor(label: 'Error',   color: Colors.red),
  ],
);

k.color('cardBackground',
  initialValue: Colors.white,
  holsters: [brandPalette, statusPalette],
);
```

The "Palette" button below the hex input opens a searchable picker dialog. Each holster renders as a labeled section; each `PaletteColor` is a row with a 24×24 swatch, label, and hex. Search filters by label or hex.

> **Naming note**: the inner type is `PaletteColor`, not `ColorProperty`, because `flutter/painting.dart` already exports a class called `ColorProperty`.

---

## 8. Animation Player

The widget that `k.animationController` renders has six concerns:

1. **Label + tooltip** at top (from `label` and `description` params).
2. **Transport row**: step back, reverse, play, pause, reset, step forward, repeat-mode toggle.
3. **Scrub slider** — full-width, color-coded to the controller's status (green forward, orange reverse, gray idle). Drag to set value.
4. **Time display** — `MM:SS.HH / MM:SS.HH` (elapsed / total).
5. **Speed row** — `-5x`, `-3x`, `1x`, `3x`, `5x`. Negative = slower (`duration × |N|`); positive = faster (`duration / N`). Tapping a speed both sets the rate and plays forward at it.
6. **Advanced** disclosure — duration delta buttons (`−1s / −500ms / −100ms / +100ms / +500ms / +1s`, clamped 50ms–600s) and a loop range slider.

Repeat modes:

- **Off** — plays once then stops.
- **Loop** — on completion, jumps back to `loopRange.start` and replays forward.
- **Ping-pong** — on completion, reverses; on dismissal, forwards again.

Duration changes apply **immediately** — if the controller is in flight, the player re-issues `animateTo` / `animateBack` from the current position with the new duration.

---

## 9. Knob Descriptions

`description: String?` on any knob renders as an info icon (`Icons.info_outline`) next to the knob's label. Tap the icon to reveal a `Tooltip`. Plain text only — no markdown.

```dart
k.color('cardBg',
  initialValue: Colors.white,
  description: 'Used behind the order summary. '
      'Must contrast with both text and the brand accent.',
);
```

For knobs without a label area (`SelectorField`, `NullableSelectorField`, `AnimationPlayer`), the description is stored on the knob but not currently surfaced — accept the limitation or contribute a renderer.

---

## 10. Customization

### `Touch` — the gallery's tap widget

Fabula does not use `InkWell` ripples. All tap surfaces use `Touch`, which animates a scale-down (0.95) on press, supports keyboard activation (Enter/Space), and ships `Semantics(button: true)`. Use it in your custom `displayBuilder`s or other gallery-adjacent widgets for consistency:

```dart
Touch(
  semanticsLabel: 'Open detail',
  onTap: _openDetail,
  child: Container(...),
)
```

### `KnobLabel`

If you're authoring a custom field widget and want the same label-with-info-icon treatment as built-in fields:

```dart
KnobLabel(label: 'My field', description: 'A helpful hint')
```

### Theming

Fabula's internal widgets use Material defaults plus a few hand-picked colors (`Colors.black`, `Colors.black54`, etc.). There is **no theming hook yet** — open an issue if you need design-system integration. See `BACKLOG.md` improvement I3.

---

## 11. Lifecycle & Disposal

You generally don't need to think about disposal — Fabula owns and tears down everything it creates:

- `KnobManager` disposes all registered knobs in its `dispose()`.
- `Knob.dispose()` calls `onDispose(value)` if set, then `ChangeNotifier.dispose()`. Knobs that own resources (the `AnimationController` from `k.animationController`) use `onDispose` to tear them down.
- `GalleryController` is disposed by `_ExhibitGalleryState`.

Caveats:

- The builder runs every frame. Don't allocate listeners or controllers inside it — use `k.animationController` for animations, and lift other resources into your widget tree.
- Each knob registration is type-asserted in debug mode. Switching `k.string('foo')` → `k.color('foo')` in code without renaming will trip an `AssertionError`.

---

## 12. Patterns

### One source of truth per exhibit

Treat the builder like a render function: same inputs → same widget structure → same knobs registered. Don't conditionally register knobs based on values — instead, expose the dependency as `nString` / `nColor` (nullable) or use `selectable` to switch modes.

```dart
// ❌ Non-idempotent — flips registration based on value, causes rebuild churn
final mode = k.toggler('mode', onValue: 'a', offValue: 'b', label: 'Mode');
if (mode == 'a') {
  final extra = k.string('extra-a');
}

// ✅ Always register, gate behavior
final mode = k.toggler('mode', onValue: 'a', offValue: 'b', label: 'Mode');
final extraA = k.string('extra-a');
final extraB = k.string('extra-b');
final extra = mode == 'a' ? extraA : extraB;
```

### Sharing palettes

Define your palette once at the top of `main.dart` (or in a shared file) and pass it to every relevant `k.color` call.

```dart
const _palette = [
  ColorHolster(label: 'Brand', properties: [...]),
  ColorHolster(label: 'Neutral', properties: [...]),
];

// later, inside many exhibits:
k.color('bg', initialValue: Colors.white, holsters: _palette)
```

### Multiple `ExhibitGallery`s

Each gallery has its own `GalleryController`, so you can host multiple isolated galleries in one app (e.g., one per design system).

---

## 13. Example app

The `example/` folder is a full Flutter app exercising every knob type:

```sh
cd example
flutter run
```

Tour the "Section Ordering Example" to see `KnobLocation` in action, and "Color Example" to see palettes + HSV sliders.

---

## 14. Where things live

```
lib/
  fabula.dart                          ← public API barrel
  src/
    entities/                          ← public data types (Knob, KnobLocation,
                                          ColorHolster, ExhibitTag, …)
    fields/                            ← built-in input widgets per knob type
    helpers/
      hex_color.dart                   ← tryParseHexColor / hexStringFor
      knob_manager_extensions.dart     ← viewKnobs(), section rendering
    knob_manager.dart                  ← the knob registration / lookup hub
    widgets/
      exhibit/                         ← gallery + exhibit + raw + overlay
      general/                         ← Touch, KnobLabel, HsvSliders, …
      color_holster_picker.dart        ← palette picker dialog
      nullable_toggler.dart            ← the "Optional" toggle row
```

Public types are exported from `lib/fabula.dart`. Anything reachable only via `lib/src/...` paths is internal.
