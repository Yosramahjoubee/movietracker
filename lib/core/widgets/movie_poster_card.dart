import 'package:flutter/material.dart';
import 'poster_placeholder.dart';
import 'rating_stars.dart';

class MoviePosterCard extends StatelessWidget {
  final String title;
  final double rating;
  final VoidCallback onTap;
  final double width;

  const MoviePosterCard({
    super.key,
    required this.title,
    required this.rating,
    required this.onTap,
    this.width = 120,
  });

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 2 / 3,
              child: PosterPlaceholder(title: title),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600, fontSize: 14),
            ),
            const SizedBox(height: 2),
            RatingStars(rating: rating, size: 12),
          ],
        ),
      ),
    );
  }
}
