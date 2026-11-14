import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/contracts/fake_data_source.dart';
import '../../../core/widgets/attribution_footer.dart';

class WhereToWatchPage extends ConsumerWidget {
  const WhereToWatchPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieRepo = ref.watch(movieRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Where to Watch')),
      body: FutureBuilder<List<String>>(
        future: movieRepo.getStreamingProviders('US'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final providers = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              ...providers.map((p) => Card(child: ListTile(title: Text(p), trailing: const Icon(Icons.play_arrow)))),
              const SizedBox(height: 32),
              const AttributionFooter(),
            ],
          );
        },
      ),
    );
  }
}
