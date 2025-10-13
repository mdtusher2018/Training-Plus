// view/authentication/after_signup_otp/after_signup_otp_view.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_plus/core/services/localstorage/storage_key.dart';
import 'package:training_plus/core/services/providers.dart';

import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/extention.dart';
import 'package:training_plus/core/utils/image_paths.dart';
import 'package:training_plus/view/authentication/authentication_providers.dart';
import 'package:training_plus/view/personalization/view/Personalization_1.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class AfterSignUpOtpView extends ConsumerWidget {
  final String email;
  AfterSignUpOtpView({super.key,required this.email});

   final List<TextEditingController> controllers =
        List.generate(6, (index) => TextEditingController());

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(afterSignUpOtpControllerProvider);
    final controller = ref.read(afterSignUpOtpControllerProvider.notifier);



    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              commonSizedBox(height: 20),

                 Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: CommonImage(imagePath: ImagePaths.forgetPasswordImage, isAsset: true),
              ),
              commonSizedBox(height: 12),
              commonText("Check your email", size: 21, isBold: true),
              commonSizedBox(height: 8),
              commonText(
                "We sent a password reset link to\n$email",
                size: 14,
                textAlign: TextAlign.center,
                color: AppColors.textSecondary,
              ),
              commonSizedBox(height: 24),

              // OTP input fields
              Row(
                spacing: 8.w,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6,
                  (index) => Expanded(
                    child: buildOTPTextField(
                      controllers[index],
                      index,
                      context,
                                      
                                         
                    ),
                  ),
                ),
              ),
              commonSizedBox(height: 16),

              commonRichText(
                textAlign: TextAlign.center,
                parts: [
                  RichTextPart(
                    text: "Didn’t receive the code? ",
                    color: AppColors.textPrimary,
                    size: 14,
                  ),
                  RichTextPart(
                    text: "Resend",
                    size: 14,
                    color: AppColors.primary,
                    isBold: true,
                    clickRecognized: TapGestureRecognizer()
                      ..onTap = () async {
                        await controller.resendOtp(email: email);
                        commonSnackbar(
                          context: context,
                          title: "Resent",
                          message: "OTP code resent successfully",
                          backgroundColor: AppColors.success,
                        );
                      },
                  ),
                ],
              ),

              commonSizedBox(height: 24),

              // Verify OTP Button
commonButton(
  "Verify OTP",
  isLoading: state.isLoading,
  onTap: () async {
    String otp = controllers.map((c){
      return c.text;}).join();
    try {
      // Call verifyOtp, which now returns AfterSignUpOTPModel
      final response = await controller.verifyOtp(otp);

      // Save accessToken to local storage
      final localStorage = ref.read(localStorageProvider);
      await localStorage.saveString(StorageKey.token, response.accessToken);

      // Show success snackbar
      commonSnackbar(
        context: context,
        title: "Verified",
        message: "OTP verified successfully",
        backgroundColor: AppColors.success,
      );

      // Navigate to next page and clear navigation stack
      context.navigateTo(
        Personalization1(),
        clearStack: true,
      );
    } catch (e) {
      // Extract and show the error message
      final errorMsg = e.toString().replaceAll("Exception: ", "");
      commonSnackbar(
        context: context,
        title: "Invalid",
        message: errorMsg,
        backgroundColor: AppColors.error,
      );
    }
  },
),


              commonSizedBox(height: 24),

              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.arrow_back),
                    commonText("  Back to sign up", size: 14),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
