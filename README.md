# Marqflow

A lightweight, customizable marquee widget for Flutter. Marqflow scrolls any widget when it overflows its viewport and provides configurable motion, locale filtering, and controller-based playback controls.

[![Pub](https://img.shields.io/pub/v/marqflow.svg)](https://pub.dev/packages/marqflow)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## Features

- Accepts any Flutter widget as its child.
- Detects horizontal overflow and scrolls only when needed.
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

Run `flutter pub get`.

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
          softWrap: false,
          overflow: TextOverflow.visible,
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }
}
```

Marqflow needs a bounded viewport width. Use `SizedBox`, `ConstrainedBox`, or `Expanded` to provide one.

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

The default viewport is the width provided by the parent. The optional `textWidthInCharacters` setting creates an approximate text-sized viewport; it is a convenience rather than precise glyph measurement.

## Any widget as a child

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

```dart
final controller = MarqflowController();

Marqflow(
  controller: controller,
  child: const Text('A long title'),
)

// External controls:
controller.pause();
controller.resume();
controller.start();
controller.stop();

// Dispose the controller with its owner.
controller.dispose();
```

A controller should be attached to only one mounted Marqflow widget at a time.

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

Allow only selected language codes:

```dart
Marqflow(
  language: const MarqflowLanguage(
    mode: MarqflowLanguageMode.custom,
    allowedLanguageCodes: ['ml', 'ta', 'hi'],
  ),
  child: const Text('കുറച്ച് നീളമുള്ള മലയാളം തലക്കെട്ട്'),
)
```

Filtering uses the application's current locale. It does not identify the language of the child text.

## Pause on hover

```dart
Marqflow(
  pauseOnPointerHover: true,
  child: const Text('Hover over this marquee to pause'),
)
```

## Motion and accessibility

Marqflow does not currently duplicate child content for seamless continuous scrolling; it animates to an edge and resets between rounds. For important information, provide an accessible non-animated alternative and avoid communicating essential meaning through motion alone.

## Contributing

Issues and pull requests are welcome:
https://github.com/Vishnu0074/marqflow

## License

Marqflow is released under the MIT License. See [LICENSE](LICENSE).
