import 'dart:io';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';

class RunningGpsState {
  final bool isLoading;
  final String? error;

  RunningGpsState({
    this.isLoading = false,

    this.error,
  });

  RunningGpsState copyWith({
    bool? isLoading,
    String? error,
  }) {
    return RunningGpsState(
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}


class RunningGpsController extends StateNotifier<RunningGpsState> {
  final IApiService apiService;

  RunningGpsController({required this.apiService})
      : super(RunningGpsState());

  /// Post GPS data
  Future<Map<String, dynamic>> postRunningData({
  required Map<String, dynamic> body,
  required File image,
}) async {
  try {
    state = state.copyWith(isLoading: true, error: null);

    final response = await apiService.multipart(
      ApiEndpoints.runningGps,
      body: body,
      method: "POST",
      files: {"image": image},
    );

    if (response != null && response["statusCode"] == 201) {
      state = state.copyWith(isLoading: false);
      return {
        "success": true,
        "message": response["message"] ?? "Run saved successfully",
      };
    } else {
      final errorMessage = response?["message"] ?? "Failed to post running data";
      state = state.copyWith(isLoading: false, error: errorMessage);

      return {
        "success": false,
        "message": errorMessage,
      };
    }
  } catch (e) {
    final errorMessage = e.toString();
    state = state.copyWith(isLoading: false, error: errorMessage);

    return {
      "success": false,
      "message": errorMessage,
    };
  }
}


void shareRunningData(){
  apiService.get(ApiEndpoints.shareRunning);
}

}
