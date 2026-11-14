class Review {
  final String id;
  final String movieId;
  final String userId;
  final String userNickname;
  final double rating;
  final String content;
  final bool containsSpoiler;
  final bool isRewatch;
  final int helpfulCount;
  final DateTime timestamp;

  const Review({
    required this.id,
    required this.movieId,
    required this.userId,
    required this.userNickname,
    required this.rating,
    required this.content,
    required this.containsSpoiler,
    required this.isRewatch,
    this.helpfulCount = 0,
    required this.timestamp,
  });
}

abstract class ReviewService {
  Future<List<Review>> getReviewsForMovie(String movieId);
  Future<List<Review>> getUserReviews(String userId);
  Future<Review?> getUserReviewForMovie(String userId, String movieId);
  Future<void> saveReview(Review review);
  Future<void> deleteReview(String reviewId);
  Future<void> markHelpful(String reviewId);
  Future<Map<String, dynamic>> getUserStats(String userId);
}
