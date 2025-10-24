// ignore_for_file: must_be_immutable

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/extention.dart';
import 'package:training_plus/core/utils/image_paths.dart';
import 'package:training_plus/view/authentication/authentication_providers.dart';
import 'package:training_plus/view/authentication/sign_in/sign_in_view.dart';
import 'package:training_plus/widgets/common_otp_text_field.dart';
import 'package:training_plus/widgets/common_sized_box.dart';
import 'package:training_plus/widgets/common_rich_text.dart';
import 'package:training_plus/widgets/common_text.dart';
import 'package:training_plus/widgets/common_button.dart';
import 'package:training_plus/widgets/common_image.dart';

class ForgotPasswordOtpView extends ConsumerWidget {
  String email;
  ForgotPasswordOtpView({super.key, required this.email});

  final List<TextEditingController> controllers = List.generate(
    6,
    (index) => TextEditingController(),
  );

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(forgotPasswordOtpControllerProvider);
    final controller = ref.read(forgotPasswordOtpControllerProvider.notifier);

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

              // Resend OTP
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
                    clickRecognized:
                        TapGestureRecognizer()
                          ..onTap = () async {
                            await controller.resendOtp(email: email);
                          },
                    isBold: true,
                  ),
                ],
              ),
              CommonSizedBox(height: 24),

              // Verify OTP Button
              CommonButton(
                "Verify OTP",
                isLoading: state.isLoading,
                onTap: () async {
                  String code = controllers.map((c) => c.text).join();
                  await controller.verifyOtp(code, email);
                },
              ),
              CommonSizedBox(height: 24),

              // Back to sign in
              GestureDetector(
                onTap: () {
                  context.navigateTo(SigninView(), clearStack: true);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.arrow_back),
                    CommonText("  Back to sign in", size: 14),
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
