import 'package:flutter/material.dart';

class CityMap extends StatelessWidget {
  const CityMap({
    super.key,
    required this.longitude,
    required this.latitude,
  });

  final double? longitude;
  final double? latitude;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        "https://static-maps.yandex.ru/1.x/?ll=$longitude,$latitude&z=12&l=map&size=600,300&pt=$longitude,$latitude,pm2rdm",
        height: 180,
        width: double.infinity,
        fit: BoxFit.cover,
      ),
    );
  }
}