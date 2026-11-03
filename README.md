# Marqflow

A lightweight, customizable marquee widget for Flutter. Marqflow scrolls any widget when it overflows its viewport and provides configurable motion, locale filtering, and controller-based playback controls.

[![Pub](https://img.shields.io/pub/v/marqflow.svg)](https://pub.dev/packages/marqflow)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)
[![Dart](https://img.shields.io/badge/Dart-3.4%2B-blue.svg)](https://dart.dev)

## Features

- Accepts any Flutter widget as its child.
- Automatically scrolls only when the content overflows.
- Configurable velocity, direction, delay, pause, curve, and looping.
- Optional locale-aware language filtering.
- Controller API for start, pause, resume, and stop.
- Optional pause-on-hover support for desktop and web.
- No third-party runtime dependencies.

## Installation

Add Marqflow to your `pubspec.yaml`:

```yaml
dependencies:
  marqflow: ^0.1.0
```

Then run:

```sh
flutter pub get
```

## Basic usage

```dart
import 'package:flutter/material.dart';
import 'package:marqflow/marqflow.dart';

class SongTitle extends StatelessWidget {
  const SongTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Marqflow(
        config: const MarqflowConfig(
          velocity: 28,
          startDelay: Duration(milliseconds: 500),
        ),
        child: const Text(
          'A very long song title that may not fit',
          maxLines: 1,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
```

## Configuration

```dart
Marqflow(
  config: const MarqflowConfig(
    velocity: 32, // logical pixels per second
    direction: MarqflowDirection.left,
    startDelay: Duration(milliseconds: 600),
    pauseAfterRound: Duration(milliseconds: 800),
    loop: true,
    repeat: true,
    autoStart: true,
    curve: Curves.linear,
  ),
  child: const Text('Scrolling content'),
)
```

The widget uses its parent's available width as its viewport. Give it a bounded width (for example with `SizedBox`, `Expanded`, or `ConstrainedBox`) for predictable behavior. `textWidthInCharacters` is an optional approximate viewport width convenience; it is not a substitute for actual text measurement.

## Any widget as a child

Marqflow is not limited to text:

```dart
Marqflow(
  child: Row(
    mainAxisSize: MainAxisSize.min,
    children: const [
      Icon(Icons.music_note),
      SizedBox(width: 8),
      Text('Artist name  •  Album name'),
    ],
  ),
)
```

## Controller

Use `MarqflowController` when you need external playback controls:

```dart
final controller = MarqflowController();

// Attach to the widget:
Marqflow(
  controller: controller,
  child: const Text('A long title'),
)

// Then call:
controller.pause();
controller.resume();
controller.start();
controller.stop();

// Dispose the controller with its owner:
controller.dispose();
```

A controller is intended to be attached to one mounted Marqflow widget at a time.

## Locale filtering

By default, Marqflow runs for every locale.

```dart
Marqflow(
  language: const MarqflowLanguage(
    mode: MarqflowLanguageMode.nonEnglishOnly,
  ),
  child: const Text('Localized content'),
)
```

To allow only selected language codes:

```dart
Marqflow(
  language: const MarqflowLanguage(
    mode: MarqflowLanguageMode.custom,
    allowedLanguageCodes: ['ml', 'ta', 'hi'],
  ),
  child: const Text('കുറച്ച് നീളമുള്ള മലയാളം തലക്കെട്ട്'),
)
```

Locale filtering checks the app's current locale; it does not identify the language of the child text. For content-specific behavior, select the configuration explicitly.

## Pause on hover

```dart
Marqflow(
  pauseOnPointerHover: true,
  child: const Text('Hover over this marquee to pause'),
)
```

## Accessibility and layout notes

- Provide a bounded width around Marqflow.
- Keep important information available elsewhere when motion is disabled or reduced.
- Avoid relying on animation alone to communicate essential information.
- Marqflow does not currently duplicate content for a seamless continuous loop; it animates to an edge and resets between rounds.

## Contributing

Issues and pull requests are welcome:
https://github.com/Vishnu0074/marqflow

## License

Marqflow is released under the MIT License. See [LICENSE](LICENSE).
