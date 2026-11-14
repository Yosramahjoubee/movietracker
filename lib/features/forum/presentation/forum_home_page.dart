import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/module_home_scaffold.dart';
import '../../../core/widgets/feature_tile.dart';
import '../../../shared/contracts/auth_service.dart';

class ForumHomePage extends ConsumerWidget {
  const ForumHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    return ModuleHomeScaffold(
      title: 'Community Forum',
      description: 'Talk with the community about your movies.',
      icon: Icons.forum,
      indicators: const [
        {'value': '24', 'label': 'Topics'},
        {'value': '142', 'label': 'Replies'},
        {'value': '3', 'label': 'Unread'},
      ],
      featureTiles: [
        FeatureTile(icon: Icons.topic, title: 'Recent topics', onTap: () => context.push('/forum/topic/ft1')),
        if (user?.isModerator == true)
          FeatureTile(icon: Icons.security, title: 'Moderation queue', onTap: () => context.push('/forum/moderation')),
      ],
      mainButtonText: 'New topic',
      onMainButtonPressed: () => context.push('/forum/topic/ft1'),
    );
  }
}
