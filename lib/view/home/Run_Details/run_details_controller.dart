import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:crypto/crypto.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/view/home/Run_Details/run_details_view.dart';
import 'package:training_plus/view/home/Run_Details/running_details_model.dart';

import 'package:training_plus/core/utils/global_keys.dart';

/// State class
class RunDetailState {
  final bool isLoading;
  final RunningHistoryAttributes? runData;
  final String? error;

  RunDetailState({this.isLoading = false, this.runData, this.error});

  RunDetailState copyWith({
    bool? isLoading,
    RunningHistoryAttributes? runData,
    String? error,
  }) {
    return RunDetailState(
      isLoading: isLoading ?? this.isLoading,
      runData: runData ?? this.runData,
      error: error,
    );
  }
}

/// Controller
class RunDetailController extends StateNotifier<RunDetailState> {
  final IApiService apiService;

  RunDetailController({required this.apiService}) : super(RunDetailState());

  /// Fetch run detail by runId
  Future<void> fetchRunDetail(String runId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final deviceSignature = await _getDeviceSignature();
log(deviceSignature);
      final response = await apiService.get(
        ApiEndpoints.getSharedRunDataUrl(runId, deviceSignature),
      );

log(response.toString());
      if (response != null && response['statusCode'] == 200) {
        final runDataJson = response['data']['attributes'];
        final runData = RunningHistoryAttributes.fromJson(runDataJson);

        state = state.copyWith(isLoading: false, runData: runData);
        if (state.runData != null) {
          navigatorKey.currentState?.push(
            MaterialPageRoute(
              builder: (_) => RunDetailPage(runData: state.runData!),
            ),
          );
        }
      } else {
        state = state.copyWith(
          isLoading: false,
          error: response?['message'] ?? "Failed to fetch run details",
        );
      }
    } catch (e) {
      log("Error fetching run detail: $e");
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// Get device signature (hashed for uniqueness)
  Future<String> _getDeviceSignature() async {
    final deviceInfo = DeviceInfoPlugin();
    String rawId;

    if (Platform.isAndroid) {
      final androidInfo = await deviceInfo.androidInfo;
      rawId = androidInfo.id;
    } else if (Platform.isIOS) {
      final iosInfo = await deviceInfo.iosInfo;
      rawId = iosInfo.identifierForVendor ?? "unknown";
    } else {
      rawId = "unsupported_platform";
    }

    final bytes = utf8.encode(rawId);
    return sha256.convert(bytes).toString();
  }
}
