import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/view/profile/settings/change_password/change_password_model.dart';

class ChangePasswordState {
  final bool isCurrentPasswordVisible;
  final bool isNewPasswordVisible;
  final bool isConfirmPasswordVisible;
  final bool isLoading;

  const ChangePasswordState({
    this.isLoading = false,
    this.isNewPasswordVisible = false,
    this.isConfirmPasswordVisible = false,
    this.isCurrentPasswordVisible = false,
  });

  ChangePasswordState copyWith({
    bool? isCurrentPasswordVisible,
    bool? isNewPasswordVisible,
    bool? isConfirmPasswordVisible,
    bool? isLoading,
  }) {
    return ChangePasswordState(
      isCurrentPasswordVisible: isCurrentPasswordVisible ?? this.isCurrentPasswordVisible,
      isNewPasswordVisible: isNewPasswordVisible ?? this.isNewPasswordVisible,
      isConfirmPasswordVisible:
          isConfirmPasswordVisible ?? this.isConfirmPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ChangePasswordController extends StateNotifier<ChangePasswordState> {
  final IApiService apiService;

  ChangePasswordController({required this.apiService})
      : super(const ChangePasswordState());

  /// Toggle Old Password Visibility
  void toggleCurrentPasswordVisibility() {
    state = state.copyWith(isCurrentPasswordVisible: !state.isCurrentPasswordVisible);
  }

  /// Toggle New Password Visibility
  void toggleNewPasswordVisibility() {
    state = state.copyWith(isNewPasswordVisible: !state.isNewPasswordVisible);
  }

  /// Toggle Confirm Password Visibility
  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(
        isConfirmPasswordVisible: !state.isConfirmPasswordVisible);
  }

  /// Set Loading
  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  /// Change Password API Call
  Future<ChangePasswordModel?> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    setLoading(true);

    try {
      final response = await apiService.patch(
        ApiEndpoints.changePassword,
        {
          "oldPassword": currentPassword,
          "newPassword": newPassword,
        },
      );

      log("Change Password Response: $response");

      if (response["statusCode"] == 200) {
        return ChangePasswordModel.fromJson(response);
      } else {
        throw Exception(response["message"] ?? "Password change failed");
      }
    } catch (e, st) {
      log("Change Password Error", error: e, stackTrace: st);
      rethrow;
    } finally {
      setLoading(false);
    }
  }
}
