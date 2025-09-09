import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/view/authentication/forget_password/forget_password_model.dart';

class ForgetPasswordState {
  final bool isLoading;

  const ForgetPasswordState({
    this.isLoading = false,
  });

  ForgetPasswordState copyWith({
    bool? isLoading,
  }) {
    return ForgetPasswordState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ForgetPasswordController extends StateNotifier<ForgetPasswordState> {
  final IApiService apiService;

  ForgetPasswordController({required this.apiService})
      : super(const ForgetPasswordState());

  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  /// Forget password API call
  Future<ForgetPasswordModel?> forgetPassword({
    required String email,
  }) async {
    setLoading(true);

    try {
      final response = await apiService.post(
        ApiEndpoints.forgetPassword,
        {'email': email},
      );

      if (response['statusCode'] == 200) {
        return ForgetPasswordModel.fromJson(response);
      } else {
        // Always throw so UI can catch error
        throw Exception(response['message'] ?? 'OTP send failed');
      }
    } catch (e) {
      // You could also log the error here if needed
      rethrow;
    } finally {
      setLoading(false);
    }
  }
}
