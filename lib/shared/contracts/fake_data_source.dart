import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'user_directory.dart';
import 'settings_service.dart';
import 'movie_repository.dart';
import 'review_service.dart';
import 'watchlist_service.dart';
import 'recommendation_service.dart';
import 'actor_repository.dart';
import 'forum_service.dart';

class FakeDataSource {
  static final List<AppUser> users = [
    const AppUser(id: 'user_1', email: 'cinephile@movietracker.com', nickname: 'CineMaster', country: 'US', isModerator: true),
    const AppUser(id: 'user_2', email: 'alice@movietracker.com', nickname: 'AliceMovies', country: 'FR', isModerator: false),
    const AppUser(id: 'user_3', email: 'bob@movietracker.com', nickname: 'BobCritique', country: 'US', isModerator: false),
    const AppUser(id: 'user_4', email: 'claire@movietracker.com', nickname: 'ClaireCinema', country: 'CA', isModerator: false),
    const AppUser(id: 'user_5', email: 'david@movietracker.com', nickname: 'DavidFilm', country: 'UK', isModerator: false),
  ];

  static final List<Actor> actors = [
    const Actor(id: 'actor_1', name: 'Liam Vance', role: 'Lead Actor', birthplace: 'London, UK', bio: 'Award-winning actor known for intense dramatic roles in sci-fi and thriller masterpieces.', movieIds: ['m1', 'm2', 'm5'], isFollowing: true),
    const Actor(id: 'actor_2', name: 'Elena Rostova', role: 'Lead Actress', birthplace: 'Moscow, Russia', bio: 'Internationally acclaimed star of European cinema and Hollywood blockbusters.', movieIds: ['m1', 'm3', 'm8'], isFollowing: true),
    const Actor(id: 'actor_3', name: 'Marcus Sterling', role: 'Supporting Actor', birthplace: 'New York, USA', bio: 'Veteran character actor with over 50 film credits.', movieIds: ['m2', 'm4', 'm6'], isFollowing: false),
    const Actor(id: 'actor_4', name: 'Sophie Laurent', role: 'Lead Actress', birthplace: 'Paris, France', bio: 'Iconic French actress celebrated for her emotional depth and elegance.', movieIds: ['m3', 'm7', 'm9'], isFollowing: false),
    const Actor(id: 'actor_5', name: 'Kenji Sato', role: 'Director & Actor', birthplace: 'Tokyo, Japan', bio: 'Visionary auteur redefining modern action and animation.', movieIds: ['m5', 'm10', 'm11'], isFollowing: true),
    const Actor(id: 'actor_6', name: 'Aria Stark', role: 'Actress', birthplace: 'Sydney, Australia', bio: 'Rising star in sci-fi adventure epics.', movieIds: ['m6', 'm12', 'm13'], isFollowing: false),
    const Actor(id: 'actor_7', name: 'Gabriel Byrne Jr.', role: 'Actor', birthplace: 'Dublin, Ireland', bio: 'Intense dramatic performer.', movieIds: ['m2', 'm14', 'm15'], isFollowing: false),
    const Actor(id: 'actor_8', name: 'Zoe Saldana-Smith', role: 'Actress', birthplace: 'Miami, USA', bio: 'Action royalty and blockbuster queen.', movieIds: ['m1', 'm16', 'm17'], isFollowing: false),
    const Actor(id: 'actor_9', name: 'Omar Sy-Bello', role: 'Actor', birthplace: 'Dakar, Senegal', bio: 'Charismatic leading man of comedy and drama.', movieIds: ['m3', 'm18', 'm19'], isFollowing: false),
    const Actor(id: 'actor_10', name: 'Penelope Cruz-Mendez', role: 'Actress', birthplace: 'Madrid, Spain', bio: 'Legendary Spanish dramatic powerhouse.', movieIds: ['m4', 'm20', 'm21'], isFollowing: false),
    const Actor(id: 'actor_11', name: 'Daniel Kaluuya-Jones', role: 'Actor', birthplace: 'London, UK', bio: 'Groundbreaking psychological thriller icon.', movieIds: ['m5', 'm22', 'm23'], isFollowing: false),
    const Actor(id: 'actor_12', name: 'Florence Pugh-Davies', role: 'Actress', birthplace: 'Oxford, UK', bio: 'Fearless character chameleon.', movieIds: ['m6', 'm23', 'm24'], isFollowing: true),
  ];

