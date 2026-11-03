import 'package:flutter_test/flutter_test.dart';
import 'package:marqflow/marqflow.dart';

void main() {
  group('MarqflowLanguage', () {
    test('allows all locales by default', () {
      const filter = MarqflowLanguage();
      expect(filter.allows('en'), isTrue);
      expect(filter.allows('ml'), isTrue);
      expect(filter.allows(null), isTrue);
    });

    test('allows only non-English locales in nonEnglishOnly mode', () {
      const filter = MarqflowLanguage(
        mode: MarqflowLanguageMode.nonEnglishOnly,
      );
      expect(filter.allows('en'), isFalse);
      expect(filter.allows('ml'), isTrue);
    });

    test('uses the allow-list when it is provided', () {
      const filter = MarqflowLanguage(
        mode: MarqflowLanguageMode.custom,
        allowedLanguageCodes: ['ml', 'ta'],
        excludedLanguageCodes: ['en'],
      );
      expect(filter.allows('ml'), isTrue);
      expect(filter.allows('ML'), isTrue);
      expect(filter.allows('en'), isFalse);
      expect(filter.allows('hi'), isFalse);
    });

    test('uses the block-list when no allow-list is provided', () {
      const filter = MarqflowLanguage(
        mode: MarqflowLanguageMode.custom,
        excludedLanguageCodes: ['en'],
      );
      expect(filter.allows('en'), isFalse);
      expect(filter.allows('ml'), isTrue);
    });
  });
}
