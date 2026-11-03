import 'package:flutter/foundation.dart';

/// Controls when a Marqflow animation is enabled based on locale.
enum MarqflowLanguageMode {
  /// Always allow the marquee.
  all,

  /// Allow the marquee only when the locale language is not English.
  nonEnglishOnly,

  /// Use an explicit allow-list or block-list.
  custom,
}

/// Immutable configuration for locale-aware marquee behavior.
@immutable
class MarqflowLanguage {
  /// Creates locale filtering configuration.
  const MarqflowLanguage({
    this.mode = MarqflowLanguageMode.all,
    this.allowedLanguageCodes = const <String>[],
    this.excludedLanguageCodes = const <String>[],
  });

  /// The filtering strategy.
  final MarqflowLanguageMode mode;

  /// Language codes allowed in custom mode.
  ///
  /// When non-empty, this list takes precedence over
  /// [excludedLanguageCodes]. Codes are compared case-insensitively.
  final List<String> allowedLanguageCodes;

  /// Language codes excluded in custom mode.
  ///
  /// This list is used only when [allowedLanguageCodes] is empty.
  final List<String> excludedLanguageCodes;

  /// Returns whether the supplied locale language code is allowed.
  bool allows(String? languageCode) {
    if (mode == MarqflowLanguageMode.all) return true;
    if (languageCode == null || languageCode.isEmpty) return true;

    final code = languageCode.toLowerCase();

    if (mode == MarqflowLanguageMode.nonEnglishOnly) {
      return code != 'en';
    }

    if (allowedLanguageCodes.isNotEmpty) {
      return allowedLanguageCodes.any((value) => value.toLowerCase() == code);
    }

    if (excludedLanguageCodes.isNotEmpty) {
      return !excludedLanguageCodes.any(
        (value) => value.toLowerCase() == code,
      );
    }

    return code != 'en';
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is MarqflowLanguage &&
          mode == other.mode &&
          listEquals(allowedLanguageCodes, other.allowedLanguageCodes) &&
          listEquals(excludedLanguageCodes, other.excludedLanguageCodes);

  @override
  int get hashCode => Object.hash(
        mode,
        Object.hashAll(allowedLanguageCodes),
        Object.hashAll(excludedLanguageCodes),
      );
}
