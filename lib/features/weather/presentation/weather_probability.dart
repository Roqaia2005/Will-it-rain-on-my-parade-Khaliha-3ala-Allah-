import 'package:flutter/material.dart';
import 'package:raincast/core/helpers/icon_for.dart';
import 'package:raincast/features/weather/presentation/widgets/weather_chart.dart';

class WeatherProbabilitiesPage extends StatelessWidget {
  final Map<String, dynamic> weatherData;
  final Map<String, dynamic>? chartData;
  final int month;
  final int day;

  const WeatherProbabilitiesPage({
    super.key,
    required this.weatherData,
    required this.month,
    required this.day,
    this.chartData,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final probs = weatherData['probabilities'] as Map<String, dynamic>? ?? {};
    final stats = weatherData['statistics'] as Map<String, dynamic>? ?? {};
    final location = weatherData['location'] ?? '';
    final coordinates = weatherData['coordinates'] ?? {};

    return Scaffold(
      backgroundColor: theme.brightness == Brightness.dark
          ? const Color(0xFF0f172a) // Dark navy
          : const Color(0xFFF9FAFB), // Light grey
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        title: Text(
          "Weather Probabilities",
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.brightness == Brightness.dark
                ? Colors.white
                : Colors.black87,
          ),
        ),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Location Card
          Card(
            color: theme.cardColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            elevation: 3,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: theme.primaryColor.withOpacity(0.15),
                child: Icon(Icons.location_on, color: theme.primaryColor),
              ),
              title: Text(
                location,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Text(
                "${weatherData['years_covered'] ?? ''} | "
                "Data points: ${weatherData['data_points'] ?? ''}",
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.brightness == Brightness.dark
                      ? Colors.grey[400]
                      : Colors.grey[600],
                ),
              ),
              trailing: Text(
                weatherData['target_date'] ?? '',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: theme.primaryColor,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Map preview
          if (coordinates.isNotEmpty)
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                "https://static-maps.yandex.ru/1.x/?ll=${coordinates['lon']},${coordinates['lat']}&z=12&l=map&size=600,300&pt=${coordinates['lon']},${coordinates['lat']},pm2rdm",
                height: 200,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),

          const SizedBox(height: 24),
          Text(
            "🌡 Probabilities",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          // Probability cards
          ...probs.entries.map((entry) {
            final percentage = (entry.value as num).toDouble();
            return Card(
              color: theme.cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 1,
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: theme.primaryColor.withOpacity(0.15),
                      child: Icon(
                        iconFor(entry.key),
                        color: theme.brightness == Brightness.dark
                            ? Colors.white
                            : Colors.blue,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.key.replaceAll("_", " "),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: LinearProgressIndicator(
                              value: percentage / 100,
                              color: theme.primaryColor,
                              backgroundColor:
                                  theme.brightness == Brightness.dark
                                  ? Colors.grey.shade700
                                  : Colors.grey.shade300,
                              minHeight: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      "${percentage.toStringAsFixed(1)}%",
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),

          const SizedBox(height: 28),

          // Chart section
          if (chartData != null) ...[
            Text(
              "📊 Historical Trend",
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Card(
              color: theme.cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: WeatherChart(chartData: chartData),
              ),
            ),
          ],

          const SizedBox(height: 28),

          // Statistics
          Text(
            "📈 Statistics",
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 12),

          ...stats.entries.map((entry) {
            return Card(
              color: theme.cardColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 1,
              margin: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                leading: Icon(
                  Icons.analytics_outlined,
                  color: theme.brightness == Brightness.dark
                      ? Colors.white
                      : Colors.blue,
                ),
                title: Text(
                  entry.key.replaceAll("_", " "),
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  entry.value.toString(),
                  style: theme.textTheme.bodySmall,
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
