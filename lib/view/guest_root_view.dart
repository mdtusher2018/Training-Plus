import 'package:flutter/material.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/view/community/community/community_view.dart';
import 'package:training_plus/view/home/home/home_page_view.dart';
import 'package:training_plus/widgets/common_text.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_plus/core/utils/extention.dart';
import 'package:training_plus/view/authentication/sign_in/sign_in_view.dart';
import 'package:training_plus/view/profile/ContactUsView.dart';
import 'package:training_plus/view/profile/faq/FaqView.dart';
import 'package:training_plus/view/profile/Trems of service And Privacy policy/privacy_policy_view.dart';
import 'package:training_plus/view/profile/Trems of service And Privacy policy/terms_of_service_view.dart';
import 'package:training_plus/widgets/common_button.dart';
import 'package:training_plus/widgets/common_image.dart';
import 'package:training_plus/widgets/common_sized_box.dart';

class GuestRootView extends StatefulWidget {
  const GuestRootView({super.key});

  @override
  State<GuestRootView> createState() => _GuestRootViewState();
}

class _GuestRootViewState extends State<GuestRootView> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    HomePageView(isGuest: true),
    LoginRequiredView(onLoginPressed: () {}),
    LoginRequiredView(onLoginPressed: () {}),
    CommunityView(isGuest: true),
    GuestProfileView(),
  ];

  final List<String> _titles = [
    "Home",
    "Training",
    "Progress",
    "Community",
    "Profile",
  ];

  /// Image paths for selected & unselected states
  final List<String> _selectedImages = [
    "assest/images/nav/home_selected.png",
    "assest/images/nav/training_selected.png",
    "assest/images/nav/progress_selected.png",
    "assest/images/nav/community_selected.png",
    "assest/images/nav/profile_selected.png",
  ];

  final List<String> _unselectedImages = [
    "assest/images/nav/home_unselected.png",
    "assest/images/nav/training_unselected.png",
    "assest/images/nav/progress_unselected.png",
    "assest/images/nav/community_unselected.png",
    "assest/images/nav/profile_unselected.png",
  ];

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.boxBG,
      body: PageView(
        controller: _pageController,
        physics: NeverScrollableScrollPhysics(),
        children: _pages,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        showUnselectedLabels: true,
        items: List.generate(5, (index) {
          return BottomNavigationBarItem(
            icon: Image.asset(
              _currentIndex == index
                  ? _selectedImages[index]
                  : _unselectedImages[index],
              height: 28,
              width: 28,
            ),
            label: _titles[index],
          );
        }),
      ),
    );
  }
}

class LoginRequiredView extends StatelessWidget {
  final VoidCallback onLoginPressed;

  const LoginRequiredView({super.key, required this.onLoginPressed});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: CommonText("Login Required"),
        centerTitle: true,
        leading: SizedBox(),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 90, color: AppColors.primary),
            const SizedBox(height: 24),

            CommonText(
              "Login to Continue",
              size: 22,
              fontWeight: FontWeight.bold,
            ),

            const SizedBox(height: 12),

            CommonText(
              "You are currently using guest mode. "
              "To access this feature and enjoy the full experience, "
              "please login or create an account.",
              textAlign: TextAlign.center,
              size: 14,
            ),

            const SizedBox(height: 30),

            CommonButton("Login", onTap: onLoginPressed, height: 30),

            const SizedBox(height: 12),

            CommonButton(
              color: AppColors.textSecondary.withOpacity(0.8),
              height: 30,
              onTap: () {
                Navigator.pop(context);
              },
              "Maybe later",
              textColor: AppColors.white,
            ),
          ],
        ),
      ),
    );
  }
}

class GuestProfileView extends StatelessWidget {
  const GuestProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const CommonText("Profile", size: 21, isBold: true),
        centerTitle: true,
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        toolbarHeight: 70.h,
      ),

      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          /// Avatar
          const Center(
            child: CircleAvatar(
              radius: 40,
              child: Icon(Icons.person_outline, size: 40),
            ),
          ),

          const CommonSizedBox(height: 12),

          /// Guest Name
          const Center(child: CommonText("Guest User", size: 18, isBold: true)),

          const CommonSizedBox(height: 8),

          /// Description
          const Center(
            child: CommonText(
              "Login to access your profile, rewards, running history and more.",
              textAlign: TextAlign.center,
              size: 14,
            ),
          ),

          const CommonSizedBox(height: 20),

          /// Login Button
          CommonButton(
            "Login / Sign Up",

            onTap: () {
              context.navigateTo(const SigninView());
            },
          ),

          const CommonSizedBox(height: 30),

          /// Support Section
          _sectionHeader("Support & Help"),

          _sectionTile(
            context,
            "FAQ",
            "assest/images/profile/faq.png",
            onTap: () {
              context.navigateTo(const FaqView());
            },
          ),

          _sectionTile(
            context,
            "Contact Us",
            "assest/images/profile/contact_us.png",
            onTap: () {
              context.navigateTo(const ContactUsView());
            },
          ),

          const CommonSizedBox(height: 24),

          /// Legal Section
          _sectionHeader("Legal"),

          _sectionTile(
            context,
            "Terms of Service",
            "assest/images/profile/terms_of_service.png",
            onTap: () {
              context.navigateTo(const TermsOfServiceView());
            },
          ),

          _sectionTile(
            context,
            "Privacy Policy",
            "assest/images/profile/privacy_policy.png",
            onTap: () {
              context.navigateTo(const PrivacyPolicyView());
            },
          ),
        ],
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: CommonText(title, size: 14, isBold: true),
    );
  }

  Widget _sectionTile(
    BuildContext context,
    String title,
    String imagePath, {
    VoidCallback? onTap,
  }) {
    return ListTile(
      dense: true,
      onTap: onTap,
      leading: CommonImage(imagePath: imagePath, isAsset: true, width: 28),
      title: CommonText(title, size: 14, isBold: true),
      trailing: Icon(
        Icons.chevron_right,
        size: 16.sp,
        color: AppColors.primary,
      ),
    );
  }
}
