// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/image_paths.dart';
import 'package:training_plus/view/authentication/authentication_providers.dart';
import 'package:training_plus/view/authentication/sign_in/sign_in_view.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class CreateNewPasswordView extends ConsumerWidget {
  String email;
  CreateNewPasswordView({super.key, required this.email});

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(createNewPasswordControllerProvider);
    final controller = ref.read(createNewPasswordControllerProvider.notifier);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            children: [
              CommonImage(
                imagePath: ImagePaths.resetPasswordImage,
                isAsset: true,
              ),
              commonSizedBox(height: 16),
              commonText("Create new password", size: 21, isBold: true),
              commonSizedBox(height: 8),
              commonText(
                "Your new password must be different\nto previously used passwords.",
                size: 14,
                textAlign: TextAlign.center,
                color: AppColors.textSecondary,
              ),
              commonSizedBox(height: 32),

              // Password Field
              commonTextfieldWithTitle(
                "Password",
                passwordController,
                hintText: "Enter your password",
                isPasswordVisible: state.isPasswordVisible,
                issuffixIconVisible: true,
                changePasswordVisibility: controller.togglePasswordVisibility,
              ),
              commonSizedBox(height: 16),

              // Confirm Password Field
              commonTextfieldWithTitle(
                "Confirm Password",
                confirmPasswordController,
                hintText: "Enter your password",
                isPasswordVisible: state.isConfirmPasswordVisible,
                issuffixIconVisible: true,
                changePasswordVisibility:
                    controller.toggleConfirmPasswordVisibility,
              ),
              commonSizedBox(height: 30),

              // Continue Button
              commonButton(
                "Continue",
                isLoading: state.isLoading,
                onTap: () async {
                  String password = passwordController.text.trim();
                  String confirmPassword =
                      confirmPasswordController.text.trim();

                  if (password.isEmpty || confirmPassword.isEmpty) {
                    commonSnackbar(
                      context: context,
                      title: "Error",
                      message: "Please fill all the fields",
                      backgroundColor: AppColors.error,
                    );
                    return;
                  }

                  if (password != confirmPassword) {
                    commonSnackbar(
                      context: context,
                      title: "Error",
                      message: "Passwords do not match",
                      backgroundColor: AppColors.error,
                    );
                    return;
                  }

                  // Call API
                  final result = await controller.resetPassword(
                    email: email,
                    password: password,
                  );

                  if (result != null && result.statusCode == 200) {
                    navigateToPage(
                      context: context,
                      SigninView(),
                      clearStack: true,
                    );
                    commonSnackbar(
                      context: context,
                      title: "Success",
                      message: "Password reset successful",
                      backgroundColor: AppColors.success,
                    );
                  } else {
                    commonSnackbar(
                      context: context,
                      title: "Error",
                      message: result?.message ?? "Failed to reset password",
                      backgroundColor: AppColors.error,
                    );
                  }
                },
              ),

              commonSizedBox(height: 24),

              // Back to sign in
              GestureDetector(
                onTap: () {
                  navigateToPage(
                    context: context,
                    SigninView(),
                    clearStack: true,
                  );
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.arrow_back),
                    commonText("  Back to sign in", size: 14),
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
