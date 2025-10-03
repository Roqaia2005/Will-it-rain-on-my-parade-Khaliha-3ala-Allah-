import 'get_weather_states.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raincast/core/networking/weather_service.dart';

class GetWeatherCubit extends Cubit<WeatherState> {
  final WeatherService weatherService;

  GetWeatherCubit({required this.weatherService})
    : super(WeatherInitialState());

  // Fetch probabilities and chart data
  Future<void> fetchWeatherData({
    required String city,
    required int month,
    required int day,
    String variable = "T2M_MAX",
  }) async {
    emit(WeatherLoadingState());
    try {
      // Fetch probabilities
      final probabilities = await weatherService.getProbabilities(
        city: city,
        month: month,
        day: day,
      );

      // Fetch chart data
      final chartData = await weatherService.getChartData(
        city: city,
        month: month,
        day: day,
        variable: variable,
      );

      // Combine results into one state
      emit(
        WeatherLoadedState(weatherData: probabilities, chartData: chartData),
      );
    } catch (e) {
      emit(WeatherFailureState(errorMessage: e.toString()));
    }
  }
}
