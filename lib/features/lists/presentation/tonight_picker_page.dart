import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class TonightPickerPage extends ConsumerStatefulWidget {
  const TonightPickerPage({super.key});

  @override
  ConsumerState<TonightPickerPage> createState() => _TonightPickerPageState();
}

class _TonightPickerPageState extends ConsumerState<TonightPickerPage> {
  double _maxDuration = 150;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Tonight Picker')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Max Duration: ${_maxDuration.toInt()} minutes', style: textTheme.headlineMedium),
            Slider(
              value: _maxDuration,
              min: 60,
              max: 240,
              divisions: 18,
              label: '${_maxDuration.toInt()} mins',
              onChanged: (val) => setState(() => _maxDuration = val),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Tonight\'s Pick!'),
                    content: const Text('We picked: Movie Title 1: The Epic Saga'),
                    actions: [
                      FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Awesome')),
                    ],
                  ),
                );
              },
              child: const Text('Pick for me tonight'),
            ),
          ],
        ),
      ),
    );
  }
}
