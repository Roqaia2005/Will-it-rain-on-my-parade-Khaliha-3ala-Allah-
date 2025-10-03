class NasaWeather {
  final DateTime date;
  final double maxTemp;
  final double minTemp;
  final double windSpeed;
  final double precipitation;
  final double humidity;

  NasaWeather({
    required this.date,
    required this.maxTemp,
    required this.minTemp,
    required this.windSpeed,
    required this.precipitation,
    required this.humidity,
  });

  factory NasaWeather.fromJson(
    String date,
    Map<String, dynamic> params,
  ) {
    return NasaWeather(
      date: DateTime.parse(date),
      maxTemp: (params['T2M_MAX']?[date] ?? 0).toDouble(),
      minTemp: (params['T2M_MIN']?[date] ?? 0).toDouble(),
      windSpeed: (params['WS2M']?[date] ?? 0).toDouble(),
      precipitation: (params['PRECTOTCORR']?[date] ?? 0).toDouble(),
      humidity: (params['RH2M']?[date] ?? 0).toDouble(),
    );
  }
}
