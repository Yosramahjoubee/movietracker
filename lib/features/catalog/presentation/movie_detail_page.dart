import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';
import '../../../shared/contracts/movie_repository.dart';
import '../../../shared/contracts/review_service.dart';
import '../../../shared/contracts/fake_data_source.dart';
import '../../../core/widgets/rating_stars.dart';
import '../../../core/widgets/spoiler_banner.dart';

class MovieDetailPage extends ConsumerWidget {
  final String movieId;
  const MovieDetailPage({super.key, required this.movieId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieRepo = ref.watch(movieRepositoryProvider);
    final watchlistService = ref.watch(watchlistServiceProvider);
    final reviewService = ref.watch(reviewServiceProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return FutureBuilder(
      future: Future.wait<dynamic>([
        movieRepo.getMovieById(movieId),
        reviewService.getReviewsForMovie(movieId),
      ]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (!snapshot.hasData) return const Scaffold(body: Center(child: CircularProgressIndicator()));
        final movie = snapshot.data![0] as Movie?;
        final reviews = snapshot.data![1] as List<Review>;

        if (movie == null) return const Scaffold(body: Center(child: Text('Movie not found')));

        return Scaffold(
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 250,
                pinned: true,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(movie.title),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [colorScheme.surface, colorScheme.primary],
                      ),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: const Icon(Icons.share),
                    onPressed: () => Share.share('Check out ${movie.title} on Movie Tracker!'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.favorite_border),
                    onPressed: () => watchlistService.toggleFavorite('user_1', movie.id),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('${movie.year} · ${movie.genre} · ${movie.duration}', style: textTheme.bodyMedium),
                          const Spacer(),
                          RatingStars(rating: movie.rating),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Text(movie.synopsis, style: textTheme.bodyLarge),
                      const SizedBox(height: 24),
                      Row(
                        children: [
                          Expanded(
                            child: FilledButton(
                              onPressed: () => context.push('/journal/review/${movie.id}'),
                              child: const Text('Mark as watched'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () => watchlistService.toggleWatchlist('user_1', movie.id),
                              child: const Text('To watch'),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      Text('Reviews (${reviews.length})', style: textTheme.headlineMedium),
                      const SizedBox(height: 12),
                      ...reviews.map((r) => Card(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(r.userNickname, style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                                      const Spacer(),
                                      RatingStars(rating: r.rating, size: 12),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  r.containsSpoiler
                                      ? SpoilerBanner(child: Text(r.content))
                                      : Text(r.content),
                                ],
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
