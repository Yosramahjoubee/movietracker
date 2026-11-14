import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/contracts/auth_service.dart';
import '../../../shared/contracts/watchlist_service.dart';
import '../../../shared/contracts/fake_data_source.dart';
import '../../../core/widgets/movie_list_tile.dart';

class ListsHomePage extends ConsumerWidget {
  const ListsHomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final watchlistService = ref.watch(watchlistServiceProvider);

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Lists & Watchlist'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'To Watch'),
              Tab(text: 'Favorites'),
              Tab(text: 'Custom Lists'),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.nightlight),
              onPressed: () => context.push('/lists/tonight'),
            ),
          ],
        ),
        body: TabBarView(
          children: [
            FutureBuilder<List<String>>(
              future: watchlistService.getWatchlist(user?.id ?? 'user_1'),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final list = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return MovieListTile(
                      title: 'Movie ${list[index]}',
                      subtitle: '2024 · Sci-Fi · 2h',
                      rating: 4.5,
                      onTap: () => context.push('/movie/${list[index]}'),
                    );
                  },
                );
              },
            ),
            FutureBuilder<List<String>>(
              future: watchlistService.getFavorites(user?.id ?? 'user_1'),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final list = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return MovieListTile(
                      title: 'Movie ${list[index]}',
                      subtitle: '2024 · Sci-Fi · 2h',
                      rating: 4.8,
                      onTap: () => context.push('/movie/${list[index]}'),
                    );
                  },
                );
              },
            ),
            FutureBuilder<List<CustomList>>(
              future: watchlistService.getCustomLists(user?.id ?? 'user_1'),
              builder: (context, snapshot) {
                if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
                final lists = snapshot.data!;
                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: lists.length,
                  itemBuilder: (context, index) {
                    final cl = lists[index];
                    return Card(
                      child: ListTile(
                        title: Text(cl.title),
                        subtitle: Text('${cl.movieIds.length} movies'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push('/lists/${cl.id}'),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
