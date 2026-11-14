class CustomList {
  final String id;
  final String title;
  final String userId;
  final List<String> movieIds;
  final bool isShared;
  final List<String> memberIds;

  const CustomList({
    required this.id,
    required this.title,
    required this.userId,
    required this.movieIds,
    this.isShared = false,
    this.memberIds = const [],
  });
}

class MovieRecommendationResult {
  final String movieId;
  final String title;
  const MovieRecommendationResult({required this.movieId, required this.title});
}

abstract class WatchlistService {
  Future<List<String>> getWatchlist(String userId);
  Future<List<String>> getFavorites(String userId);
  Future<void> toggleWatchlist(String userId, String movieId);
  Future<void> toggleFavorite(String userId, String movieId);
  Future<List<CustomList>> getCustomLists(String userId);
  Future<void> saveCustomList(CustomList list);
  Future<void> deleteCustomList(String listId);
  Future<MovieRecommendationResult?> tonightPicker({required String userId, required int maxDurationMinutes, String? genre});
}
