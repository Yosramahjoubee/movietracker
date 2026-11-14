class ForumMessage {
  final String id;
  final String topicId;
  final String userId;
  final String userNickname;
  final bool isModerator;
  final String content;
  final int likeCount;
  final DateTime timestamp;

  const ForumMessage({
    required this.id,
    required this.topicId,
    required this.userId,
    required this.userNickname,
    this.isModerator = false,
    required this.content,
    this.likeCount = 0,
    required this.timestamp,
  });
}

class ForumTopic {
  final String id;
  final String title;
  final String? movieId;
  final String authorId;
  final String authorNickname;
  final int replyCount;
  final DateTime timestamp;
  final bool isHidden;

  const ForumTopic({
    required this.id,
    required this.title,
    this.movieId,
    required this.authorId,
    required this.authorNickname,
    this.replyCount = 0,
    required this.timestamp,
    this.isHidden = false,
  });
}

class ForumReport {
  final String id;
  final String targetId; // messageId or topicId
  final String targetExcerpt;
  final String reason;
  final String reporterId;
  final int reportCount;
  final String status; // 'pending', 'hidden', 'processed'
  final DateTime timestamp;

  const ForumReport({
    required this.id,
    required this.targetId,
    required this.targetExcerpt,
    required this.reason,
    required this.reporterId,
    this.reportCount = 1,
    this.status = 'pending',
    required this.timestamp,
  });
}

abstract class ForumService {
  Future<List<ForumTopic>> getTopics({String? movieId});
  Future<ForumTopic?> getTopicById(String id);
  Future<void> createTopic(ForumTopic topic);
  Future<List<ForumMessage>> getMessagesForTopic(String topicId);
  Future<bool> postMessage(ForumMessage message, {required int userMessageCountLastMinute});
  Future<void> likeMessage(String messageId);
  Future<void> reportMessage(String targetId, String excerpt, String reason, String reporterId);
  Future<List<ForumReport>> getModerationReports();
  Future<void> updateReportStatus(String reportId, String status);
}
