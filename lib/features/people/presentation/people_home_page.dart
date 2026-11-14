import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/widgets/module_home_scaffold.dart';
import '../../../core/widgets/feature_tile.dart';

class PeopleHomePage extends ConsumerWidget {
  const PeopleHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ModuleHomeScaffold(
      title: 'People & Actors',
      description: 'Discover the actors behind your favorite movies.',
      icon: Icons.people,
      indicators: const [
        {'value': '12', 'label': 'Followed'},
        {'value': '24', 'label': 'Recs'},
        {'value': '5', 'label': 'Announced'},
      ],
      featureTiles: [
        FeatureTile(icon: Icons.auto_awesome, title: 'For you recommendations', onTap: () => context.push('/people/for-you')),
        FeatureTile(icon: Icons.search, title: 'Search an actor', onTap: () => context.push('/people/actor/actor_1')),
        FeatureTile(icon: Icons.favorite, title: 'Followed actors', onTap: () {}),
      ],
      mainButtonText: 'See my recommendations',
      onMainButtonPressed: () => context.push('/people/for-you'),
    );
  }
}
