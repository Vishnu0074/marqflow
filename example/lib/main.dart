import 'package:flutter/material.dart';
import 'package:marqflow/marqflow.dart';

void main() {
  runApp(const MarqflowExampleApp());
}

class MarqflowExampleApp extends StatelessWidget {
  const MarqflowExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Marqflow Example',
      theme: ThemeData(colorSchemeSeed: Colors.deepPurple),
      home: const MarqflowExamplePage(),
    );
  }
}

class MarqflowExamplePage extends StatefulWidget {
  const MarqflowExamplePage({super.key});

  @override
  State<MarqflowExamplePage> createState() => _MarqflowExamplePageState();
}

class _MarqflowExamplePageState extends State<MarqflowExamplePage> {
  final MarqflowController _controller = MarqflowController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Marqflow')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          const Text('Basic text marquee'),
          const SizedBox(height: 12),
          const SizedBox(
            width: 260,
            child: Marqflow(
              config: MarqflowConfig(velocity: 35),
              child: Text(
                'A long title that automatically scrolls when it overflows',
                maxLines: 1,
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text('Any widget marquee'),
          const SizedBox(height: 12),
          const SizedBox(
            width: 260,
            child: Marqflow(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.music_note),
                  SizedBox(width: 8),
                  Text('Artist name • Album name • Track title'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
          const Text('Controlled marquee'),
          const SizedBox(height: 12),
          SizedBox(
            width: 260,
            child: Marqflow(
              controller: _controller,
              child: const Text(
                'Use the buttons below to control this scrolling title',
                maxLines: 1,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              FilledButton(
                onPressed: _controller.start,
                child: const Text('Start'),
              ),
              FilledButton.tonal(
                onPressed: _controller.pause,
                child: const Text('Pause'),
              ),
              FilledButton.tonal(
                onPressed: _controller.resume,
                child: const Text('Resume'),
              ),
              OutlinedButton(
                onPressed: _controller.stop,
                child: const Text('Stop'),
              ),
            ],
          ),
          const SizedBox(height: 32),
          const Text('Locale-aware marquee'),
          const SizedBox(height: 12),
          const SizedBox(
            width: 260,
            child: Marqflow(
              language: MarqflowLanguage(
                mode: MarqflowLanguageMode.nonEnglishOnly,
              ),
              child: Text('A title displayed only in non-English locales'),
            ),
          ),
        ],
      ),
    );
  }
}
