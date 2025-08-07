import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:training_plus/view/profile/change_password.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: commonText("General Settings", size: 18, isBold: true),
        centerTitle: true,
      ),

      bottomSheet: SizedBox(
        height: double.infinity,
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Column(
            children: [
              const SizedBox(height: 10),
              // Security
              _buildSettingOption(
                icon: "assest/images/profile/lock_2.png",
                title: "Change Password",
          
                haveArrow: true,
                onTap: () {
                  Get.to(ChangePasswordScreen());
                },
              ),

              // Help
              _buildSettingOption(
                icon: "assest/images/profile/delete.png",
                title: "Delete Account",
             
                onTap: () {
                  showDeleteAccountDialog(context, () {
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          ),
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
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),

        child: ListTile(
          leading: Image.asset(icon,width: 32,height: 32, ),
          title: commonText(title, size: 16),
          trailing: (haveArrow) ? Icon(Icons.arrow_forward_ios_outlined) : null,
        ),
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
          title: commonText(
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
                  child: commonButton(
                    "Cancel",
                    color: Colors.grey.shade400,
                    textColor: Colors.black,
                    height: 40,
                    width: 100,
                    onTap: () {
                      Navigator.of(context).pop(); // Close the dialog
                    },
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  child: commonButton(
                    "Delete",
                    color: Colors.red.shade700,
                    textColor: Colors.white,
                    height: 40,
                    width: 100,
                    onTap: () {
                      Navigator.of(context).pop(); // Close the dialog
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
