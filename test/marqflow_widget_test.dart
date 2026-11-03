import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:marqflow/marqflow.dart';

void main() {
  testWidgets('renders its child', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 120,
            child: Marqflow(
              child: Text('Marqflow test'),
            ),
          ),
        ),
      ),
    );

    expect(find.text('Marqflow test'), findsOneWidget);
  });

  testWidgets('does not require text as its child', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 120,
            child: Marqflow(
              child: Icon(Icons.music_note),
            ),
          ),
        ),
      ),
    );

    expect(find.byIcon(Icons.music_note), findsOneWidget);
  });

  testWidgets('supports controller attachment and commands', (tester) async {
    final controller = MarqflowController();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 120,
            child: Marqflow(
              controller: controller,
              child: const Text('A long title that should overflow'),
            ),
          ),
        ),
      ),
    );

    await tester.pump();
    expect(controller.isAttached, isTrue);

    controller.pause();
    controller.resume();
    controller.start();
    controller.stop();

    await tester.pumpWidget(const MaterialApp(home: SizedBox()));
    expect(controller.isAttached, isFalse);
    controller.dispose();
  });
}
