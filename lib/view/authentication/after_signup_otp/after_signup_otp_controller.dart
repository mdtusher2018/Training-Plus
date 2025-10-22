import 'dart:developer';
import 'package:training_plus/core/base-notifier.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/services/localstorage/i_local_storage_service.dart';
import 'package:training_plus/core/services/localstorage/storage_key.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/view/authentication/after_signup_otp/after_signup_otp_model.dart';

class AfterSignUpOtpState {
  final bool isLoading;
  final bool isResend;

  const AfterSignUpOtpState({this.isLoading = false, this.isResend = false});

  AfterSignUpOtpState copyWith({bool? isLoading, bool? isResend}) {
    return AfterSignUpOtpState(
      isLoading: isLoading ?? this.isLoading,
      isResend: isResend ?? this.isResend,
    );
  }
}

class AfterSignUpOtpController extends BaseNotifier<AfterSignUpOtpState> {
  AfterSignUpOtpController({
    required this.apiService,
    required this.localStorageService,
  }) : super(const AfterSignUpOtpState());

  IApiService apiService;
  ILocalStorageService localStorageService;

  // Future<bool> resendOtp({required String email}) async {
  //   state = state.copyWith(isLoading: true);
  //   try {
  //     final response = await apiService.post(ApiEndpoints.resendOtp, {"email": email});
  //     log("Resend OTP Response: $response");
  //     state = state.copyWith(isLoading: false);
  //     if (response["statusCode"] == 200) {
  // state=state.copyWith(isResend: true);
  //       return true;
  //     }
  //     return false;
  //   } catch (e, st) {
  //     log("Resend OTP failed", error: e, stackTrace: st);
  //     state = state.copyWith(isLoading: false);
  //     return false;
  //   }
  // }
  // Future<AfterSignUpOTPModel> verifyOtp(String otp) async {
  //   log("Entered OTP: $otp");
  //   if (otp.isEmpty || otp.length < 6) {
  //     throw Exception("Please enter a valid 6-digit OTP");
  //   }
  //   state = state.copyWith(isLoading: true);
  //   try {
  //     final response = await apiService.post(
  //       ApiEndpoints.afterSignupOtp,
  //       {
  //         "otp": otp,
  //         "purpose": (state.isResend) ? "resend-otp" : "email-verification",
  //       },
  //     );
  //     log("OTP Verification Response: $response");
  //     state = state.copyWith(isLoading: false);
  //     if (response["statusCode"] == 200 || response["statusCode"] == 201) {
  //       // Parse response into model
  //       final model = AfterSignUpOTPModel.fromJson(response);
  //       return model;
  //     } else {
  //       // ❌ Throw API error message
  //       throw Exception(response["message"] ?? "OTP verification failed");
  //     }
  //   } catch (e, st) {
  //     log("OTP verification failed", error: e, stackTrace: st);
  //     state = state.copyWith(isLoading: false);
  //     rethrow; // Pass the exception to the UI
  //   }
  // }

  /// ✅ Resend OTP
  Future<bool> resendOtp({required String email}) async {
    return await safeCall<bool>(
      onStart: () => state = state.copyWith(isLoading: true),
      onComplete: () => state = state.copyWith(isLoading: false),
      task: () async {
        final response = await apiService.post(ApiEndpoints.resendOtp, {
          "email": email,
        });

        log("Resend OTP Response: $response");

        if (response["statusCode"] == 200) {
          state = state.copyWith(isResend: true);
          return true;
        } else {
          throw Exception(response["message"] ?? "Failed to resend OTP");
        }
      },
      showSuccessSnack: true,
      successMessage: "OTP resent successfully!",
    ).then((result) => result ?? false);
  }

  /// ✅ Verify OTP
  Future<void> verifyOtp(String otp) async {
    if (otp.isEmpty || otp.length < 6) {
      throw Exception("Please enter a valid 6-digit OTP");
    }

    return await safeCall(
      onStart: () => state = state.copyWith(isLoading: true),
      onComplete: () => state = state.copyWith(isLoading: false),
      task: () async {
        final response = await apiService.post(ApiEndpoints.afterSignupOtp, {
          "otp": otp,
          "purpose": state.isResend ? "resend-otp" : "email-verification",
        });

        log("OTP Verification Response: $response");

        if (response["statusCode"] == 200 || response["statusCode"] == 201) {
          final model = AfterSignUpOTPModel.fromJson(response);
          await localStorageService.saveString(
            StorageKey.token,
            model.accessToken,
          );
        } else {
          throw Exception(response["message"] ?? "OTP verification failed");
        }
      },
      showSuccessSnack: true,
      successMessage: "OTP verified successfully!",
    );
  }
}
