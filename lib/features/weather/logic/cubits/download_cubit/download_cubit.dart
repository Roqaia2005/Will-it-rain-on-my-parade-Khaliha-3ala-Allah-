import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raincast/core/networking/weather_service.dart';
import 'package:raincast/features/weather/logic/cubits/download_cubit/download_state.dart';

// download_cubit.dart

class DownloadCubit extends Cubit<DownloadState> {
  final WeatherService weatherService;

  DownloadCubit({required this.weatherService}) : super(DownloadInitialState());

  Future<void> downloadCSV({
    required String city,
    required int month,
    required int day,
  }) async {
    emit(DownloadLoadingState());
    try {
      final response = await weatherService.downloadWeatherData(
        city: city,
        month: month,
        day: day,
        format: "csv",
      );
      emit(DownloadSuccessState(fileBytes: response.data));
    } catch (e) {
      emit(DownloadFailureState(errorMessage: e.toString()));
    }
  }
}
