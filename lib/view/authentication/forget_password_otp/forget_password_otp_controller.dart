import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/view/authentication/forget_password_otp/forget_password_otp_model.dart';

class ForgotPasswordOtpState {
  final bool isLoading;

  const ForgotPasswordOtpState({this.isLoading = false});

  ForgotPasswordOtpState copyWith({bool? isLoading}) {
    return ForgotPasswordOtpState(
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class ForgotPasswordOtpController extends StateNotifier<ForgotPasswordOtpState> {
  final IApiService apiService;

  ForgotPasswordOtpController({required this.apiService})
      : super(const ForgotPasswordOtpState());

  void setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  /// Verify OTP API call
 /// Verify OTP and return the model
  Future<ForgetPasswordOtpModel?> verifyOtp(String otp, String email) async {
    log("Entered OTP: $otp");

    if (otp.isEmpty || otp.length < 6) return null;

    setLoading(true);
    try {
      final response = await apiService.post(
        ApiEndpoints.forgetPasswordOTP, // make sure endpoint exists
        {
          "email": email,
          "otp": otp,
          "purpose": "forget-password",
        },
      );

      log("Forgot Password OTP Response: $response");

      if (response["statusCode"] == 200) {
        final otpModel = ForgetPasswordOtpModel.fromJson(response);
        return otpModel; // ✅ return the model
      }

      return null; // ❌ invalid OTP
    } catch (e, st) {
      log("Forgot Password OTP verification failed", error: e, stackTrace: st);
      return null;
    } finally {
      setLoading(false);
    }
  }
  /// Resend OTP API call (optional)
  Future<void> resendOtp(String email) async {
    setLoading(true);
    try {
      final response = await apiService.post(
        ApiEndpoints.forgetPassword,
        {"email": email},
      );
      log("Resend OTP Response: $response");
    } catch (e, st) {
      log("Resend OTP failed", error: e, stackTrace: st);
    } finally {
      setLoading(false);
    }
  }
}
