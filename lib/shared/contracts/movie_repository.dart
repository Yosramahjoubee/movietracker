class Movie {
  final String id;
  final String title;
  final int year;
  final String genre;
  final String duration;
  final double rating;
  final String synopsis;
  final List<String> castIds;
  final List<String> streamingProviders;
  final bool isTrending;
  final bool isFeatured;

  const Movie({
    required this.id,
    required this.title,
    required this.year,
    required this.genre,
    required this.duration,
    required this.rating,
    required this.synopsis,
    required this.castIds,
    required this.streamingProviders,
    this.isTrending = false,
    this.isFeatured = false,
  });
}

class SearchHistoryItem {
  final String id;
  final String query;
  final DateTime timestamp;

  const SearchHistoryItem({required this.id, required this.query, required this.timestamp});
}

abstract class MovieRepository {
  Future<List<Movie>> getMovies();
  Future<Movie?> getMovieById(String id);
  Future<List<Movie>> searchMovies(String query, {String? genre, int? year, double? minRating});
  Future<List<Movie>> getTrendingMovies();
  Future<List<Movie>> getFeaturedMovies();
  Future<List<Movie>> getMoviesByGenre(String genre);
  Future<List<SearchHistoryItem>> getSearchHistory();
  Future<void> addSearchHistory(String query);
  Future<void> deleteSearchHistory(String id);
  Future<void> clearSearchHistory();
  Future<List<String>> getStreamingProviders(String country);
}
