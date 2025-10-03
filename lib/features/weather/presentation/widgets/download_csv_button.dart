import 'dart:io';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:raincast/core/theming/text_styles.dart';
import 'package:raincast/features/weather/logic/cubits/download_cubit/download_state.dart';
import 'package:raincast/features/weather/logic/cubits/download_cubit/download_cubit.dart';

class DownloadCSVButton extends StatelessWidget {
  final DateTime? selectedDate;
  final TextEditingController locationController;

  const DownloadCSVButton({
    super.key,
    required this.selectedDate,
    required this.locationController,
  });

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<DownloadCubit, DownloadState>(
      listener: (context, state) async {
        if (state is DownloadSuccessState) {
          final directory = await getTemporaryDirectory();
          final filePath = '${directory.path}/weather_data.csv';
          final file = File(filePath);

          await file.writeAsBytes(state.fileBytes);

          await Share.shareXFiles([
            XFile(filePath),
          ], text: 'Here is your weather data CSV 📊');
        } else if (state is DownloadFailureState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Download failed: ${state.errorMessage}")),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is DownloadLoadingState;

        return ElevatedButton.icon(
          icon: isLoading
              ? const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2,
                  ),
                )
              : const Icon(Icons.download, color: Colors.white),
          label: Text("Download CSV", style: TextStyles.font14White),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          onPressed: isLoading
              ? null
              : () {
                  if (selectedDate == null || locationController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Select date and location first"),
                      ),
                    );
                    return;
                  }
                  context.read<DownloadCubit>().downloadCSV(
                    city: locationController.text,
                    month: selectedDate!.month,
                    day: selectedDate!.day,
                  );
                },
        );
      },
    );
  }
}
