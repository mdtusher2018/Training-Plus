import 'package:training_plus/core/base-notifier.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/core/utils/extention.dart';
import 'package:training_plus/core/utils/global_keys.dart';
import 'package:training_plus/view/authentication/create_new_password/create_new_password_model.dart';
import 'package:training_plus/view/authentication/sign_in/sign_in_view.dart';

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
class CreateNewPasswordController extends BaseNotifier<CreateNewPasswordState> {
  final IApiService apiService;

  CreateNewPasswordController({required this.apiService})
    : super(const CreateNewPasswordState());

  /// Toggle password visibility
  void togglePasswordVisibility() {
    state = state.copyWith(isPasswordVisible: !state.isPasswordVisible);
  }

  /// Toggle confirm password visibility
  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(
      isConfirmPasswordVisible: !state.isConfirmPasswordVisible,
    );
  }

  /// Set loading state
  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  /// Reset Password API Call
  Future<void> resetPassword({
    required String email,
    required String password,
  }) async {
    safeCall(
      onStart: () => setLoading(true),
      onComplete: () => setLoading(false),
      task: () async {
        final response = await apiService.post(ApiEndpoints.resetPassword, {
          "email": email,
          "password": password,
        });

        if (response != null) {
          final result = CreateNewPasswordModel.fromJson(response);

          if (result.statusCode == 200) {
            navigatorKey.currentContext?.navigateTo(
              SigninView(),
              clearStack: true,
            );
          } else {
            throw Exception(result.message);
          }
        }
      },
      showSuccessSnack: true,
      successMessage: "Password reset successful",
    );
  }
}
