import 'dart:developer';
import 'package:training_plus/core/base-notifier.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/services/localstorage/i_local_storage_service.dart';
import 'package:training_plus/core/services/localstorage/storage_key.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/core/utils/extention.dart';
import 'package:training_plus/core/utils/global_keys.dart';
import 'package:training_plus/view/authentication/create_new_password/create_new_password_view.dart';
import 'package:training_plus/view/authentication/forget_password_otp/forget_password_otp_model.dart';

class ForgotPasswordOtpState {
  final bool isLoading;
  final bool isResend;

  const ForgotPasswordOtpState({this.isLoading = false, this.isResend = false});

  ForgotPasswordOtpState copyWith({bool? isLoading, bool? isResend}) {
    return ForgotPasswordOtpState(
      isLoading: isLoading ?? this.isLoading,
      isResend: isResend ?? this.isResend,
    );
  }
}

class ForgotPasswordOtpController extends BaseNotifier<ForgotPasswordOtpState> {
  final IApiService apiService;
  final ILocalStorageService localStorageService;

  ForgotPasswordOtpController({
    required this.apiService,
    required this.localStorageService,
  }) : super(const ForgotPasswordOtpState());

  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  Future<void> resendOtp({required String email}) async {
    safeCall(
      onStart: () => setLoading(true),
      onComplete: () => setLoading(false),
      task: () async {
        final response = await apiService.post(ApiEndpoints.resendOtp, {
          "email": email,
        });
        log("Resend OTP Response: $response");
        state = state.copyWith(isLoading: false);
        if (response["statusCode"] == 200) {
          state = state.copyWith(isResend: true);
        }
      },
      showSuccessSnack: true,
      successMessage: "OTP code resent successfully",
    );
  }

  Future<void> verifyOtp(String otp, String email) async {
    safeCall(
      onStart: () => setLoading(true),
      onComplete: () => setLoading(false),

      task: () async {
        if (otp.isEmpty) {
          throw Exception("Please enter the OTP.");
        }
        if (otp.length < 6) {
          throw Exception("Invalid OTP length.\nOTP must be 6 digit");
        }

        final response = await apiService.post(ApiEndpoints.forgetPasswordOTP, {
          "otp": otp,
          "purpose": (state.isResend) ? "resend-otp" : "forget-password",
        });

        log("Forgot Password OTP Response: $response");

        if (response["statusCode"] == 200) {
          final success = ForgetPasswordOtpModel.fromJson(response);

          await localStorageService.saveString(
            StorageKey.token,
            success.forgetPasswordToken,
          );
          navigatorKey.currentContext?.navigateTo(
            CreateNewPasswordView(email: email),
            clearStack: true,
          );
        }
      },
      showSuccessSnack: true,
      successMessage: "OTP verified successfully",
    );
  }
}
