import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class AdvancedFiltersPage extends ConsumerWidget {
  const AdvancedFiltersPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Advanced Filters')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Filter by Genre', style: textTheme.headlineMedium),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: ['Action', 'Sci-Fi', 'Drama', 'Thriller', 'Comedy'].map((genre) {
                return ActionChip(
                  label: Text(genre),
                  onPressed: () => context.push('/discover/genre/$genre'),
                );
              }).toList(),
            ),
            const Spacer(),
            FilledButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Apply Filters'),
            ),
          ],
        ),
      ),
    );
  }
}
