import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/contracts/movie_repository.dart';
import '../../../shared/contracts/fake_data_source.dart';
import '../../../core/widgets/movie_list_tile.dart';

class GenrePage extends ConsumerWidget {
  final String genreId;
  const GenrePage({super.key, required this.genreId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieRepo = ref.watch(movieRepositoryProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Genre: $genreId')),
      body: FutureBuilder<List<Movie>>(
        future: movieRepo.getMoviesByGenre(genreId),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final movies = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: movies.length,
            itemBuilder: (context, index) {
              final movie = movies[index];
              return MovieListTile(
                title: movie.title,
                subtitle: '${movie.year} · ${movie.genre} · ${movie.duration}',
                rating: movie.rating,
                onTap: () => context.push('/movie/${movie.id}'),
              );
            },
          );
        },
      ),
    );
  }
}
