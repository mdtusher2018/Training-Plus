import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/services/providers.dart';
import 'package:training_plus/view/authentication/after_signup_otp/after_signup_otp_controller.dart';
import 'package:training_plus/view/authentication/create_new_password/create_new_password_controller.dart';
import 'package:training_plus/view/authentication/forget_password/forget_password_controller.dart';
import 'package:training_plus/view/authentication/forget_password_otp/forget_password_otp_controller.dart';
import 'package:training_plus/view/authentication/sign_in/signin_controller.dart';
import 'package:training_plus/view/authentication/signup/signup_controller.dart';

final StateNotifierProvider<SignInController, SignInState> signInControllerProvider =
    StateNotifierProvider<SignInController, SignInState>((ref) {
  final IApiService apiService = ref.read(apiServiceProvider);
  return SignInController(apiService: apiService);
});

final signUpControllerProvider =
    StateNotifierProvider<SignUpController, SignUpState>((ref) {
  final IApiService apiService = ref.read(apiServiceProvider);
  return SignUpController(apiService: apiService);
});

final afterSignUpOtpControllerProvider =
    StateNotifierProvider<AfterSignUpOtpController, AfterSignUpOtpState>(
       
  (ref) {
    final IApiService apiService = ref.read(apiServiceProvider);
    return AfterSignUpOtpController(apiService: apiService);}
);


final forgetPasswordControllerProvider = StateNotifierProvider<
    ForgetPasswordController, ForgetPasswordState>((ref) {
  final IApiService apiService = ref.read(apiServiceProvider);
  return ForgetPasswordController(apiService: apiService);
});

final forgotPasswordOtpControllerProvider =
    StateNotifierProvider<ForgotPasswordOtpController, ForgotPasswordOtpState>(
  (ref) {
    final IApiService apiService = ref.read(apiServiceProvider);
    return ForgotPasswordOtpController(apiService: apiService);
  },
);

final createNewPasswordControllerProvider =
    StateNotifierProvider<CreateNewPasswordController, CreateNewPasswordState>(
  (ref) { 
    final IApiService apiService=ref.read(apiServiceProvider);
    return CreateNewPasswordController(apiService: apiService);},
);
