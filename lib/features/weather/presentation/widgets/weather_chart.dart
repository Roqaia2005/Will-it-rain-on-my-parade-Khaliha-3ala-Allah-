import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class WeatherChart extends StatelessWidget {
  final Map<String, dynamic>? chartData;
  final Color? lineColor;

  const WeatherChart({super.key, required this.chartData, this.lineColor});

  @override
  Widget build(BuildContext context) {
    if (chartData == null) return const SizedBox();

    final labels = (chartData!['labels'] as List?)?.cast<String>();
    final datasets = (chartData!['datasets'] as List?)
        ?.cast<Map<String, dynamic>>();

    if (labels == null || datasets == null || datasets.isEmpty) {
      return const SizedBox();
    }

    final dataset = (datasets[0]['data'] as List?)?.cast<num>();
    if (dataset == null) return const SizedBox();

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.all(16),
      color: isDark ? const Color(0xFF1A252F) : Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          height: 250,
          child: LineChart(
            LineChartData(
              backgroundColor: Colors.transparent,
              gridData: FlGridData(
                show: true,
                drawVerticalLine: true,
                horizontalInterval: 5,
                verticalInterval: (labels.length / 5).ceilToDouble(),
                getDrawingHorizontalLine: (value) => FlLine(
                  color: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.1),
                  strokeWidth: 1,
                ),
                getDrawingVerticalLine: (value) => FlLine(
                  color: isDark
                      ? Colors.white.withOpacity(0.1)
                      : Colors.black.withOpacity(0.1),
                  strokeWidth: 1,
                ),
              ),
              titlesData: FlTitlesData(
                leftTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: 5,
                    getTitlesWidget: (value, meta) => Text(
                      value.toInt().toString(),
                      style: TextStyle(
                        fontSize: 11,
                        color: isDark ? Colors.white70 : Colors.black87,
                      ),
                    ),
                  ),
                ),
                bottomTitles: AxisTitles(
                  sideTitles: SideTitles(
                    showTitles: true,
                    interval: (labels.length / 5).ceilToDouble(),
                    getTitlesWidget: (value, meta) {
                      final index = value.toInt();
                      return SideTitleWidget(
                        meta: meta,
                        child: Text(
                          index >= 0 && index < labels.length
                              ? labels[index]
                              : '',
                          style: const TextStyle(fontSize: 10),
                        ),
                      );
                    },
                  ),
                ),
                rightTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
                topTitles: const AxisTitles(
                  sideTitles: SideTitles(showTitles: false),
                ),
              ),
              borderData: FlBorderData(show: false),
              lineBarsData: [
                LineChartBarData(
                  spots: List.generate(
                    dataset.length,
                    (i) => FlSpot(i.toDouble(), dataset[i].toDouble()),
                  ),
                  isCurved: true,
                  color: lineColor ?? Colors.blue,
                  barWidth: 3,
                  dotData: FlDotData(show: true),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      colors: [
                        (lineColor ?? theme.primaryColor).withOpacity(0.3),
                        Colors.transparent,
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
