import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/dotted_border_card.dart';

class SharedListPage extends ConsumerWidget {
  final String listId;
  const SharedListPage({super.key, required this.listId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: Text('Shared List: $listId')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DottedBorderCard(
            child: Column(
              children: [
                const Text('Invitation Link', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                const Text('https://movietracker.com/invite/shared-list-123'),
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Invitation link copied!')));
                  },
                  child: const Text('Copy Link'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () => context.push('/lists/tonight'),
            child: const Text('What to watch tonight?'),
          ),
        ],
      ),
    );
  }
}
