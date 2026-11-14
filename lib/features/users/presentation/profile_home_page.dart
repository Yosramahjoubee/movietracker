import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/module_home_scaffold.dart';
import '../../../core/widgets/feature_tile.dart';
import '../../../shared/contracts/auth_service.dart';
import '../../../shared/contracts/fake_data_source.dart';

class ProfileHomePage extends ConsumerWidget {
  const ProfileHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final reviewService = ref.watch(reviewServiceProvider);

    return FutureBuilder<Map<String, dynamic>>(
      future: reviewService.getUserStats(user?.id ?? 'user_1'),
      builder: (context, snapshot) {
        final stats = snapshot.data ?? {'moviesWatched': 24, 'hoursWatched': 48, 'favoriteGenre': 'Sci-Fi'};

        return ModuleHomeScaffold(
          title: 'Profile & Stats',
          description: 'Your movie-lover profile: stats, yearly recap and settings.',
          icon: Icons.person,
          indicators: [
            {'value': '${stats['moviesWatched']}', 'label': 'Watched'},
            {'value': '${stats['hoursWatched']}h', 'label': 'Hours'},
            {'value': '${stats['favoriteGenre']}', 'label': 'Favorite Genre'},
          ],
          featureTiles: [
            FeatureTile(icon: Icons.person_outline, title: 'My profile', onTap: () => context.push('/profile/me')),
            FeatureTile(icon: Icons.dashboard_outlined, title: 'Dashboard', onTap: () => context.push('/profile/stats')),
            FeatureTile(icon: Icons.movie_outlined, title: 'Yearly recap', onTap: () => context.push('/profile/recap/2026')),
            FeatureTile(icon: Icons.settings_outlined, title: 'Settings', onTap: () => context.push('/profile/settings')),
            FeatureTile(
              icon: Icons.delete_forever,
              title: 'Delete my account',
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Delete Account'),
                    content: const Text('Are you sure you want to delete your account? This action cannot be undone.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
                      FilledButton(
                        onPressed: () {
                          Navigator.pop(context);
                          ref.read(authServiceProvider).signOut();
                          context.go('/login');
                        },
                        child: const Text('Delete'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
          mainButtonText: 'See my recap',
          onMainButtonPressed: () => context.push('/profile/recap/2026'),
        );
      },
    );
  }
}
