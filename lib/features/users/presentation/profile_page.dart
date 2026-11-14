import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/contracts/auth_service.dart';
import '../../../core/widgets/avatar_circle.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(title: const Text('My Profile')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 24),
            AvatarCircle(name: user?.nickname ?? 'CineMaster', radius: 48),
            const SizedBox(height: 16),
            Text(user?.nickname ?? 'CineMaster', style: textTheme.headlineLarge),
            const SizedBox(height: 4),
            Text(user?.email ?? 'cinephile@movietracker.com', style: textTheme.bodyMedium),
            const SizedBox(height: 32),
            Card(
              child: ListTile(
                leading: const Icon(Icons.star),
                title: const Text('Member Level'),
                trailing: Text('VIP Cinema Lover', style: TextStyle(color: Theme.of(context).colorScheme.primary, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
