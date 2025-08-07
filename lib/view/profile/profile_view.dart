import 'package:flutter/material.dart';
import 'package:training_plus/utils/colors.dart';
import 'package:training_plus/view/profile/widget/reward_tier_card.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class ProfileView extends StatelessWidget {
  final int userPoints = 500;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   appBar: AppBar(title: commonText("Profile",size: 21,isBold: true),centerTitle: true,),
    
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          children: [
            // Profile Avatar
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(
                  "https://plus.unsplash.com/premium_photo-1664297814064-661d433c03d9?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Name
            Center(child: commonText("Jonathan Michael", size: 18, isBold: true)),

            const SizedBox(height: 20),

            // Reward Tier Card
            rewardTierCard(userPoints),

            const SizedBox(height: 30),

    // Sections
sectionHeader("General"),
sectionTile("Edit Profile", "assest/images/profile/edit_profile.png", onTap: () {}),
sectionTile("Settings", "assest/images/profile/settings.png", onTap: () {}),
sectionTile("Redeem Points", "assest/images/profile/redeem_points.png", onTap: () {}),
sectionTile("Running History", "assest/images/profile/running_history.png", onTap: () {}),
sectionTile("Badge Shelf", "assest/images/profile/badge_shelf.png", onTap: () {}),
sectionTile("My Subscription", "assest/images/profile/my_subscription.png", onTap: () {}),

const SizedBox(height: 24),

sectionHeader("Support & Help"),
sectionTile("Feedback", "assest/images/profile/feedback.png", onTap: () {}),
sectionTile("FAQ", "assest/images/profile/faq.png", onTap: () {}),
sectionTile("Contact Us", "assest/images/profile/contact_us.png", onTap: () {}),

const SizedBox(height: 24),

sectionHeader("Legal"),
sectionTile("Terms of Service", "assest/images/profile/terms_of_service.png", onTap: () {}),
sectionTile("Privacy Policy", "assest/images/profile/privacy_policy.png", onTap: () {}),

const SizedBox(height: 24),

sectionHeader("Others"),
sectionTile("Invite Friends", "assest/images/profile/invite_friends.png", onTap: () {}),
sectionTile("Logout", "assest/images/profile/logout.png", onTap: () {}, textColor: Colors.red.shade700),
  ],
        ),
      ),
    );
  }
  Widget sectionHeader(String title) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8),
    child: commonText(title, size: 14, isBold: true),
  );
}

Widget sectionTile(String title, String imagePath, {VoidCallback? onTap, Color? textColor}) {
  return ListTile(
    dense: true,
    visualDensity: VisualDensity(vertical: -1),
    contentPadding: EdgeInsets.zero,
    onTap: onTap,
    leading: CommonImage(imagePath: imagePath,isAsset: true,width: 28,),
    title: commonText(title, size: 14, isBold: true),
    trailing: const Icon(Icons.chevron_right, color: AppColors.primary),
  );
}

}
