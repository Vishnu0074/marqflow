import 'package:flutter/animation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marqflow/marqflow.dart';

void main() {
  group('MarqflowConfig defaults', () {
    const config = MarqflowConfig();

    test('preserves the original CharacterBasedMarquee defaults', () {
      expect(config.velocity, 20);
      expect(config.loop, isTrue);
      expect(config.repeat, isTrue);
      expect(config.startDelay, const Duration(milliseconds: 700));
      expect(config.pauseAfterRound, const Duration(milliseconds: 900));
      expect(config.curve, Curves.linear);
      expect(config.direction, MarqflowDirection.left);
      expect(config.textWidthInCharacters, isNull);
    });
  });

  test('Marqflow defaults to centered alignment', () {
    const widget = Marqflow(child: SizedBox());
    expect(widget.alignment, Alignment.center);
  });
}
