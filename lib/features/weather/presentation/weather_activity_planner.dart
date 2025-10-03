import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raincast/core/networking/weather_service.dart';
import 'package:raincast/features/weather/presentation/widgets/city_map.dart';
import 'package:raincast/features/weather/presentation/weather_probability.dart';
import 'package:raincast/features/weather/presentation/widgets/weather_chart.dart';
import 'package:raincast/features/weather/presentation/widgets/input_city_name.dart';
import 'package:raincast/features/weather/presentation/widgets/download_csv_button.dart';
import 'package:raincast/features/weather/presentation/widgets/view_probabilities_button.dart';
import 'package:raincast/features/weather/logic/cubits/get_weather_cubit/get_weather_cubit.dart';
import 'package:raincast/features/weather/logic/cubits/get_weather_cubit/get_weather_states.dart';

class WeatherActivityPlannerScreen extends StatefulWidget {
  const WeatherActivityPlannerScreen({super.key});

  @override
  State<WeatherActivityPlannerScreen> createState() =>
      _WeatherActivityPlannerScreenState();
}

class _WeatherActivityPlannerScreenState
    extends State<WeatherActivityPlannerScreen> {
  DateTime? selectedDate;
  String? locationName;
  double? latitude;
  double? longitude;
  String? selectedVariable = "T2M_MAX";

  final locationController = TextEditingController();
  Map<String, dynamic>? chartData;

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) setState(() => selectedDate = picked);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocProvider(
      create: (_) => GetWeatherCubit(weatherService: WeatherService()),
      child: BlocConsumer<GetWeatherCubit, WeatherState>(
        listener: (context, state) {
          if (state is WeatherLoadedState) {
            // Update chart data
            setState(() {
              latitude = state.weatherData['coordinates']?['lat'];
              longitude = state.weatherData['coordinates']?['lon'];
              locationName = state.weatherData['location'];
              chartData = state.chartData; // only set when non-null
            });

            // Navigate to probabilities page
            if (selectedDate != null && locationController.text.isNotEmpty) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => WeatherProbabilitiesPage(
                    chartData: chartData,
                    weatherData: state.weatherData,
                    month: selectedDate!.month,
                    day: selectedDate!.day,
                  ),
                ),
              );
            }
          } else if (state is WeatherFailureState) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.errorMessage)));
          }
        },
        builder: (context, state) {
          final isLoading = state is WeatherLoadingState;

          return Scaffold(
            backgroundColor: theme.brightness == Brightness.dark
                ? const Color(0xFF101C22)
                : const Color(0xFFF6F7F8),
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: const Text(
                "Weather Planner",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  letterSpacing: -0.5,
                ),
              ),
              centerTitle: true,
            ),
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: ListView(
                children: [
                  // Location Input
                  InputCityName(locationController: locationController),
                  const SizedBox(height: 16),

                  // Date Picker
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                    child: ListTile(
                      leading: const Icon(Icons.calendar_today),
                      title: Text(
                        selectedDate == null
                            ? "Select Day & Month"
                            : DateFormat("dd MMMM").format(selectedDate!),
                        style: theme.textTheme.titleMedium,
                      ),
                      onTap: _pickDate,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Chart Variable Dropdown
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 4,
                      ),
                      child: DropdownButtonFormField<String>(
                        value: selectedVariable,
                        decoration: const InputDecoration(
                          labelText: "Select Variable for Chart",
                          border: InputBorder.none,
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: "T2M_MAX",
                            child: Text("Max Temp"),
                          ),
                          DropdownMenuItem(
                            value: "T2M_MIN",
                            child: Text("Min Temp"),
                          ),
                          DropdownMenuItem(
                            value: "PRECTOTCORR",
                            child: Text("Precipitation"),
                          ),
                          DropdownMenuItem(
                            value: "WS10M",
                            child: Text("Wind Speed"),
                          ),
                          DropdownMenuItem(
                            value: "RH2M",
                            child: Text("Humidity"),
                          ),
                          DropdownMenuItem(
                            value: "ALLSKY_SFC_SW_DWN",
                            child: Text("Solar Radiation"),
                          ),
                          DropdownMenuItem(
                            value: "CLRSKY_DAYS",
                            child: Text("Clear Sky Days"),
                          ),
                          DropdownMenuItem(
                            value: "T2MDEW",
                            child: Text("Dew Point"),
                          ),
                        ],
                        onChanged: (val) =>
                            setState(() => selectedVariable = val),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  if (latitude != null && longitude != null)
                    CityMap(longitude: longitude, latitude: latitude),
                  if (locationName != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "📍 $locationName",
                        style: theme.textTheme.bodyMedium!.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  const SizedBox(height: 24),

                  // Chart
                  if (chartData != null)
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: WeatherChart(chartData: chartData),
                      ),
                    ),

                  if (isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 16),
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
            ),
            bottomNavigationBar: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: ViewProbabilitiesButton(
                      isLoading: isLoading,
                      selectedDate: selectedDate,
                      locationController: locationController,
                      selectedVariable: selectedVariable,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: DownloadCSVButton(
                      selectedDate: selectedDate,
                      locationController: locationController,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
