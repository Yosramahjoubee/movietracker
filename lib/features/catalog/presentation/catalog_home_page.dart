import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/contracts/movie_repository.dart';
import '../../../shared/contracts/auth_service.dart';
import '../../../shared/contracts/recommendation_service.dart';
import '../../../shared/contracts/fake_data_source.dart';
import '../../../core/widgets/movie_poster_card.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/attribution_footer.dart';
import '../../../core/widgets/avatar_circle.dart';

class CatalogHomePage extends ConsumerWidget {
  const CatalogHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final movieRepo = ref.watch(movieRepositoryProvider);
    final recommendationRepo = ref.watch(recommendationServiceProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            AvatarCircle(name: user?.nickname ?? 'Guest', radius: 18),
            const SizedBox(width: 8),
            Text('Hello, ${user?.nickname ?? 'Guest'}'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/discover/search'),
          ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () => context.push('/discover/history'),
          ),
        ],
      ),
      body: FutureBuilder(
        future: Future.wait<dynamic>([
          movieRepo.getFeaturedMovies(),
          movieRepo.getTrendingMovies(),
          recommendationRepo.getRecommendations(user?.id ?? 'guest'),
        ]),
        builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final featured = snapshot.data![0] as List<Movie>;
          final trending = snapshot.data![1] as List<Movie>;
          final recommendations = snapshot.data![2] as List<RecommendedMovie>;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 200,
                  child: PageView.builder(
                    itemCount: featured.length,
                    itemBuilder: (context, index) {
                      final movie = featured[index];
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16),
                          gradient: LinearGradient(
                            colors: [colorScheme.surface, colorScheme.primary],
                          ),
                        ),
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(movie.title, style: textTheme.headlineMedium?.copyWith(color: colorScheme.onPrimary)),
                            const SizedBox(height: 8),
                            FilledButton(
                              onPressed: () => context.push('/movie/${movie.id}'),
                              child: const Text('Watch trailer / Details'),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildShortcut(context, Icons.auto_awesome, 'For you', () => context.push('/people/for-you')),
                    _buildShortcut(context, Icons.nightlight, 'Tonight', () => context.push('/lists/tonight')),
                    _buildShortcut(context, Icons.people, 'Actors', () => context.push('/people')),
                    _buildShortcut(context, Icons.category, 'Genres', () => context.push('/discover/filters')),
                  ],
                ),
                const SizedBox(height: 24),
                SectionHeader(title: 'Trending', onActionTap: () {}),
                const SizedBox(height: 12),
                SizedBox(
                  height: 210,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: trending.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final movie = trending[index];
                      return MoviePosterCard(
                        title: movie.title,
                        rating: movie.rating,
                        onTap: () => context.push('/movie/${movie.id}'),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
                SectionHeader(title: 'Because you liked...', actionText: 'See all', onActionTap: () {}),
                const SizedBox(height: 12),
                SizedBox(
                  height: 210,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: recommendations.length,
                    separatorBuilder: (context, index) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      final rec = recommendations[index];
                      return MoviePosterCard(
                        title: rec.movie.title,
                        rating: rec.movie.rating,
                        onTap: () => context.push('/movie/${rec.movie.id}'),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 32),
                const AttributionFooter(),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildShortcut(BuildContext context, IconData icon, String label, VoidCallback onTap) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.surface,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: colorScheme.primary),
          ),
          const SizedBox(height: 6),
          Text(label, style: Theme.of(context).textTheme.bodySmall),
        ],
      ),
    );
  }
}
