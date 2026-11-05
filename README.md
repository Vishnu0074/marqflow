# Marqflow

A lightweight Flutter text marquee for automatically scrolling overflowing text.

Marqflow makes it easy to handle long text in Flutter applications, especially when working with localization and multiple languages. It automatically detects text overflow and scrolls only when needed.

[![Pub](https://img.shields.io/pub/v/marqflow.svg)](https://pub.dev/packages/marqflow)
[![License: MIT](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

## Features

- Automatically detects overflowing text.
- Scrolls only when text exceeds the available width.
- Designed for localized and multilingual text.
- Supports different writing systems and scripts.
- Configurable scrolling speed and direction.
- Configurable start delay and pause duration.
- Loop and repeat controls.
- Optional locale-based language filtering.
- Controller support for start, pause, resume and stop.
- Optional pause-on-hover support for desktop and web.
- No third-party runtime dependencies.

## Installation

Add Marqflow to your `pubspec.yaml`:

```yaml
dependencies:
  marqflow: ^0.1.2
```

Run:

```bash
flutter pub get
```

## Basic Usage

Wrap your Text widget with Marqflow:

```dart
import 'package:flutter/material.dart';
import 'package:marqflow/marqflow.dart';

SizedBox(
  width: 220,
  child: Marqflow(
    child: const Text(
      'A long text that may exceed the available width',
      maxLines: 1,
      softWrap: false,
    ),
  ),
)
```

Marqflow automatically detects whether the text exceeds the available width.

- Short text remains stationary.
- Long text scrolls automatically.
- No manual character counting is required.

Provide a bounded width using `SizedBox`, `Expanded`, `ConstrainedBox`, or another suitable constraint.

## Localization and Multilingual Support

One of the most useful applications of Marqflow is handling localized text.

When developing multilingual applications, the same message can have significantly different lengths depending on the selected language.

For example, a translated label that fits comfortably in English may overflow in Malayalam, German, Tamil, or other languages.

Instead of manually checking translated string lengths or creating language-specific layouts, wrap your localized Text widget with Marqflow.

### Example with Flutter localization

```dart
SizedBox(
  width: 200,
  child: Marqflow(
    child: Text(
      AppLocalizations.of(context)!.accountSettings,
      maxLines: 1,
      softWrap: false,
    ),
  ),
)
```

This works with Flutter's generated localization classes, `gen-l10n`, `intl`, and other localization implementations that provide translated strings.

### Why use Marqflow for localization?

- Automatically adapts to the rendered width of translated text.
- No language-specific character limits.
- No need for separate scrolling configurations per language.
- No manual text-length calculations.
- Reusable across different localized screens.

Marqflow responds to the actual layout size of the text rather than relying on character counts. This is particularly useful because characters and glyphs have different widths across writing systems.

## Configuration

Customize scrolling behavior with `MarqflowConfig`.

```dart
Marqflow(
  config: const MarqflowConfig(
    velocity: 10,
    direction: MarqflowDirection.left,
    startDelay: Duration(milliseconds: 700),
    pauseAfterRound: Duration(milliseconds: 900),
    loop: true,
    repeat: true,
    autoStart: true,
    curve: Curves.linear,
  ),
  child: const Text(
    'Customize your scrolling text',
    maxLines: 1,
    softWrap: false,
  ),
)
```

### Configuration options

| Property | Default | Description |
|---|---|---|
| velocity | 10 | Scrolling speed in logical pixels per second |
| direction | left | Scrolling direction |
| startDelay | 700 ms | Initial animation delay |
| pauseAfterRound | 900 ms | Pause after reaching an edge |
| loop | true | Return to the starting position |
| repeat | true | Continue repeating rounds |
| autoStart | true | Start automatically |
| curve | Curves.linear | Animation curve |
| textWidthInCharacters | null | Optional approximate viewport width |
| gap | 32 | Reserved spacing for repeated content |

The default scrolling speed is 10 logical pixels per second. You can customize it using `velocity`.

## Language Filtering

By default, Marqflow runs for every application locale.

You can optionally configure language filtering.

### Non-English languages only

```dart
Marqflow(
  language: const MarqflowLanguage(
    mode: MarqflowLanguageMode.nonEnglishOnly,
  ),
  child: const Text(
    'Localized text',
    maxLines: 1,
    softWrap: false,
  ),
)
```

### Allow specific languages

```dart
Marqflow(
  language: const MarqflowLanguage(
    mode: MarqflowLanguageMode.custom,
    allowedLanguageCodes: ['ml', 'ta', 'hi'],
  ),
  child: const Text(
    'നിങ്ങളുടെ അക്കൗണ്ട് ക്രമീകരണങ്ങൾ',
    maxLines: 1,
    softWrap: false,
  ),
)
```

Language filtering uses the application's current locale. It does not automatically identify the language of the displayed text.

You do not need language filtering to use localized text. It is an optional behavior control.

## Controller

Control marquee playback programmatically using `MarqflowController`.

```dart
final controller = MarqflowController();

Marqflow(
  controller: controller,
  child: const Text(
    'A long scrolling title',
    maxLines: 1,
    softWrap: false,
  ),
)
```

Available controls:

```dart
controller.start();
controller.pause();
controller.resume();
controller.stop();
```

Dispose the controller when it is no longer needed:

```dart
controller.dispose();
```

A controller should be attached to only one mounted Marqflow widget at a time.

## Pause on Hover

Useful for desktop and web applications.

```dart
Marqflow(
  pauseOnPointerHover: true,
  child: const Text(
    'Hover over this text to pause',
    maxLines: 1,
    softWrap: false,
  ),
)
```

## Accessibility and Recommendations

- Use Marqflow for text that may exceed its available width.
- Prefer `maxLines: 1` and `softWrap: false`.
- Provide a bounded viewport width.
- Avoid excessively high scrolling speeds.
- Ensure important information remains accessible without relying exclusively on animation.

## Contributing

Issues and pull requests are welcome:

https://github.com/Vishnu0074/marqflow

## License

Marqflow is released under the MIT License.
See [LICENSE](LICENSE).
