class ApiEndpoints {
  static const String baseUrl =
      'http://206.162.244.133:8041/api/v1/'; // Replace with actual base URL
  static const String baseImageUrl =
      'http://206.162.244.133:8041/'; // Replace with actual base image URL

  //authentication
  static const String signin = "auth/signin";
  static const String signup = "auth/sign-up";

  static const String afterSignupOtp = "auth/verify-email";
  static const String forgetPassword = "auth/forget-password";
  static const String forgetPasswordOTP = "auth/verify-otp";

  static const String resetPassword = "auth/reset-password";
  static const String resendOtp = "auth/resend-otp";
}
