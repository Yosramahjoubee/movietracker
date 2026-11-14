import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../../../shared/contracts/auth_service.dart';
import '../../../shared/contracts/fake_data_source.dart';
import '../../../core/widgets/indicator_row.dart';

class StatsDashboardPage extends ConsumerWidget {
  const StatsDashboardPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final reviewService = ref.watch(reviewServiceProvider);
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return FutureBuilder<Map<String, dynamic>>(
      future: reviewService.getUserStats(user?.id ?? 'user_1'),
      builder: (context, snapshot) {
        final stats = snapshot.data ?? {'moviesWatched': 24, 'hoursWatched': 48, 'favoriteGenre': 'Sci-Fi'};

        return Scaffold(
          appBar: AppBar(title: const Text('Stats Dashboard')),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IndicatorRow(stats: [
                  {'value': '${stats['moviesWatched']}', 'label': 'Watched'},
                  {'value': '${stats['hoursWatched']}h', 'label': 'Hours'},
                  {'value': '${stats['avgRating']?.toStringAsFixed(1) ?? '4.2'}', 'label': 'Avg Rating'},
                ]),
                const SizedBox(height: 24),
                Text('Films per Month', style: textTheme.headlineMedium),
                const SizedBox(height: 16),
                SizedBox(
                  height: 200,
                  child: BarChart(
                    BarChartData(
                      barGroups: [
                        BarChartGroupData(x: 1, barRods: [BarChartRodData(toY: 3, color: colorScheme.primary, width: 16)]),
                        BarChartGroupData(x: 2, barRods: [BarChartRodData(toY: 5, color: colorScheme.primary, width: 16)]),
                        BarChartGroupData(x: 3, barRods: [BarChartRodData(toY: 4, color: colorScheme.primary, width: 16)]),
                        BarChartGroupData(x: 4, barRods: [BarChartRodData(toY: 7, color: colorScheme.primary, width: 16)]),
                        BarChartGroupData(x: 5, barRods: [BarChartRodData(toY: 5, color: colorScheme.primary, width: 16)]),
                      ],
                      titlesData: const FlTitlesData(show: false),
                      borderData: FlBorderData(show: false),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Text('Genre Distribution', style: textTheme.headlineMedium),
                const SizedBox(height: 16),
                SizedBox(
                  height: 180,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(value: 40, color: colorScheme.primary, title: 'Sci-Fi', radius: 50),
                        PieChartSectionData(value: 30, color: colorScheme.primary.withValues(alpha: 0.7), title: 'Action', radius: 45),
                        PieChartSectionData(value: 20, color: colorScheme.primary.withValues(alpha: 0.4), title: 'Drama', radius: 40),
                        PieChartSectionData(value: 10, color: colorScheme.primary.withValues(alpha: 0.2), title: 'Other', radius: 35),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: () => context.push('/profile/recap/2026'),
                  child: const Text('See my 2026 recap'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
