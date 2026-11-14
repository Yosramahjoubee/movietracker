import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/contracts/forum_service.dart';
import '../../../shared/contracts/auth_service.dart';
import '../../../shared/contracts/fake_data_source.dart';
import '../../../core/widgets/role_badge.dart';

class TopicPage extends ConsumerStatefulWidget {
  final String topicId;
  const TopicPage({super.key, required this.topicId});

  @override
  ConsumerState<TopicPage> createState() => _TopicPageState();
}

class _TopicPageState extends ConsumerState<TopicPage> {
  final _messageController = TextEditingController();

  void _postMessage() async {
    final user = ref.read(currentUserProvider);
    final forumService = ref.read(forumServiceProvider);

    final msg = ForumMessage(
      id: 'fm_${DateTime.now().millisecondsSinceEpoch}',
      topicId: widget.topicId,
      userId: user?.id ?? 'user_1',
      userNickname: user?.nickname ?? 'CineMaster',
      isModerator: user?.isModerator ?? false,
      content: _messageController.text,
      timestamp: DateTime.now(),
    );

    final success = await forumService.postMessage(msg, userMessageCountLastMinute: 0);
    if (!success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Anti-spam: max 5 messages per minute')));
      return;
    }
    _messageController.clear();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final forumService = ref.watch(forumServiceProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Topic Discussion')),
      body: Column(
        children: [
          Expanded(
            child: FutureBuilder<List<ForumMessage>>(
              future: forumService.getMessagesForTopic(widget.topicId),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final messages = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: messages.length,
                  itemBuilder: (context, index) {
                    final msg = messages[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(msg.userNickname, style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)),
                                const SizedBox(width: 8),
                                if (msg.isModerator) const RoleBadge(),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(msg.content, style: textTheme.bodyLarge),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(hintText: 'Write a reply...'),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: _postMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
