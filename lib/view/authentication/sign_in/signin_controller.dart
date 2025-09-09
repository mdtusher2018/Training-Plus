import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/view/authentication/sign_in/signin_model.dart';

class SignInState {
  final bool passwordVisible;
  final bool rememberMe;
  final bool isLoading;

  const SignInState({
    this.passwordVisible = true,
    this.rememberMe = false,
    this.isLoading = false,
  });

  SignInState copyWith({bool? passwordVisible, bool? rememberMe, bool? isLoading}) {
    return SignInState(
      passwordVisible: passwordVisible ?? this.passwordVisible,
      rememberMe: rememberMe ?? this.rememberMe,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class SignInController extends StateNotifier<SignInState> {
  final IApiService apiService;

  SignInController({required this.apiService}) : super(const SignInState());

  void togglePasswordVisibility() {
    state = state.copyWith(passwordVisible: !state.passwordVisible);
  }

  void toggleRememberMe(bool value) {
    state = state.copyWith(rememberMe: value);
  }

  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  /// Sign in API call
  Future<SignInModel?> signIn({
    required String email,
    required String password,
  }) async {
    setLoading(true);

    try {
      final response = await apiService.post(ApiEndpoints.signin, {
        'email': email,
        'password': password,
      });

      if (response['statusCode'] == 200) {
        final signInModel = SignInModel.fromJson(response);
        return signInModel;
      } else {
        // Handle error from API
        throw Exception(response['message'] ?? 'Login failed');
      }
    } catch (e) {

      rethrow;
    } finally {
      setLoading(false);
    }
  }
}
