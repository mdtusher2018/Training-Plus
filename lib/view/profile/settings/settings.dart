import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_plus/core/services/localstorage/storage_key.dart';
import 'package:training_plus/core/services/providers.dart';
import 'package:training_plus/core/utils/extention.dart';
import 'package:training_plus/core/utils/session_reset.dart';
import 'package:training_plus/view/authentication/sign_in/sign_in_view.dart';
import 'package:training_plus/view/profile/profile_providers.dart';
import 'package:training_plus/view/profile/settings/change_password/change_password_view.dart';
import 'package:training_plus/widgets/common_text.dart';
import 'package:training_plus/widgets/common_button.dart';

class SettingsView extends ConsumerWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        toolbarHeight: 60.h,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_new),
        ),
        title: CommonText("Settings", size: 18, isBold: true),
        centerTitle: true,
      ),
      body: SizedBox(
        height: double.infinity,
        child: Column(
          children: [
            _buildSettingOption(
              icon: "assest/images/profile/lock_2.png",
              title: "Change Password",

              haveArrow: true,
              onTap: () {
                context.navigateTo(ChangePasswordScreen());
              },
            ),

            // Help
            _buildSettingOption(
              icon: "assest/images/profile/delete.png",
              title: "Delete Account",

              onTap: () {
                showDeleteAccountDialog(context, ref);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingOption({
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool haveArrow = false,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: ListTile(
        leading: Image.asset(
          icon,
          width: 32.w, // responsive width
          height: 32.w, // keep square, also responsive
          fit: BoxFit.contain,
        ),
        title: CommonText(
          title,
          size: 16, // responsive text
        ),
        trailing:
            haveArrow
                ? Icon(
                  Icons.arrow_forward_ios_outlined,
                  size: 18.sp, // responsive icon
                )
                : null,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w, // responsive horizontal padding
          vertical: 4.h, // responsive vertical padding
        ),
        minLeadingWidth: 24.w, // ensures spacing scales well
      ),
    );
  }

  Future<void> showDeleteAccountPasswordDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final controller = ref.read(deleteUserControllerProvider.notifier);

    // Create the TextEditingController
    final passwordController = TextEditingController();

    // Show dialog
    showDialog(
      context: context,
      barrierDismissible: false, // To prevent closing by tapping outside
      builder: (BuildContext context) {
        bool passwordVisible = false; // Local state for password visibility

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  20,
                ), // Softer rounded corners
              ),
              title: CommonText(
                "Delete Account",
                size: 20,
                isBold: true,
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CommonText(
                    "Please enter your password to continue.\nThis action cannot be undone.",
                    size: 14,
                    color:
                        Colors.grey.shade600, // Lighter grey for a softer look
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    obscureText: !passwordVisible,
                    style: TextStyle(fontSize: 16), // Improved text style
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(
                        color: Colors.grey[700],
                      ), // Lighter label color
                      hintText: "Enter your password",
                      suffixIcon: IconButton(
                        icon: Icon(
                          passwordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: Colors.grey[600], // Icon color for consistency
                        ),
                        onPressed: () {
                          setState(() {
                            passwordVisible =
                                !passwordVisible; // Toggle the password visibility
                          });
                        },
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          12,
                        ), // Smooth corners
                        borderSide: BorderSide(
                          color: Colors.grey[300]!,
                        ), // Light border color
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(
                          color: Colors.redAccent,
                        ), // Highlighted border color
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 20,
                      ), // More space for text
                    ),
                  ),
                ],
              ),
              actions: [
                SizedBox(
                  height: 50,
                  child: Row(
                    children: [
                      Expanded(
                        child: CommonButton(
                          "Cancel",
                          color: Colors.grey.shade400,
                          textColor: Colors.black,
                          height: 40,
                          boarderRadious: 10,
                          width: 100,
                          onTap: () {
                            Navigator.pop(context);
                          },
                        ),
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Consumer(
                          builder: (context, ref, _) {
                            final state = ref.watch(
                              deleteUserControllerProvider,
                            );
                            return CommonButton(
                              "Continue",
                              color: Colors.red.shade700,
                              textColor: Colors.white,
                              height: 40,
                              boarderRadious: 10,
                              width: 100,
                              isLoading: state.isLoading,
                              onTap: () async {
                                final result = await controller.deleteUser(
                                  password: passwordController.text,
                                );
                                if (result ?? false) {
                                  final localStorage = ref.read(
                                    localStorageProvider,
                                  );
                                  await localStorage.remove(StorageKey.token);
                                  resetSession(ref);
                                  context.navigateTo(
                                    SigninView(),
                                    clearStack: true,
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<void> showDeleteAccountDialog(
    BuildContext context,
    WidgetRef ref,
  ) async {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: CommonText(
            "Do you want to delete your account?",
            size: 18,
            fontWeight: FontWeight.w500,
            textAlign: TextAlign.center,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          actions: [
            SizedBox(
              height: 50,
              child: Row(
                children: [
                  Expanded(
                    child: CommonButton(
                      "Cancel",
                      color: Colors.grey.shade400,
                      boarderRadious: 10,
                      textColor: Colors.black,
                      height: 40,
                      width: 100,
                      onTap: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: CommonButton(
                      "Delete",
                      color: Colors.red.shade700,
                      textColor: Colors.white,
                      height: 40,
                      boarderRadious: 10,
                      width: 100,
                      onTap: () {
                        Navigator.pop(context);
                        showDeleteAccountPasswordDialog(context, ref);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
