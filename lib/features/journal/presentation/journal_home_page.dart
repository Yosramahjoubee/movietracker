import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/module_home_scaffold.dart';
import '../../../core/widgets/feature_tile.dart';
import '../../../shared/contracts/auth_service.dart';
import '../../../shared/contracts/fake_data_source.dart';

class JournalHomePage extends ConsumerWidget {
  const JournalHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final reviewService = ref.watch(reviewServiceProvider);

    return FutureBuilder<Map<String, dynamic>>(
      future: reviewService.getUserStats(user?.id ?? 'user_1'),
      builder: (context, snapshot) {
        final stats = snapshot.data ?? {'moviesWatched': 12, 'avgRating': 4.5, 'publishedReviews': 5};

        return Scaffold(
          body: ModuleHomeScaffold(
            title: 'Journal',
            description: 'Track your viewings, diary, and published reviews.',
            icon: Icons.book,
            indicators: [
              {'value': '${stats['moviesWatched']}', 'label': 'This Month'},
              {'value': '${stats['avgRating']?.toStringAsFixed(1) ?? '4.5'}', 'label': 'Avg Rating'},
              {'value': '${stats['publishedReviews']}', 'label': 'Reviews'},
            ],
            featureTiles: [
              FeatureTile(icon: Icons.calendar_month, title: 'Monthly Calendar', onTap: () {}),
              FeatureTile(icon: Icons.list, title: 'Latest Viewings', onTap: () {}),
            ],
            mainButtonText: 'Log a viewing',
            onMainButtonPressed: () => context.push('/journal/review/m1'),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => context.push('/journal/review/m1'),
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
