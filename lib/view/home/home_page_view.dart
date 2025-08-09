import 'package:flutter/material.dart';
import 'package:training_plus/utils/colors.dart';
import 'package:training_plus/view/home/nutrition_tracker_view.dart';
import 'package:training_plus/view/home/running_gps_view.dart';
import 'package:training_plus/view/home/workout_details.dart';
import 'package:training_plus/view/notification/notification_view.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.mainBG,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// ===== Top Bar =====
              Row(
                children: [
                  ClipOval(
                    child: CommonImage(
                      imagePath: "https://images.unsplash.com/photo-1494790108377-be9c29b29330?q=80&w=687&auto=format&fit=crop&ixlib=rb-4.1.0&ixid=M3wxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8fA%3D%3D",
                     fit: BoxFit.cover,
                      width: 50,
                      height: 50,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        commonText("Welcome , Jack", size: 14),
                        commonText("Ready to train?",
                            size: 18, isBold: true),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      navigateToPage(NotificationsView());
                    },
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.primary,
                      ),
                      child: const Icon(Icons.notifications_none,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              /// ===== Motivational Banner =====
              Container(
  height: 140,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(12),
  ),
  child: Stack(
    fit: StackFit.expand,
    children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          "https://www.rhsmith.umd.edu/sites/default/files/research/featured/2022/11/soccer-player.jpg",
          fit: BoxFit.cover,
        ),
      ),
      Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.black.withOpacity(0.5), // 50% black overlay
        ),
      ),
      Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12),
          child: commonText(
            '"Champions aren\'t made in comfort zones. Push yourself beyond what you think is possible today."',
            size: 14,
            color: Colors.white,
            textAlign: TextAlign.center,
            isBold: true,
            maxline: 5,
          ),
        ),
      ),
    ],
  ),
),

              const SizedBox(height: 20),

              /// ===== Stats Grid =====
     
                  Row(
                    children: [
                      Expanded(child: _buildStatCard("assest/images/home/days.png", "7 Days", "Streak")),
                      Expanded(child: _buildStatCard("assest/images/home/workout.png", "24", "Workouts")),
    
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(child: _buildStatCard("assest/images/home/goals.png", "3/5", "Goals")),
                      Expanded(child: _buildStatCard("assest/images/home/achivment.png", "12", "Achievement")),
                    ],
                  ),
          
              
              const SizedBox(height: 20),

              /// ===== Quick Actions =====
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        navigateToPage(RunningTrackerPage());
                      },
                      child: _buildQuickAction(
                        
                          label:  "Running\nTracker",
                          imagePath: "assest/images/home/running_track.png"
                          ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: () {
                        navigateToPage(NutritionTrackerPage());
                      },
                      child: _buildQuickAction(
                          label:  "Nutrition\nTracker",
                          imagePath: "assest/images/home/nutrition_track.png",
                          color1: Color(0xFF724C21),
                          color2: Color(0xFFE0CC64),
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight
                          ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              /// ===== My Workouts =====
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  commonText("My Workouts", size: 18, isBold: true),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        commonText("See all ",color: AppColors.textSecondary,
                            size: 14),
                        const Icon(Icons.arrow_forward,
                            size: 16, color: AppColors.primary),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              SizedBox(
                height: 280,
                child: ListView.separated(itemCount: 5,
                  separatorBuilder: (context, index) => SizedBox(width: 10,),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        navigateToPage(WorkoutDetailPage());
                      },
                      child: _buildWorkoutCard("Intermediate", "Ball Control Mastery",
                              "25 min", "https://www.rhsmith.umd.edu/sites/default/files/research/featured/2022/11/soccer-player.jpg"),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),

      /// ===== Bottom Navigation =====
      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed,
      //   selectedItemColor: AppColors.primary,
      //   unselectedItemColor: Colors.grey,
      //   currentIndex: 0,
      //   items: const [
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.home), label: "Home"),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.fitness_center), label: "Training"),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.bar_chart), label: "Progress"),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.group), label: "Community"),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.person), label: "Profile"),
      //   ],
      // ),
    );
  }

  /// ===== Helper Widgets =====
  Widget _buildStatCard(String icon, String value, String label) {
    return Card(
      elevation: 2,
      child: Container(
       
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.symmetric(vertical: 16,horizontal: 8),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,height: 40,
              decoration: const BoxDecoration(
                
                color: AppColors.primary,
                borderRadius:BorderRadius.all(Radius.circular(16)) 
              ),
              padding: const EdgeInsets.all(8),
              child: Image.asset(icon),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  commonText(value, size: 16, isBold: true,maxline: 1),
                  commonText(label, size: 12, color: AppColors.textSecondary,maxline: 1),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

Widget _buildQuickAction({
  required String imagePath,
  required String label,
  Color color1 = const Color(0xFF44330E),
  Color color2 = const Color(0xFFAA7F24),
  Alignment begin = Alignment.bottomCenter,
  Alignment end = Alignment.topCenter,
}) {
  return Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      gradient: LinearGradient(
        colors: [color1, color2],
        begin: begin,
        end: end,
      ),
      borderRadius: BorderRadius.circular(8),
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(imagePath,height: 32,width: 32,),
        const SizedBox(width: 6),
        Expanded(child: commonText(label, size: 14, color: Colors.white, isBold: true,maxline: 2)),
      ],
    ),
  );
}


  Widget _buildWorkoutCard(
      String level, String title, String time, String imagePath) {
    return Container(
      width: 200,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        image: DecorationImage(
          image: NetworkImage(imagePath),
          onError: (exception, stackTrace) => commonImageErrorWidget(),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.black.withOpacity(0.6), Colors.transparent],
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20),
              ),
              child: commonText(level,
                  size: 10, color: Colors.white, isBold: true),
            ),
            const Spacer(),
            commonText(title,
                size: 14, isBold: true, color: Colors.white),
            Row(
              children: [
                const Icon(Icons.access_time,
                    size: 12, color: Colors.white),
                const SizedBox(width: 4),
                Expanded(child: commonText(time, size: 12, color: Colors.white)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
