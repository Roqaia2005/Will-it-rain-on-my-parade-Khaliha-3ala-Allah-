import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

class WeatherService {
  final Dio dio;
  final String baseUrl;

  WeatherService({Dio? dioClient, this.baseUrl = "http://192.168.1.8:8000"})
    : dio = dioClient ?? Dio() {
    dio.interceptors.add(
      PrettyDioLogger(
        requestHeader: true,
        requestBody: true,
        responseBody: true,
        error: true,
        compact: true,
      ),
    );
  }

  // Existing endpoints
  Future<Map<String, dynamic>> getProbabilities({
    required String city,
    required int month,
    required int day,
  }) async {
    final response = await dio.get(
      "$baseUrl/api/weather/probabilities",
      queryParameters: {"city": city, "month": month, "day": day},
    );
    return response.data;
  }

  Future<Map<String, dynamic>> getForecast({required String city}) async {
    final response = await dio.get(
      "$baseUrl/api/weather/forecast",
      queryParameters: {"city": city},
    );
    return response.data;
  }

  // New: Download historical weather data
  Future<Response> downloadWeatherData({
    required String city,
    required int month,
    required int day,
    int startYear = 1980,
    int endYear = 2020,
    String format = "csv", // csv or json
  }) async {
    final response = await dio.get(
      "$baseUrl/api/weather/download",
      queryParameters: {
        "city": city,
        "month": month,
        "day": day,
        "start_year": startYear,
        "end_year": endYear,
        "format": format,
      },
      options: Options(responseType: ResponseType.bytes),
    );
    return response;
  }

  Future<Map<String, dynamic>> getChartData({
    required String city,
    required int month,
    required int day,
    required String variable,
  }) async {
    final response = await dio.get(
      "$baseUrl/api/weather/chart",
      queryParameters: {
        "city": city,
        "month": month,
        "day": day,
        "variable": variable,
      },
    );

    final data = response.data;

    // Extract "chart_data" from response
    final chart = data["chart_data"];

    return {
      "labels": (chart["labels"] as List).map((e) => e.toString()).toList(),
      "datasets": (chart["datasets"] as List).map((ds) {
        return {
          "label": ds["label"],
          "data": (ds["data"] as List)
              .map((v) => (v as num).toDouble())
              .toList(),
        };
      }).toList(),
    };
  }
}
