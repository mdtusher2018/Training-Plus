import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/view/authentication/forget_password_otp/forget_password_otp_model.dart';

class ForgotPasswordOtpState {
  final bool isLoading;
  final bool isResend;

  const ForgotPasswordOtpState({this.isLoading = false,this.isResend=false});

  ForgotPasswordOtpState copyWith({bool? isLoading,bool? isResend}) {
    return ForgotPasswordOtpState(
      isLoading: isLoading ?? this.isLoading,
      isResend: isResend ?? this.isResend,
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


Future<bool> resendOtp({required String email}) async {
  state = state.copyWith(isLoading: true);
  try {
    final response = await apiService.post(ApiEndpoints.resendOtp, {"email": email});
    log("Resend OTP Response: $response");
    state = state.copyWith(isLoading: false);
    if (response["statusCode"] == 200) {
      state=state.copyWith(isResend: true);
      return true;
    }
    return false;
  } catch (e, st) {
    log("Resend OTP failed", error: e, stackTrace: st);
    state = state.copyWith(isLoading: false);
    return false;
  }
}



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
          "purpose":(state.isResend)?"resend-otp": "forget-password",
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
}
