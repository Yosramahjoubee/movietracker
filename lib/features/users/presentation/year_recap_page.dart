import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

class YearRecapPage extends StatefulWidget {
  final String year;
  const YearRecapPage({super.key, required this.year});

  @override
  State<YearRecapPage> createState() => _YearRecapPageState();
}

class _YearRecapPageState extends State<YearRecapPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              colorScheme.surface,
              colorScheme.primary.withValues(alpha: 0.5),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: LinearProgressIndicator(
                        value: (_currentPage + 1) / 5,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(width: 16),
                    IconButton(
                      icon: Icon(Icons.close, color: colorScheme.onPrimary),
                      onPressed: () => context.pop(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: PageView(
                  controller: _pageController,
                  onPageChanged: (idx) => setState(() => _currentPage = idx),
                  children: [
                    _buildSlide(context, 'Your ${widget.year} Cinema Journey', '24 Movies Watched', Icons.movie),
                    _buildSlide(context, 'Total Time', '48 Hours Immersed', Icons.timer),
                    _buildSlide(context, 'Favorite Genre', 'Sci-Fi (40%)', Icons.auto_awesome),
                    _buildSlide(context, 'Top Rated Film', 'Movie Title 1 (5.0 Stars)', Icons.star),
                    _buildShareSlide(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSlide(BuildContext context, String title, String subtitle, IconData icon) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 80, color: colorScheme.onPrimary),
          const SizedBox(height: 32),
          Text(title, style: textTheme.headlineLarge?.copyWith(fontSize: 28, color: colorScheme.onPrimary), textAlign: TextAlign.center),
          const SizedBox(height: 16),
          Text(subtitle, style: textTheme.bodyLarge?.copyWith(fontSize: 20, color: colorScheme.onPrimary.withValues(alpha: 0.8)), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildShareSlide(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Ready to share your ${widget.year} Recap?', style: textTheme.headlineLarge?.copyWith(color: colorScheme.onPrimary), textAlign: TextAlign.center),
          const SizedBox(height: 32),
          FilledButton(
            onPressed: () {
              Share.share('Check out my ${widget.year} Movie Tracker recap: 24 movies watched, 48 hours in cinema!');
            },
            child: const Text('Share my recap'),
          ),
        ],
      ),
    );
  }
}
