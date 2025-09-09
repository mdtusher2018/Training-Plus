// ignore_for_file: must_be_immutable

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/localstorage/storage_key.dart';
import 'package:training_plus/core/services/providers.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/image_paths.dart';
import 'package:training_plus/view/authentication/authentication_providers.dart';
import 'package:training_plus/view/authentication/create_new_password/create_new_password_view.dart';
import 'package:training_plus/view/authentication/sign_in/sign_in_view.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class ForgotPasswordOtpView extends ConsumerWidget {
  String email;
  ForgotPasswordOtpView({super.key,required this.email});

  final List<TextEditingController> controllers =
      List.generate(6, (index) => TextEditingController());

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
              const SizedBox(height: 40),
              CommonImage(
                imagePath: ImagePaths.forgetPasswordImage,
                isAsset: true,
              ),
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
                          controllers[index], index, context),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Resend OTP
              commonRichText(
                textAlign: TextAlign.center,
                parts: [
                  RichTextPart(
                      text: "Didn’t receive the code? ",
                      color: AppColors.textPrimary,
                      size: 14),
                  RichTextPart(
                    text: "Resend",
                    size: 14,
                    color: AppColors.primary,
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
                    isBold: true,
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Verify OTP Button
              commonButton(
                "Verify OTP",
                isLoading: state.isLoading,
                onTap: () async {
                  String code = controllers.map((c) => c.text).join();

                  if (code.isEmpty) {
                    commonSnackbar(
                        context: context,
                        title: "Empty",
                        message: "Please enter the OTP.",
                        backgroundColor: AppColors.error);
                    return;
                  } else if (code.length < 6) {
                    commonSnackbar(
                        context: context,
                        title: "Invalid",
                        message: "Invalid OTP length.",
                        backgroundColor: AppColors.error);
                    return;
                  }

                  final success = await controller.verifyOtp(code,email);
                  if (success!=null) {
      final localStorage = ref.read(localStorageProvider);
      await localStorage.saveString(StorageKey.token, success.forgetPasswordToken);
                    navigateToPage(
                        context: context,
                        CreateNewPasswordView(email: email,),
                        clearStack: true);
                    commonSnackbar(
                      context: context,
                      title: "Verified",
                      message: "OTP verified successfully",
                      backgroundColor: AppColors.success,
                    );
                  } else {
                    commonSnackbar(
                      context: context,
                      title: "Error",
                      message: "Invalid OTP or expired",
                      backgroundColor: AppColors.error,
                    );
                  }
                },
              ),
              const SizedBox(height: 24),

              // Back to sign in
              GestureDetector(
                onTap: () {
                  navigateToPage(SigninView(),
                      context: context, clearStack: true);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.arrow_back),
                    commonText("  Back to sign in", size: 14)
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