  static final List<Movie> movies = List.generate(24, (index) {
    final id = 'm${index + 1}';
    final genres = ['Action', 'Sci-Fi', 'Drama', 'Thriller', 'Comedy', 'Romance', 'Animation', 'Horror'];
    final genre = genres[index % genres.length];
    final year = 2020 + (index % 6);
    final rating = 3.5 + ((index % 15) * 0.1);
    return Movie(
      id: id,
      title: 'Movie Title ${index + 1}: The Epic Saga',
      year: year,
      genre: genre,
      duration: '${1 + (index % 2)}h ${30 + (index * 5) % 30}m',
      rating: rating > 5.0 ? 5.0 : rating,
      synopsis: 'An unforgettable cinematic journey filled with suspense, passion, and breathtaking visuals in Movie Title ${index + 1}. [Spoiler: The hero saves the galaxy at the end].',
      castIds: ['actor_${(index % 12) + 1}', 'actor_${((index + 1) % 12) + 1}'],
      streamingProviders: ['Netflix', 'Apple TV+', 'Disney+', 'Canal+'],
      isTrending: index < 8,
      isFeatured: index < 4,
    );
  });

  static final List<Review> reviews = [
    Review(
      id: 'r1',
      movieId: 'm1',
      userId: 'user_1',
      userNickname: 'CineMaster',
      rating: 5.0,
      content: 'Absolute masterpiece! The direction and score are breathtaking.',
      containsSpoiler: false,
      isRewatch: false,
      helpfulCount: 12,
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Review(
      id: 'r2',
      movieId: 'm1',
      userId: 'user_2',
      userNickname: 'AliceMovies',
      rating: 4.5,
      content: 'Brilliant performances, though the third act was slightly rushed. [Spoiler: The twist ending changed everything.]',
      containsSpoiler: true,
      isRewatch: false,
      helpfulCount: 8,
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
    ),
  ];

  static List<String> watchlist = ['m1', 'm3', 'm5'];
  static List<String> favorites = ['m1', 'm2'];

  static final List<CustomList> customLists = [
    const CustomList(id: 'cl1', title: 'Sci-Fi Masterpieces', userId: 'user_1', movieIds: ['m1', 'm5', 'm12'], isShared: true, memberIds: ['user_1', 'user_2']),
    const CustomList(id: 'cl2', title: 'Feel Good Friday', userId: 'user_1', movieIds: ['m3', 'm7'], isShared: false),
  ];

  static final List<SearchHistoryItem> searchHistory = [
    SearchHistoryItem(id: 'sh1', query: 'Sci-Fi Epic', timestamp: DateTime.now().subtract(const Duration(hours: 3))),
    SearchHistoryItem(id: 'sh2', query: 'Liam Vance', timestamp: DateTime.now().subtract(const Duration(days: 1))),
  ];

  static final List<ForumTopic> topics = [
    ForumTopic(
      id: 'ft1',
      title: 'What was your favorite scene in Movie 1?',
      movieId: 'm1',
      authorId: 'user_1',
      authorNickname: 'CineMaster',
      replyCount: 3,
      timestamp: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    ForumTopic(
      id: 'ft2',
      title: 'General discussion on 2025 cinema releases',
      movieId: null,
      authorId: 'user_2',
      authorNickname: 'AliceMovies',
      replyCount: 5,
      timestamp: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  static final List<ForumMessage> messages = [
    ForumMessage(
      id: 'fm1',
      topicId: 'ft1',
      userId: 'user_1',
      userNickname: 'CineMaster',
      isModerator: true,
      content: 'The opening sequence is unmatched in recent cinema history!',
      likeCount: 5,
      timestamp: DateTime.now().subtract(const Duration(hours: 4)),
    ),
    ForumMessage(
      id: 'fm2',
      topicId: 'ft1',
      userId: 'user_3',
      userNickname: 'BobCritique',
      isModerator: false,
      content: 'Agree 100%! The sound design was out of this world.',
      likeCount: 2,
      timestamp: DateTime.now().subtract(const Duration(hours: 3)),
    ),
  ];

  static final List<ForumReport> reports = [
    ForumReport(
      id: 'fr1',
      targetId: 'fm2',
      targetExcerpt: 'Spamming irrelevant links',
      reason: 'Spam',
      reporterId: 'user_2',
      reportCount: 2,
      status: 'pending',
      timestamp: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ];
}

class FakeUserDirectory implements UserDirectory {
  @override
  Future<List<AppUser>> getAllUsers() async => FakeDataSource.users;

  @override
  Future<AppUser?> getUserById(String id) async {
    try {
      return FakeDataSource.users.firstWhere((u) => u.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<bool> isNicknameUnique(String nickname) async {
    return !FakeDataSource.users.any((u) => u.nickname.toLowerCase() == nickname.toLowerCase());
  }

  @override
  Future<void> updateUser(AppUser user) async {
    final idx = FakeDataSource.users.indexWhere((u) => u.id == user.id);
    if (idx != -1) {
      FakeDataSource.users[idx] = user;
    }
  }
}

class FakeSettingsService implements SettingsService {
  AppSettings _settings = const AppSettings();

  @override
  Future<AppSettings> getSettings() async => _settings;

  @override
  Future<void> updateSettings(AppSettings settings) async {
    _settings = settings;
  }
}

class FakeMovieRepository implements MovieRepository {
  @override
  Future<List<Movie>> getMovies() async => FakeDataSource.movies;

  @override
  Future<Movie?> getMovieById(String id) async {
    try {
      return FakeDataSource.movies.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Movie>> searchMovies(String query, {String? genre, int? year, double? minRating}) async {
    return FakeDataSource.movies.where((m) {
      final matchesQuery = m.title.toLowerCase().contains(query.toLowerCase()) || m.genre.toLowerCase().contains(query.toLowerCase());
      final matchesGenre = genre == null || genre.isEmpty || m.genre.toLowerCase() == genre.toLowerCase();
      final matchesYear = year == null || m.year == year;
      final matchesRating = minRating == null || m.rating >= minRating;
      return matchesQuery && matchesGenre && matchesYear && matchesRating;
    }).toList();
  }

  @override
  Future<List<Movie>> getTrendingMovies() async => FakeDataSource.movies.where((m) => m.isTrending).toList();

  @override
  Future<List<Movie>> getFeaturedMovies() async => FakeDataSource.movies.where((m) => m.isFeatured).toList();

  @override
  Future<List<Movie>> getMoviesByGenre(String genre) async => FakeDataSource.movies.where((m) => m.genre.toLowerCase() == genre.toLowerCase()).toList();

  @override
  Future<List<SearchHistoryItem>> getSearchHistory() async => FakeDataSource.searchHistory;

  @override
  Future<void> addSearchHistory(String query) async {
    if (query.isNotEmpty) {
      FakeDataSource.searchHistory.insert(0, SearchHistoryItem(
        id: 'sh_${DateTime.now().millisecondsSinceEpoch}',
        query: query,
        timestamp: DateTime.now(),
      ));
    }
  }

  @override
  Future<void> deleteSearchHistory(String id) async {
    FakeDataSource.searchHistory.removeWhere((item) => item.id == id);
  }

  @override
  Future<void> clearSearchHistory() async {
    FakeDataSource.searchHistory.clear();
  }

  @override
  Future<List<String>> getStreamingProviders(String country) async {
    return ['Netflix', 'Apple TV+', 'Disney+', 'Canal+', 'Amazon Prime'];
  }
}

class FakeReviewService implements ReviewService {
  @override
  Future<List<Review>> getReviewsForMovie(String movieId) async {
    return FakeDataSource.reviews.where((r) => r.movieId == movieId).toList();
  }

  @override
  Future<List<Review>> getUserReviews(String userId) async {
    return FakeDataSource.reviews.where((r) => r.userId == userId).toList();
  }

  @override
  Future<Review?> getUserReviewForMovie(String userId, String movieId) async {
    try {
      return FakeDataSource.reviews.firstWhere((r) => r.userId == userId && r.movieId == movieId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveReview(Review review) async {
    final idx = FakeDataSource.reviews.indexWhere((r) => r.id == review.id || (r.userId == review.userId && r.movieId == review.movieId));
    if (idx != -1) {
      FakeDataSource.reviews[idx] = review;
    } else {
      FakeDataSource.reviews.add(review);
    }
  }

  @override
  Future<void> deleteReview(String reviewId) async {
    FakeDataSource.reviews.removeWhere((r) => r.id == reviewId);
  }

  @override
  Future<void> markHelpful(String reviewId) async {
    // helpful count increment logic
  }

  @override
  Future<Map<String, dynamic>> getUserStats(String userId) async {
    final userReviews = FakeDataSource.reviews.where((r) => r.userId == userId).toList();
    return {
      'moviesWatched': userReviews.length + 12,
      'hoursWatched': (userReviews.length + 12) * 2,
      'favoriteGenre': 'Sci-Fi',
      'avgRating': userReviews.isNotEmpty ? userReviews.map((r) => r.rating).reduce((a, b) => a + b) / userReviews.length : 4.2,
      'publishedReviews': userReviews.length,
    };
  }
}

class FakeWatchlistService implements WatchlistService {
  @override
  Future<List<String>> getWatchlist(String userId) async => FakeDataSource.watchlist;

  @override
  Future<List<String>> getFavorites(String userId) async => FakeDataSource.favorites;

  @override
  Future<void> toggleWatchlist(String userId, String movieId) async {
    if (FakeDataSource.watchlist.contains(movieId)) {
      FakeDataSource.watchlist.remove(movieId);
    } else {
      FakeDataSource.watchlist.add(movieId);
    }
  }

  @override
  Future<void> toggleFavorite(String userId, String movieId) async {
    if (FakeDataSource.favorites.contains(movieId)) {
      FakeDataSource.favorites.remove(movieId);
    } else {
      FakeDataSource.favorites.add(movieId);
    }
  }

  @override
  Future<List<CustomList>> getCustomLists(String userId) async => FakeDataSource.customLists;

  @override
  Future<void> saveCustomList(CustomList list) async {
    final idx = FakeDataSource.customLists.indexWhere((l) => l.id == list.id);
    if (idx != -1) {
      FakeDataSource.customLists[idx] = list;
    } else {
      FakeDataSource.customLists.add(list);
    }
  }

  @override
  Future<void> deleteCustomList(String listId) async {
    FakeDataSource.customLists.removeWhere((l) => l.id == listId);
  }

  @override
  Future<MovieRecommendationResult?> tonightPicker({required String userId, required int maxDurationMinutes, String? genre}) async {
    final unwrapped = FakeDataSource.movies.where((m) => !FakeDataSource.watchlist.contains(m.id)).toList();
    if (unwrapped.isEmpty) return null;
    final picked = unwrapped.first;
    return MovieRecommendationResult(movieId: picked.id, title: picked.title);
  }
}

class FakeRecommendationService implements RecommendationService {
  @override
  Future<List<RecommendedMovie>> getRecommendations(String userId) async {
    return FakeDataSource.movies.take(5).map((m) => RecommendedMovie(
      movie: m,
      matchScore: 92,
      reason: 'You rated 5 stars in Sci-Fi',
    )).toList();
  }

  @override
  Future<void> excludeRecommendation(String userId, String movieId) async {
    // exclusion logic
  }
}

class FakeActorRepository implements ActorRepository {
  @override
  Future<List<Actor>> getActors() async => FakeDataSource.actors;

  @override
  Future<Actor?> getActorById(String id) async {
    try {
      return FakeDataSource.actors.firstWhere((a) => a.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<Actor>> getFollowedActors(String userId) async => FakeDataSource.actors.where((a) => a.isFollowing).toList();

  @override
  Future<void> toggleFollowActor(String userId, String actorId) async {
    // toggle follow logic
  }

  @override
  Future<List<Movie>> getActorFilmography(String actorId) async {
    final actor = await getActorById(actorId);
    if (actor == null) return [];
    return FakeDataSource.movies.where((m) => actor.movieIds.contains(m.id)).toList();
  }
}

class FakeForumService implements ForumService {
  @override
  Future<List<ForumTopic>> getTopics({String? movieId}) async {
    if (movieId != null) {
      return FakeDataSource.topics.where((t) => t.movieId == movieId).toList();
    }
    return FakeDataSource.topics;
  }

  @override
  Future<ForumTopic?> getTopicById(String id) async {
    try {
      return FakeDataSource.topics.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> createTopic(ForumTopic topic) async {
    FakeDataSource.topics.insert(0, topic);
  }

  @override
  Future<List<ForumMessage>> getMessagesForTopic(String topicId) async {
    return FakeDataSource.messages.where((m) => m.topicId == topicId).toList();
  }

  @override
  Future<bool> postMessage(ForumMessage message, {required int userMessageCountLastMinute}) async {
    if (userMessageCountLastMinute >= 5) {
      return false; // Anti-spam: max 5 messages per minute
    }
    FakeDataSource.messages.add(message);
    return true;
  }

  @override
  Future<void> likeMessage(String messageId) async {
    // like logic
  }

  @override
  Future<void> reportMessage(String targetId, String excerpt, String reason, String reporterId) async {
    FakeDataSource.reports.add(ForumReport(
      id: 'fr_${DateTime.now().millisecondsSinceEpoch}',
      targetId: targetId,
      targetExcerpt: excerpt,
      reason: reason,
      reporterId: reporterId,
      timestamp: DateTime.now(),
    ));
  }

  @override
  Future<List<ForumReport>> getModerationReports() async => FakeDataSource.reports;

  @override
  Future<void> updateReportStatus(String reportId, String status) async {
    // update report status logic
  }
}

// Riverpod Providers for all contracts
final userDirectoryProvider = Provider<UserDirectory>((ref) => FakeUserDirectory());
final settingsServiceProvider = Provider<SettingsService>((ref) => FakeSettingsService());
final movieRepositoryProvider = Provider<MovieRepository>((ref) => FakeMovieRepository());
final reviewServiceProvider = Provider<ReviewService>((ref) => FakeReviewService());
final watchlistServiceProvider = Provider<WatchlistService>((ref) => FakeWatchlistService());
final recommendationServiceProvider = Provider<RecommendationService>((ref) => FakeRecommendationService());
final actorRepositoryProvider = Provider<ActorRepository>((ref) => FakeActorRepository());
final forumServiceProvider = Provider<ForumService>((ref) => FakeForumService());
