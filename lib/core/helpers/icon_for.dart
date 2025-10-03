import 'package:flutter/material.dart';

IconData iconFor(String label) {
  switch (label) {
    case "extreme_heat":
    case "moderate_heat":
      return Icons.wb_sunny;
    case "extreme_cold":
    case "moderate_cold":
      return Icons.ac_unit;
    case "high_wind":
    case "very_high_wind":
      return Icons.air;
    case "heavy_rain":
    case "very_heavy_rain":
    case "any_rain":
      return Icons.water_drop;
    case "uncomfortable":
    case "high_humidity":
      return Icons.mood_bad;
    case "clear_sky":
      return Icons.sunny;
    default:
      return Icons.help;
  }
}
