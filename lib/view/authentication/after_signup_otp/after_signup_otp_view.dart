// view/authentication/after_signup_otp/after_signup_otp_view.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/image_paths.dart';
import 'package:training_plus/view/authentication/authentication_providers.dart';
import 'package:training_plus/view/root_view.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class AfterSignUpOtpView extends ConsumerWidget {
  final String email;
  const AfterSignUpOtpView({super.key,required this.email});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(afterSignUpOtpControllerProvider);
    final controller = ref.read(afterSignUpOtpControllerProvider.notifier);

    final List<TextEditingController> controllers =
        List.generate(6, (index) => TextEditingController());

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 40),
              CommonImage(imagePath: ImagePaths.forgetPasswordImage, isAsset: true),
              const SizedBox(height: 12),
              commonText("Check your email", size: 21, isBold: true),
              const SizedBox(height: 8),
              commonText(
                "We sent a password reset link to\nuser@example.com",
                size: 14,
                textAlign: TextAlign.center,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 24),

              // OTP input fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6,
                  (index) => Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4.0),
                      child: buildOTPTextField(
                        controllers[index],
                        index,
                        context,
                  
                     
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

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

              const SizedBox(height: 24),

              // Verify OTP Button
              commonButton(
                "Verify OTP",
                isLoading: state.isLoading,
                onTap: () async {
                  String otp = controllers.map((c) => c.text).join();

                  final verified = await controller.verifyOtp(otp);
                  if (!verified) {
                    commonSnackbar(
                      context: context,
                      title: "Invalid",
                      message: "Please enter a valid OTP.",
                      backgroundColor: AppColors.error,
                    );
                    return;
                  }

                  navigateToPage(context: context, RootView(), clearStack: true);
                  commonSnackbar(
                    context: context,
                    title: "Verified",
                    message: "OTP verified successfully",
                    backgroundColor: AppColors.success,
                  );
                },
              ),

              const SizedBox(height: 24),

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
