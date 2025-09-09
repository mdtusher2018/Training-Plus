import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/view/authentication/create_new_password/create_new_password_model.dart';

/// State class
class CreateNewPasswordState {
  final bool isLoading;
  final bool isPasswordVisible;
  final bool isConfirmPasswordVisible;

  const CreateNewPasswordState({
    this.isLoading = false,
    this.isPasswordVisible = true,
    this.isConfirmPasswordVisible = true,
  });

  CreateNewPasswordState copyWith({
    bool? isLoading,
    bool? isPasswordVisible,
    bool? isConfirmPasswordVisible,
  }) {
    return CreateNewPasswordState(
      isLoading: isLoading ?? this.isLoading,
      isPasswordVisible: isPasswordVisible ?? this.isPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
    );
  }
}

/// Controller
class CreateNewPasswordController
    extends StateNotifier<CreateNewPasswordState> {
  final IApiService apiService;

  CreateNewPasswordController({required this.apiService})
      : super(const CreateNewPasswordState());

  /// Toggle password visibility
  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  /// Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    state =
        state.copyWith(isConfirmPasswordVisible: !state.isConfirmPasswordVisible);
  }

  /// Set loading state
  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  /// Reset Password API Call
  Future<CreateNewPasswordModel?> resetPassword({
    required String email,
    required String password,
  }) async {
    setLoading(true);
    try {
      final response = await apiService.post(
        ApiEndpoints.resetPassword, // ✅ create this endpoint
        {
          "email": email,
          "password": password,
  
        },
      );

      log("Reset Password Response: $response");

      if (response != null) {
        return CreateNewPasswordModel.fromJson(response);
      }
      return null;
    } catch (e, st) {
      log("Reset Password failed", error: e, stackTrace: st);
      return null;
    } finally {
      setLoading(false);
    }
  }
}

