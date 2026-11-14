import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/contracts/forum_service.dart';
import '../../../shared/contracts/fake_data_source.dart';
import '../../../core/widgets/role_badge.dart';

class ModerationQueuePage extends ConsumerWidget {
  const ModerationQueuePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forumService = ref.watch(forumServiceProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Text('Moderation Queue'),
            const SizedBox(width: 12),
            const RoleBadge(),
          ],
        ),
      ),
      body: FutureBuilder<List<ForumReport>>(
        future: forumService.getModerationReports(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final reports = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: reports.length,
            itemBuilder: (context, index) {
              final report = reports[index];
              return Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Reason: ${report.reason}', style: const TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4),
                      Text('Excerpt: "${report.targetExcerpt}"'),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          FilledButton.icon(
                            style: FilledButton.styleFrom(backgroundColor: colorScheme.primary),
                            icon: const Icon(Icons.delete),
                            label: const Text('Delete'),
                            onPressed: () {},
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed: () {},
                            child: const Text('Hide'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
