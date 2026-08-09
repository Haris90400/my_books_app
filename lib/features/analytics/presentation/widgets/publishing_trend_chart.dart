import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../bloc/analytics_state.dart' show YearBucket;

/// Represents PublishingTrendChart.
class PublishingTrendChart extends StatelessWidget {
  const PublishingTrendChart({super.key, required this.buckets});

  final List<YearBucket> buckets;

  static const _barColor = Color(0xFF2A78D6);

  @override
  Widget build(BuildContext context) {
    if (buckets.isEmpty) {
      return Center(
        child: Text('No publishing data yet', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted)),
      );
    }

    final maxCount = buckets.map((b) => b.count).reduce((a, b) => a > b ? a : b);

    return BarChart(
      BarChartData(
        maxY: (maxCount * 1.2).ceilToDouble(),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: (maxCount / 4).ceilToDouble().clamp(1, double.infinity),
          getDrawingHorizontalLine: (_) => FlLine(color: AppColors.textMuted.withValues(alpha: 0.15), strokeWidth: 1),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= buckets.length) return const SizedBox.shrink();
                return Padding(
                  padding: const EdgeInsets.only(top: 6),
                  // Fixed width + single line + ellipsis: `getTitlesWidget`
                  // gives no width constraint of its own, so an
                  // unconstrained `Text` can bleed into neighboring labels
                  // once there are more than a couple of bars — this is
                  // what "overlap" actually was, independent of how many
                  // buckets there are.
                  child: SizedBox(
                    width: 44,
                    child: Text(
                      buckets[index].label,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textMuted, fontSize: 9),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        barGroups: [
          for (var i = 0; i < buckets.length; i++)
            BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: buckets[i].count.toDouble(),
                  color: _barColor,
                  width: 18,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
