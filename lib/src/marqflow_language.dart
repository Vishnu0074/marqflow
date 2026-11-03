/// Controls when a Marqflow animation is enabled based on locale.
enum MarqflowLanguageMode {
  /// Always allow the marquee.
  all,

  /// Allow the marquee only when the locale language is not English.
  nonEnglishOnly,

  /// Use an explicit allow-list or block-list.
  custom,
}

/// Configuration for locale-aware marquee behavior.
class MarqflowLanguage {
  /// Creates locale filtering configuration.
  const MarqflowLanguage({
    this.mode = MarqflowLanguageMode.all,
    this.allowedLanguageCodes = const <String>[],
    this.excludedLanguageCodes = const <String>[],
  });

  /// The filtering strategy.
  final MarqflowLanguageMode mode;

  /// Language codes allowed when [mode] is [MarqflowLanguageMode.custom].
  ///
  /// When non-empty, this list takes precedence over [excludedLanguageCodes].
  /// Codes are compared by their language subtag, case-insensitively.
  final List<String> allowedLanguageCodes;

  /// Language codes excluded when [mode] is [MarqflowLanguageMode.custom].
  ///
  /// This list is used only when [allowedLanguageCodes] is empty.
  final List<String> excludedLanguageCodes;

  /// Returns whether a locale's language code is allowed.
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
      return !excludedLanguageCodes
          .any((value) => value.toLowerCase() == code);
    }

    // An empty custom filter is intentionally conservative.
    return code != 'en';
  }
}
