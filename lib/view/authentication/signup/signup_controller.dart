import 'package:training_plus/core/base-notifier.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/services/localstorage/i_local_storage_service.dart';
import 'package:training_plus/core/services/localstorage/storage_key.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/core/utils/extention.dart';
import 'package:training_plus/core/utils/global_keys.dart';
import 'package:training_plus/view/authentication/after_signup_otp/after_signup_otp_view.dart';
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
      confirmPasswordVisible:
          confirmPasswordVisible ?? this.confirmPasswordVisible,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class SignUpController extends BaseNotifier<SignUpState> {
  final IApiService apiService;
  final ILocalStorageService localStorageService;
  SignUpController({
    required this.apiService,
    required this.localStorageService,
  }) : super(const SignUpState());

  void togglePasswordVisibility() {
    state = state.copyWith(passwordVisible: !state.passwordVisible);
  }

  void toggleConfirmPasswordVisibility() {
    state = state.copyWith(
      confirmPasswordVisible: !state.confirmPasswordVisible,
    );
  }

  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  Future<void> signUp({
    required String fullName,
    required String email,
    required String password,
    String? referralCode,
  }) async {
    safeCall(
      onStart: () => setLoading(true),
      onComplete: () => setLoading(false),
      task: () async {
        final response = await apiService.post(ApiEndpoints.signup, {
          'fullName': fullName,
          'email': email,
          'password': password,
          'referralCode': referralCode,
        });

        if (response['statusCode'] == 201) {
          final result = SignUpModel.fromJson(response);

          await localStorageService.saveString(
            StorageKey.token,
            result.signUpToken,
          );
          navigatorKey.currentContext?.navigateTo(
            AfterSignUpOtpView(email: email),
          );
        } else {
          throw Exception(response['message'] ?? 'Signup failed');
        }
      },
    );
  }
}
