import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raincast/core/theming/text_styles.dart';
import 'package:raincast/features/weather/logic/cubits/get_weather_cubit/get_weather_cubit.dart';

class ViewProbabilitiesButton extends StatelessWidget {
  const ViewProbabilitiesButton({
    super.key,
    required this.isLoading,
    required this.selectedDate,
    required this.locationController,
    required this.selectedVariable,
  });

  final bool isLoading;
  final DateTime? selectedDate;
  final TextEditingController locationController;
  final String? selectedVariable;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : const Icon(Icons.visibility, color: Colors.white),
      label: Text("View Probabilities", style: TextStyles.font14White),
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF13A4EC),
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 3,
      ),
      onPressed: isLoading
          ? null
          : () {
              if (selectedDate == null || locationController.text.isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Select date and location")),
                );
                return;
              }
              context.read<GetWeatherCubit>().fetchWeatherData(
                city: locationController.text,
                month: selectedDate!.month,
                day: selectedDate!.day,
                variable: selectedVariable ?? "T2M_MAX",
              );
            },
    );
  }
}
