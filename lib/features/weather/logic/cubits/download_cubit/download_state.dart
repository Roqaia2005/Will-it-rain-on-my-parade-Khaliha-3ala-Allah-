// download_states.dart
abstract class DownloadState {}

class DownloadInitialState extends DownloadState {}

class DownloadLoadingState extends DownloadState {}

class DownloadSuccessState extends DownloadState {
  final List<int> fileBytes;
  DownloadSuccessState({required this.fileBytes});
}

class DownloadFailureState extends DownloadState {
  final String errorMessage;
  DownloadFailureState({required this.errorMessage});
}
