import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:raincast/core/helpers/theme_provider.dart';
import 'package:raincast/features/weather/presentation/weather_activity_planner.dart';

class WeatherWiseWelcomeScreen extends StatelessWidget {
  const WeatherWiseWelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.brightness == Brightness.dark
          ? const Color(0xFF101C22) // background-dark
          : const Color(0xFFF6F7F8), // background-light
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const SizedBox(width: 48), // placeholder for alignment
                  const Expanded(
                    child: Text(
                      "WeatherWise",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 48,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                        onPressed: () {
                          // Toggle theme
                          final themeProvider = context.read<ThemeProvider>();
                          themeProvider.toggleTheme();
                        },
                        style: IconButton.styleFrom(
                          shape: const CircleBorder(),
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(40, 40),
                        ),
                        icon: Icon(
                          theme.brightness == Brightness.dark
                              ? Icons.dark_mode
                              : Icons.light_mode,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Main Content
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.wb_cloudy_outlined,
                        color: Color(0xFF13A4EC), // primary
                        size: 96,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        "Plan Your Day, Rain or Shine",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Get accurate weather forecasts tailored for your outdoor activities. "
                        "Know the chances of rain, wind, and more, so you can make the most of your day.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: theme.brightness == Brightness.dark
                              ? Colors.white70
                              : Colors.black.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Footer
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF13A4EC), // primary
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 2,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return WeatherActivityPlannerScreen();
                          },
                        ),
                      );
                    },
                    child: const Text(
                      "Get Started",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // Bottom Navigation
              ],
            ),
          ],
        ),
      ),
    );
  }
}
