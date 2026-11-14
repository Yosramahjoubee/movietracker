import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppNavBar extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AppNavBar({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Container(
            height: 64,
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(32),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(context, 0, Icons.explore_outlined, Icons.explore, 'Discover', '/discover'),
                _buildNavItem(context, 1, Icons.book_outlined, Icons.book, 'Journal', '/journal'),
                _buildNavItem(context, 2, Icons.list_alt_outlined, Icons.list_alt, 'Lists', '/lists'),
                _buildNavItem(context, 3, Icons.forum_outlined, Icons.forum, 'Forum', '/forum'),
                _buildNavItem(context, 4, Icons.person_outline, Icons.person, 'Profile', '/profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(BuildContext context, int index, IconData iconOutlined, IconData iconFilled, String label, String route) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = navigationShell.currentIndex == index;

    return GestureDetector(
      onTap: () => navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          isSelected ? iconFilled : iconOutlined,
          color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
          size: 24,
        ),
      ),
    );
  }
}
