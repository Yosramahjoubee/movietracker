import 'package:flutter/material.dart';

class PosterPlaceholder extends StatelessWidget {
  final String title;
  final double? width;
  final double? height;

  const PosterPlaceholder({super.key, required this.title, this.width, this.height});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final initials = title.isNotEmpty
        ? title.split(' ').take(2).map((e) => e.isNotEmpty ? e[0] : '').join().toUpperCase()
        : 'MV';

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            colorScheme.surface,
            colorScheme.primary.withValues(alpha: 0.4),
          ],
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: TextStyle(
            color: colorScheme.onPrimary,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
