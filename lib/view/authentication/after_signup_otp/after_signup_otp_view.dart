// view/authentication/after_signup_otp/after_signup_otp_view.dart

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/extention.dart';
import 'package:training_plus/core/utils/image_paths.dart';
import 'package:training_plus/view/authentication/authentication_providers.dart';

import 'package:training_plus/widgets/common_widgets.dart';

class AfterSignUpOtpView extends ConsumerWidget {
  final String email;
  AfterSignUpOtpView({super.key, required this.email});

  final List<TextEditingController> controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

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
              CommonSizedBox(height: 20),

              Padding(
                padding: EdgeInsets.symmetric(horizontal: 40.w),
                child: CommonImage(
                  imagePath: ImagePaths.forgetPasswordImage,
                  isAsset: true,
                ),
              ),
              CommonSizedBox(height: 12),
              CommonText("Check your email", size: 21, isBold: true),
              CommonSizedBox(height: 8),
              CommonText(
                "We sent a password reset link to\n$email",
                size: 14,
                textAlign: TextAlign.center,
                color: AppColors.textSecondary,
              ),
              CommonSizedBox(height: 24),

              // OTP input fields
              Row(
                spacing: 8.w,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  6,
                  (index) => Expanded(
                    child: CommonOTPTextField(
                      controllers[index],
                      index,
                      context,
                    ),
                  ),
                ),
              ),
              CommonSizedBox(height: 16),

              CommonRichText(
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
                    clickRecognized:
                        TapGestureRecognizer()
                          ..onTap = () async {
                            await controller.resendOtp(email: email);
                            context.showCommonSnackbar(
                              title: "Resent",
                              message: "OTP code resent successfully",
                              backgroundColor: AppColors.success,
                            );
                          },
                  ),
                ],
              ),

              CommonSizedBox(height: 24),

              // Verify OTP Button
              CommonButton(
                "Verify OTP",
                isLoading: state.isLoading,
                onTap: () async {
                  String otp =
                      controllers.map((c) {
                        return c.text;
                      }).join();

                  await controller.verifyOtp(otp);
                },
              ),

              CommonSizedBox(height: 24),

              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.arrow_back),
                    CommonText("  Back to sign up", size: 14),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
