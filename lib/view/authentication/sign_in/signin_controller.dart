import 'package:training_plus/core/base-notifier.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/services/localstorage/i_local_storage_service.dart';
import 'package:training_plus/core/services/localstorage/storage_key.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/core/utils/extention.dart';
import 'package:training_plus/core/utils/global_keys.dart';
import 'package:training_plus/view/authentication/sign_in/signin_model.dart';
import 'package:training_plus/view/root_view.dart';

class SignInState {
  final bool passwordVisible;
  final bool rememberMe;
  final bool isLoading;

  const SignInState({
    this.passwordVisible = true,
    this.rememberMe = false,
    this.isLoading = false,
  });

  SignInState copyWith({
    bool? passwordVisible,
    bool? rememberMe,
    bool? isLoading,
  }) {
    return SignInState(
      passwordVisible: passwordVisible ?? this.passwordVisible,
      rememberMe: rememberMe ?? this.rememberMe,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class SignInController extends BaseNotifier<SignInState> {
  final IApiService apiService;
  final ILocalStorageService localStorageService;

  SignInController({
    required this.apiService,
    required this.localStorageService,
  }) : super(const SignInState());

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
  Future<void> signIn({required String email, required String password}) async {
    safeCall(
      onStart: () => setLoading(true),
      onComplete: () => setLoading(false),
      task: () async {
        final response = await apiService.post(ApiEndpoints.signin, {
          'email': email,
          'password': password,
        });

        if (response['statusCode'] == 200) {
          final user = SignInModel.fromJson(response);

          await localStorageService.saveString(
            StorageKey.token,
            user.accessToken,
          );
          if (state.rememberMe) {
            await localStorageService.saveLogin(email, password);
          }
          navigatorKey.currentContext?.navigateTo(RootView());
        } else {
          throw Exception(response['message'] ?? 'Login failed');
        }
      },
      successMessage: "login sucessfully",
      showSuccessSnack: true,
    );
  }
}
