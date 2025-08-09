import 'package:flutter/material.dart';
import 'package:training_plus/utils/colors.dart';
import 'package:training_plus/view/community/community_view.dart';
import 'package:training_plus/view/home/home_page_view.dart';
import 'package:training_plus/view/profile/profile_view.dart';
import 'package:training_plus/view/progress/progress_view.dart';
import 'package:training_plus/view/training/training_view.dart';

class RootView extends StatefulWidget {
  const RootView({super.key});

  @override
  State<RootView> createState() => _RootViewState();
}

class _RootViewState extends State<RootView> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<Widget> _pages = [
    HomePageView(),
    TrainingView(),
    ProgressView(),
    CommunityView(),
    ProfileView()
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
