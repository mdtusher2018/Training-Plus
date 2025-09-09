
import 'dart:developer';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';

class AfterSignUpOtpState {
  final bool isLoading;
  final bool isResend;


  const AfterSignUpOtpState({
    this.isLoading = false,
    this.isResend=false
  });

  AfterSignUpOtpState copyWith({
    bool? isLoading,
    bool? isResend,
  }) {
    return AfterSignUpOtpState(
      isLoading: isLoading ?? this.isLoading,
      isResend: isResend ?? this.isResend,
   
    );
  }
}


class AfterSignUpOtpController extends StateNotifier<AfterSignUpOtpState> {
  AfterSignUpOtpController({required this.apiService}) : super(const AfterSignUpOtpState());

IApiService apiService;

  /// Simulate resend OTP
Future<bool> resendOtp({required String email}) async {
  state = state.copyWith(isLoading: true, isResend: true);
  try {
    final response = await apiService.post(ApiEndpoints.resendOtp, {"email": email});
    log("Resend OTP Response: $response");
    state = state.copyWith(isLoading: false);
    if (response["statusCode"] == 200) {
      return true;
    }
    return false;
  } catch (e, st) {
    log("Resend OTP failed", error: e, stackTrace: st);
    state = state.copyWith(isLoading: false);
    return false;
  }
}


/// Verify OTP
Future<bool> verifyOtp(String otp) async {
  log("Entered OTP: $otp");

  if (otp.isEmpty || otp.length < 6) {
    return false;
  }

  state = state.copyWith(isLoading: true);

  try {
    
    final response = await apiService.post(
      ApiEndpoints.afterSignupOtp,
      {
        "otp": otp,
        "purpose":(state.isResend)?"resend-otp" : "email-verification",
      },
   
    );

    log("OTP Verification Response: $response");

    state = state.copyWith(isLoading: false);

    if (response["statusCode"] == 200 || response["statusCode"] == 201) {
      return true; // ✅ OTP verified successfully
    } else {
      return false; // ❌ OTP invalid / expired
    }
  } catch (e, st) {
    log("OTP verification failed", error: e, stackTrace: st);
    state = state.copyWith(isLoading: false);
    return false;
  }
}

}


