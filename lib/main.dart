import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raincast/core/helpers/theme_provider.dart';
import 'package:raincast/core/networking/weather_service.dart';
import 'package:raincast/features/weather/presentation/welcome_screen.dart';
import 'package:raincast/features/weather/logic/cubits/download_cubit/download_cubit.dart';
import 'package:raincast/features/weather/logic/cubits/get_weather_cubit/get_weather_cubit.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => GetWeatherCubit(weatherService: WeatherService()),
        ),
        BlocProvider(
          create: (_) => DownloadCubit(weatherService: WeatherService()),
        ),
      ],
      child: MaterialApp(
        title: 'WeatherWise',
        theme: ThemeData.light(),
        darkTheme: ThemeData.dark(),
        themeMode: themeProvider.themeMode,
        home: WeatherWiseWelcomeScreen(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
