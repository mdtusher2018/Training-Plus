import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // <-- required for Clipboard
import 'package:training_plus/widgets/common_widgets.dart';

class InviteFriendsView extends StatelessWidget {
  const InviteFriendsView({super.key,required this.inviteCode});


  final String inviteCode ; 
 // Example code
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: CommonText(
          'Invite Friends',
          size: 21,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            CommonSizedBox(height: 16),
            CommonImage(
              imagePath: "assest/images/profile/invite_friends_image.png",
              isAsset: true,
            ),
            CommonSizedBox(height: 24),
            CommonText(
              "Just share this code with\nyour friends",
              size: 21,
              textAlign: TextAlign.center,
            ),
            CommonSizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: CommonTextField(
                    hintText: inviteCode,
                    controller: TextEditingController(text: inviteCode),
                    enabled: false,
                    boarderWidth: 2,
                    boarderColor: Colors.grey.withOpacity(0.5),
                  ),
                ),
                CommonSizedBox(width: 16),
                CommonButton(
                  "Copy",
                  width: 80,
                  height: 50,
                  boarderRadious: 10,
                  onTap: () {
                    Clipboard.setData(ClipboardData(text: inviteCode));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Code copied to clipboard"),
                        duration: Duration(seconds: 2),
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
