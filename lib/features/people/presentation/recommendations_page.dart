import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/contracts/recommendation_service.dart';
import '../../../../shared/contracts/fake_data_source.dart';
import '../../../../core/widgets/movie_list_tile.dart';
import 'package:go_router/go_router.dart';

class RecommendationsPage extends ConsumerWidget {
  const RecommendationsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recRepo = ref.watch(recommendationServiceProvider);
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Recommendations for You')),
      body: FutureBuilder<List<RecommendedMovie>>(
        future: recRepo.getRecommendations('user_1'),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final recs = snapshot.data!;
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                color: colorScheme.primary.withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: const Text('Based on your 5-star ratings and favorite genres, here are tailored recommendations just for you.'),
                ),
              ),
              const SizedBox(height: 16),
              ...recs.map((rec) => MovieListTile(
                    title: rec.movie.title,
                    subtitle: 'Match: ${rec.matchScore}% · ${rec.reason}',
                    rating: rec.movie.rating,
                    onTap: () => context.push('/movie/${rec.movie.id}'),
                  )),
            ],
          );
        },
      ),
    );
  }
}
