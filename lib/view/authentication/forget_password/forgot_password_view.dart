import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/localstorage/storage_key.dart';
import 'package:training_plus/core/services/providers.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/image_paths.dart';
import 'package:training_plus/view/authentication/authentication_providers.dart';
import 'package:training_plus/view/authentication/forget_password_otp/forgot_password_otp_view.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class ForgotPasswordView extends ConsumerWidget {
  ForgotPasswordView({super.key});

  final TextEditingController emailController = TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(forgetPasswordControllerProvider);
    final controller = ref.read(forgetPasswordControllerProvider.notifier);

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 40),
              CommonImage(
                imagePath: ImagePaths.resetPasswordImage,
                isAsset: true,
              ),
              const SizedBox(height: 12),
              commonText("Forgot Password?", size: 21, isBold: true),
              const SizedBox(height: 8),
              commonText(
                "No worries, we’ll send you reset\ninstructions",
                size: 14,
                textAlign: TextAlign.center,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 24),

              // Email field
              commonTextfieldWithTitle(
                "Email",
                emailController,
                hintText: "Enter your email",
                keyboardType: TextInputType.emailAddress,
              ),

              const SizedBox(height: 24),

              // Reset Password Button
              commonButton(
                "Reset Password",
                isLoading: state.isLoading,
                onTap: () async {
                  final email = emailController.text.trim();

                  if (email.isEmpty) {
                    commonSnackbar(
                      context: context,
                      title: "Empty",
                      message: "Please enter your email.",
                      backgroundColor: AppColors.error,
                    );
                    return;
                  }

                  try {
                    final response = await controller.forgetPassword(
                      email: email,
                    );

                    if (response != null) {
                      final localStorage = ref.read(localStorageProvider);
                      await localStorage.saveString(
                        StorageKey.token,
                        response.forgetToken,
                      );

                      navigateToPage(
                        context: context,
                        ForgotPasswordOtpView(email: email),
                      );
                      commonSnackbar(
                        context: context,
                        title: "OTP Sent",
                        message: response.message,
                        backgroundColor: AppColors.success,
                      );
                    }
                  } catch (e) {
                    // ❌ Error → Show Snackbar
                    commonSnackbar(
                      context: context,
                      title: "Error",
                      message: e.toString(),
                      backgroundColor: AppColors.error,
                    );
                  }
                },
              ),

              const SizedBox(height: 24),

              // Back to login
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.arrow_back),
                    commonText("  Back to log in", size: 14),
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
