import 'package:flutter/material.dart';

import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/image_paths.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();

  bool isOldPasswordVisible = false;
  bool isNewPasswordVisible = false;
  bool isConfirmPasswordVisible = false;
  bool isLoading = false;

  void handleChangePassword() {
    setState(() => isLoading = true);

    Future.delayed(const Duration(seconds: 2), () {
      setState(() => isLoading = false);
      Navigator.pop(context);
      commonSnackbar(context: context,title: "Successfully", message: "Password changed successfully",backgroundColor: AppColors.success);
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: commonText("Change Password", size: 18, isBold: true),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        height: double.infinity,
        child: Column(
          children: [
            const SizedBox(height: 20),

            /// Current Password
            commonTextfieldWithTitle(
              "Current Password",
              oldPasswordController,
              hintText: "Enter your password",
              assetIconPath: ImagePaths.lock,
              isPasswordVisible: isOldPasswordVisible,
              issuffixIconVisible: true,
              changePasswordVisibility: () {
                setState(() => isOldPasswordVisible = !isOldPasswordVisible);
              },
            ),

            const SizedBox(height: 15),

            /// New Password
            commonTextfieldWithTitle(
              "New Password",
              newPasswordController,
              hintText: "Enter new password",
              assetIconPath: ImagePaths.lock,
              isPasswordVisible: isNewPasswordVisible,
              issuffixIconVisible: true,
              changePasswordVisibility: () {
                setState(() => isNewPasswordVisible = !isNewPasswordVisible);
              },
            ),

            const SizedBox(height: 15),

            /// Confirm Password
            commonTextfieldWithTitle(
              "Confirm New Password",
              confirmPasswordController,
              hintText: "Re-enter new password",
              assetIconPath: ImagePaths.lock,
              isPasswordVisible: isConfirmPasswordVisible,
              issuffixIconVisible: true,
              changePasswordVisibility: () {
                setState(() => isConfirmPasswordVisible = !isConfirmPasswordVisible);
              },
            ),

           

            const SizedBox(height: 40),

            isLoading
                ? const CircularProgressIndicator()
                : commonButton(
                    "Change Password",
                    onTap: handleChangePassword,
                  ),
          ],
        ),
      ),
    );
  }
}
