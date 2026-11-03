# Contributing

Thanks for helping improve Marqflow.

## Before opening a pull request

1. Discuss substantial API changes in an issue first.
2. Keep the public API small and document every public member.
3. Add or update widget tests for behavior changes.
4. Run the following checks:

```sh
dart format .
flutter analyze --fatal-infos
flutter test
```

## Pull requests

Keep pull requests focused. Include a clear description, reproduction steps for bug fixes, and tests for new behavior.

## Compatibility

Marqflow is a Flutter package. Avoid platform-specific imports unless a feature genuinely requires them.
