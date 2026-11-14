import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/contracts/movie_repository.dart';
import '../../../shared/contracts/fake_data_source.dart';
import '../../../core/widgets/movie_list_tile.dart';

class SearchPage extends ConsumerStatefulWidget {
  const SearchPage({super.key});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  final _searchController = TextEditingController();
  List<Movie> _results = [];
  bool _isLoading = false;

  void _onSearchChanged(String query) async {
    if (query.isEmpty) {
      setState(() => _results = []);
      return;
    }
    setState(() => _isLoading = true);
    await Future.delayed(const Duration(milliseconds: 400));
    final repo = ref.read(movieRepositoryProvider);
    final results = await repo.searchMovies(query);
    await repo.addSearchHistory(query);
    setState(() {
      _results = results;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          onChanged: _onSearchChanged,
          decoration: const InputDecoration(
            hintText: 'Search movies, actors, genres...',
            border: InputBorder.none,
          ),
          autofocus: true,
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _results.length,
              itemBuilder: (context, index) {
                final movie = _results[index];
                return MovieListTile(
                  title: movie.title,
                  subtitle: '${movie.year} · ${movie.genre} · ${movie.duration}',
                  rating: movie.rating,
                  onTap: () => context.push('/movie/${movie.id}'),
                );
              },
            ),
    );
  }
}
