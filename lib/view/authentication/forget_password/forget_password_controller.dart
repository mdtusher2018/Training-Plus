import 'package:training_plus/core/base-notifier.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/services/localstorage/i_local_storage_service.dart';
import 'package:training_plus/core/services/localstorage/storage_key.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/core/utils/extention.dart';
import 'package:training_plus/core/utils/global_keys.dart';
import 'package:training_plus/view/authentication/forget_password/forget_password_model.dart';
import 'package:training_plus/view/authentication/forget_password_otp/forgot_password_otp_view.dart';

class ForgetPasswordState {
  final bool isLoading;

  const ForgetPasswordState({this.isLoading = false});

  ForgetPasswordState copyWith({bool? isLoading}) {
    return ForgetPasswordState(isLoading: isLoading ?? this.isLoading);
  }
}

class ForgetPasswordController extends BaseNotifier<ForgetPasswordState> {
  final IApiService apiService;
  final ILocalStorageService localStorageService;

  ForgetPasswordController({
    required this.apiService,
    required this.localStorageService,
  }) : super(const ForgetPasswordState());

  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  /// Forget password API call
  Future<void> forgetPassword({required String email}) async {
    safeCall(
      onStart: () => setLoading(true),
      onComplete: () => setLoading(false),

      task: () async {
        if (email.isEmpty) {
          throw Exception("Please enter your email.");
        }
        final response = await apiService.post(ApiEndpoints.forgetPassword, {
          'email': email,
        });

        if (response['statusCode'] == 200) {
          final result = ForgetPasswordModel.fromJson(response);

          await localStorageService.saveString(
            StorageKey.token,
            result.forgetToken,
          );

          navigatorKey.currentContext?.navigateTo(
            ForgotPasswordOtpView(email: email),
          );
        } else {
          throw Exception(response['message'] ?? 'OTP send failed');
        }
      },
      showErrorSnack: true,
      successMessage: "OTP sent sucessfully",
    );
  }
}
