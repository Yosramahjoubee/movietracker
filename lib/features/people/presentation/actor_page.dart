import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/contracts/actor_repository.dart';
import '../../../shared/contracts/movie_repository.dart';
import '../../../shared/contracts/fake_data_source.dart';
import '../../../core/widgets/movie_poster_card.dart';

class ActorPage extends ConsumerWidget {
  final String actorId;
  const ActorPage({super.key, required this.actorId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final actorRepo = ref.watch(actorRepositoryProvider);

    return FutureBuilder(
      future: Future.wait<dynamic>([
        actorRepo.getActorById(actorId),
        actorRepo.getActorFilmography(actorId),
      ]),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (!snapshot.hasData) return const Scaffold(body: Center(child: CircularProgressIndicator()));
        final actor = snapshot.data![0] as Actor?;
        final filmography = snapshot.data![1] as List<Movie>;

        if (actor == null) return const Scaffold(body: Center(child: Text('Actor not found')));

        return Scaffold(
          appBar: AppBar(title: Text(actor.name)),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(radius: 48, backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2), child: Text(actor.name[0])),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(actor.name, style: Theme.of(context).textTheme.headlineLarge),
                          Text(actor.role, style: Theme.of(context).textTheme.bodyMedium),
                          Text(actor.birthplace, style: Theme.of(context).textTheme.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(actor.bio, style: Theme.of(context).textTheme.bodyLarge),
                const SizedBox(height: 24),
                Text('Filmography (${filmography.length})', style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                  ),
                  itemCount: filmography.length,
                  itemBuilder: (context, index) {
                    final movie = filmography[index];
                    return MoviePosterCard(
                      title: movie.title,
                      rating: movie.rating,
                      onTap: () => context.push('/movie/${movie.id}'),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
