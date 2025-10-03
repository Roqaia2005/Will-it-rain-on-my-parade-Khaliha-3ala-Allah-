import 'package:flutter/material.dart';

class InputCityName extends StatelessWidget {
  const InputCityName({
    super.key,
    required this.locationController,
  });

  final TextEditingController locationController;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: TextField(
          controller: locationController,
          decoration: InputDecoration(
            hintText: "Enter city name",
            prefixIcon: const Icon(Icons.location_city),
            border: InputBorder.none,
          ),
        ),
      ),
    );
  }
}