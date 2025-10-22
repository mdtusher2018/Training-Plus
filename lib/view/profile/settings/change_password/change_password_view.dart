import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/extention.dart';
import 'package:training_plus/core/utils/image_paths.dart';
import 'package:training_plus/view/profile/profile_providers.dart';
import 'package:training_plus/view/profile/settings/change_password/change_password_controller.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class ChangePasswordScreen extends ConsumerWidget {
  ChangePasswordScreen({super.key});

  final TextEditingController currentPasswordController =
      TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool _validatePasswords(BuildContext context) {
    final current = currentPasswordController.text.trim();
    final newPass = newPasswordController.text.trim();
    final confirmPass = confirmPasswordController.text.trim();

    if (current.isEmpty) {
      context.showCommonSnackbar(
        title: "Error",
        message: "Please enter your current password",
        backgroundColor: AppColors.error,
      );
      return false;
    }

    if (newPass.isEmpty) {
      context.showCommonSnackbar(
        title: "Error",
        message: "Please enter your new password",
        backgroundColor: AppColors.error,
      );
      return false;
    }

        if (newPass.length<6) {
      context.showCommonSnackbar(
        title: "Invalid",
        message: "Password must be 6 charecter",
        backgroundColor: AppColors.error,
      );
      return false;
    }

    if (confirmPass.isEmpty) {
      context.showCommonSnackbar(
        title: "Error",
        message: "Please confirm your new password",
        backgroundColor: AppColors.error,
      );
      return false;
    }

    if (newPass != confirmPass) {
      context.showCommonSnackbar(
        title: "Error",
        message: "New password and Confirm password do not match",
        backgroundColor: AppColors.error,
      );
      return false;
    }

    return true;
  }

  Future<void> _handleChangePassword(
    BuildContext context,
    ChangePasswordController controller,
  ) async {
    if (!_validatePasswords(context)) return;

    final current = currentPasswordController.text.trim();
    final newPass = newPasswordController.text.trim();

    try {
      final response = await controller.changePassword(
        newPassword: newPass,
        currentPassword: current,
      );

      if (response != null) {
        // ✅ Success flow
        Navigator.pop(context);
        context.showCommonSnackbar(
          title: "Success",
          backgroundColor: AppColors.success,
          message: "Your password has been changed successfully",
        );
      }
    } catch (e) {
      // ❌ Show API error gracefully
      final errorMsg = e.toString().split(" - ").last;
      context.showCommonSnackbar(
        title: "Error",
        message: errorMsg,
        backgroundColor: AppColors.error,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ChangePasswordState state = ref.watch(
      changePasswordControllerProvider,
    );
    final ChangePasswordController controller = ref.read(
      changePasswordControllerProvider.notifier,
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        title: CommonText("Change Password", size: 18, isBold: true),
        centerTitle: true,
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        height: double.infinity,
        child: Column(
          children: [
            CommonSizedBox(height: 20),

            /// Current Password
            CommonTextfieldWithTitle(
              "Current Password",
              currentPasswordController,
              hintText: "Enter your password",
              assetIconPath: ImagePaths.lock,
              isPasswordVisible: state.isCurrentPasswordVisible,
              issuffixIconVisible: true,
              changePasswordVisibility:
                  controller.toggleCurrentPasswordVisibility,
            ),

            CommonSizedBox(height: 15),

            /// New Password
            CommonTextfieldWithTitle(
              "New Password",
              newPasswordController,
              hintText: "Enter new password",
              assetIconPath: ImagePaths.lock,
              isPasswordVisible: state.isNewPasswordVisible,
              issuffixIconVisible: true,
              changePasswordVisibility: controller.toggleNewPasswordVisibility,
            ),

            CommonSizedBox(height: 15),

            /// Confirm Password
            CommonTextfieldWithTitle(
              "Confirm New Password",
              confirmPasswordController,
              hintText: "Re-enter new password",
              assetIconPath: ImagePaths.lock,
              isPasswordVisible: state.isConfirmPasswordVisible,
              issuffixIconVisible: true,
              changePasswordVisibility:
                  controller.toggleConfirmPasswordVisibility,
            ),

            CommonSizedBox(height: 40),

            CommonButton(
              "Change Password",
              isLoading: state.isLoading,
              onTap: () => _handleChangePassword(context, controller),
            ),
          ],
        ),
      ),
    );
  }
}
