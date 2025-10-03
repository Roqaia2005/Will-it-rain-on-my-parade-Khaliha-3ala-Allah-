abstract class WeatherState {}

class WeatherInitialState extends WeatherState {}

class WeatherLoadingState extends WeatherState {}

class WeatherLoadedState extends WeatherState {
  final Map<String, dynamic> weatherData;
  final Map<String, dynamic>? chartData;

  WeatherLoadedState({required this.weatherData, this.chartData});
}

class WeatherFailureState extends WeatherState {
  final String errorMessage;

  WeatherFailureState({required this.errorMessage});
}
