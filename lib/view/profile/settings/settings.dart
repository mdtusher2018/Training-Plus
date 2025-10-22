import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_plus/core/utils/extention.dart';
import 'package:training_plus/view/profile/settings/change_password/change_password_view.dart';
import 'package:training_plus/widgets/common_text.dart';
import 'package:training_plus/widgets/common_button.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,toolbarHeight: 60.h,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_new)),
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
                context.navigateTo(
ChangePasswordScreen());
              },
            ),
        
            // Help
            _buildSettingOption(
              icon: "assest/images/profile/delete.png",
              title: "Delete Account",
           
              onTap: () {
                showDeleteAccountDialog(context, () {
                  // Navigator.pop(context);
                  Navigator.pop(context);
                });
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
      trailing: haveArrow
          ? Icon(
              Icons.arrow_forward_ios_outlined,
              size: 18.sp, // responsive icon
            )
          : null,
      contentPadding: EdgeInsets.symmetric(
        horizontal: 16.w, // responsive horizontal padding
        vertical: 4.h,    // responsive vertical padding
      ),
      minLeadingWidth: 24.w, // ensures spacing scales well
    ),
  );
}

  Future<void> showDeleteAccountDialog(
    BuildContext context,
    VoidCallback onDelete,
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
            Row(
              children: [
                Expanded(
                  child: CommonButton(
                    "Cancel",
                    color: Colors.grey.shade400,
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
                    width: 100,
                    onTap: () {
                      Navigator.pop(context);
                      onDelete(); // Perform the delete action
                    },
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
