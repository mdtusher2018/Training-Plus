// view/authentication/sign_up/signup_controller.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/view/authentication/signup/signup_model.dart';

class SignUpState {
  final bool passwordVisible;
  final bool confirmPasswordVisible;
  final bool isLoading;

  const SignUpState({
    this.passwordVisible = true,
    this.confirmPasswordVisible = true,
    this.isLoading = false,
  });

  SignUpState copyWith({
    bool? passwordVisible,
    bool? confirmPasswordVisible,
    bool? isLoading,
  }) {
    return SignUpState(
      passwordVisible: passwordVisible ?? this.passwordVisible,
      confirmPasswordVisible: confirmPasswordVisible ?? this.confirmPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class SignUpController extends StateNotifier<SignUpState> {
  final IApiService apiService;

  SignUpController({required this.apiService}) : super(const SignUpState());

  void togglePasswordVisibility() {
    state = state.copyWith(passwordVisible: !state.passwordVisible);
  }

  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(confirmPasswordVisible: !state.confirmPasswordVisible);
  }

  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  Future<SignUpModel?> signUp({
    required String fullName,
    required String email,
    required String password,
    String? referralCode,
  }) async {
    setLoading(true);
    try {
      final response = await apiService.post(ApiEndpoints.signup, {
        'fullName': fullName,
        'email': email,
        'password': password,
        'referralCode': referralCode,
      });

      if (response['statusCode'] == 201) {
        return SignUpModel.fromJson(response);
        
      } else {
        throw Exception(response['message'] ?? 'Signup failed');
      }
    } catch (e) {
      rethrow;
    } finally {
      setLoading(false);
    }
  }
}
