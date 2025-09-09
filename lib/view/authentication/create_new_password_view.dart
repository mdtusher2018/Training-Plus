import 'package:flutter/material.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/image_paths.dart';
import 'package:training_plus/view/authentication/sign_in/sign_in_view.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class CreateNewPasswordView extends StatefulWidget {
  const CreateNewPasswordView({super.key});

  @override
  State<CreateNewPasswordView> createState() => _CreateNewPasswordViewState();
}

class _CreateNewPasswordViewState extends State<CreateNewPasswordView> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool passwordVisible = true;
  bool confirmPasswordVisible = true;

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(height: 16),
              commonText("Create new password", size: 21, isBold: true),
              const SizedBox(height: 8),
              commonText(
                "Your new password must be different\nto previously used passwords.",
                size: 14,
                textAlign: TextAlign.center,
                color: AppColors.textSecondary,
              ),
              const SizedBox(height: 32),

              // Password Field
              commonTextfieldWithTitle(
                "Password",
                passwordController,
                hintText: "Enter your password",
                isPasswordVisible: passwordVisible,
                issuffixIconVisible: true,
                changePasswordVisibility: () {
                  setState(() {
                    passwordVisible = !passwordVisible;
                  });
                },
              ),
              const SizedBox(height: 16),

              // Confirm Password Field
              commonTextfieldWithTitle(
                "Confirm Password",
                confirmPasswordController,
                hintText: "Enter your password",
                isPasswordVisible: confirmPasswordVisible,
                issuffixIconVisible: true,
                changePasswordVisibility: () {
                  setState(() {
                    confirmPasswordVisible = !confirmPasswordVisible;
                  });
                },
              ),
              const SizedBox(height: 30),

              // Continue Button
              commonButton(
                "Continue",
                onTap: () {
                  String password = passwordController.text.trim();
                  String confirmPassword =
                      confirmPasswordController.text.trim();

                  if (password.isEmpty || confirmPassword.isEmpty) {
                    commonSnackbar(context: context,
                      title: "Error",
                      message: "Please fill all the fields",
                      backgroundColor: AppColors.error,
                    );
                    return;
                  }

                  if (password != confirmPassword) {
                    commonSnackbar(context: context,
                      title: "Error",
                      message: "Passwords do not match",
                      backgroundColor: AppColors.error,
                    );
                    return;
                  }
                  navigateToPage(context: context,SigninView(), clearStack: true);
                  commonSnackbar(context: context,
                    title: "Success",
                    message: "Password reset successful",
                    backgroundColor: AppColors.success,
                  );
                },
              ),
              const SizedBox(height: 24),

              // Back to sign in
              GestureDetector(
                onTap: () {
                  navigateToPage(context: context,SigninView(), clearStack: true);
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
