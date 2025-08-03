import 'package:flutter/material.dart';
import 'package:training_plus/utils/colors.dart';
import 'package:training_plus/widgets/common_widgets.dart' show authAppBar, commonText;


class NutritionTrackerPage extends StatelessWidget {
  const NutritionTrackerPage({super.key});

  @override
  Widget build(BuildContext context) {
 Color caloriesColor=Color(0xFFFF5733);
Color protienColor=Color(0xFF34C759);
Color carbsColor=Color(0xFFFFD60A);
Color fatColor=Color(0xFFFF9500);
final List<Map<String, dynamic>> meals = [
  {
    "title": "Breakfast Burrito",
    "time": "9:45 AM",
    "stats": [
      {"label": "Calories", "value": "300c", "color": caloriesColor},
      {"label": "Protein", "value": "300g", "color": protienColor},
      {"label": "Carbs", "value": "100g", "color": carbsColor},
      {"label": "Fat", "value": "3g", "color": fatColor},
    ]
  },
  {
    "title": "Avocado Toast",
    "time": "10:15 AM",
    "stats": [
      {"label": "Calories", "value": "250c", "color": caloriesColor},
      {"label": "Protein", "value": "10g", "color": protienColor},
      {"label": "Carbs", "value": "30g", "color": carbsColor},
      {"label": "Fat", "value": "15g", "color": fatColor},
    ]
  },
  {
    "title": "Greek Yogurt Parfait",
    "time": "10:45 AM",
    "stats": [
      {"label": "Calories", "value": "200c", "color": caloriesColor},
      {"label": "Protein", "value": "15g", "color": protienColor},
      {"label": "Carbs", "value": "25g", "color": carbsColor},
      {"label": "Fat", "value": "5g", "color": fatColor},
    ]
  },
];
    return Scaffold(
      appBar: authAppBar("Nutrition Tracker"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          spacing: 16,
          children: [
            // Top Date & Set Goals Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
             Row(
              spacing: 4,
               children: [
                 Icon(Icons.calendar_month_outlined),
                  commonText("Saturday, July 12",size: 14),
               ],
             ),
                Material(
                  elevation: 1,
                  borderRadius: BorderRadius.all(Radius.circular(8)),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
                    decoration: BoxDecoration(color: AppColors.white,borderRadius: BorderRadius.all(Radius.circular(8))),
                    child: Row(mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset("assest/images/home/gole_black.png",width: 20,),
                      commonText("Set Goals",size: 14)
                      ],
                    ),
                  ))
              ],
            ),
        

            // Today's Progress
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.yellow.shade50.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.yellow.shade700),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.trending_up,
                          color: AppColors.primary, size: 30),
                      const SizedBox(width: 6),
                      commonText("Today's Progress",
                          size: 16, isBold: true, color: Colors.black),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      commonText("Overall Goal Achievement", size: 12,color: AppColors.textSecondary),
                        commonText("25%", size: 12, isBold: true,color: AppColors.textSecondary),
                    ],
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: 0.25,
                    color: Colors.yellow.shade700,
                    backgroundColor: Colors.grey.shade200,
                    minHeight: 12,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ],
              ),
            ),
         

            // Quick Stat
        Material(
          elevation: 2,
              borderRadius: BorderRadius.circular(8),
          child: Container(
            margin: EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8)
            ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
        
            children: [
          commonText("Quick Stat", size: 16, isBold: true),
           SizedBox(height: 8,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
                child: GridView.count(
                  padding: EdgeInsets.all(0),
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                  childAspectRatio: 1.75,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildQuickStatCard("300", "Calories", Color(0xFFFF5733)),
                    _buildQuickStatCard("100g", "Proteins", Color(0xFF34C759)),
                    _buildQuickStatCard("100g", "Carbs", Color(0xFFFFD60A)),
                    _buildQuickStatCard("3g", "Fat", Color(0xFFFF9500)),
                  ],
                ),
              ),
            ],
          ),
          ),
        ),
       


            // Detailed Stats
            _buildDetailedStatCard(
              imagePath: "assest/images/home/calories.png",
              label: "Calories",
              valueText: "300/2200 cal",
              statusText: "Getting Started",
              statusColor:caloriesColor ,
              progress: 0.02,
              remainingText: "2200 cal remaining",
            ),
    
            _buildDetailedStatCard(
              imagePath: "assest/images/home/protein.png",
              label: "Protein",
              valueText: "300/100 g",
              statusText: "Complete",
              statusColor: protienColor,
              progress: 1.0,
              remainingText: "Goal Reached",
            ),
         
            _buildDetailedStatCard(
              imagePath:"assest/images/home/crabs.png",
              label: "Crabs",
              valueText: "100/200 g",
              statusText: "Good Progress",
              statusColor: carbsColor,
              progress: 0.5,
              remainingText: "Goal Reached",
            ),
         
            _buildDetailedStatCard(
              imagePath:"assest/images/home/fat.png",
              label: "Fat",
              valueText: "3/75 g",
              statusText: "Getting Started",
              statusColor: fatColor,
              progress: 0.5,
              remainingText: "Goal Reached",
            ),
       

            // Today's Meals
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.2),
                  width: 1.5,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  commonText("Today's Meals", size: 16, isBold: true),
                  const SizedBox(height: 8),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: meals.length,
                    itemBuilder: (context, index) {
                      final meal = meals[index];
                      return _buildMealItem(
                        title: meal["title"],
                        time: meal["time"],
                        stats: meal["stats"]
                            .map<Widget>((stat) => _mealStat(
                                  stat["label"],
                                  stat["value"],
                                  stat["color"],
                                ))
                            .toList(),
                      );
                    },
                  ),
                ],
              ),
            ),

          ],
        ),
      ),
      floatingActionButton: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle
        ),
        child: Icon(Icons.fullscreen,size: 40,),
      ),
    );
  }

  Widget _buildQuickStatCard(String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.boxBG,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(width: 1,color: Colors.grey.withOpacity(0.3))
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          commonText(value, size: 18, color: color, fontWeight: FontWeight.w800),
          const SizedBox(height: 2),
          commonText(label, size: 14,color: color),
        ],
      ),
    );
  }

  Widget _buildDetailedStatCard({
    required String imagePath,
    required String label,
    required String valueText,
    required String statusText,
    required Color statusColor,
    required double progress,
    required String remainingText,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 4),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            contentPadding: EdgeInsets.all(0),minVerticalPadding: 0,
            title:  commonText(label, size: 16, isBold: true),
            subtitle: commonText(valueText, size: 12, isBold: false),
            leading:   Container(
              width: 40,height: 40,
              decoration:  BoxDecoration(
                
                color: statusColor,
                borderRadius:BorderRadius.all(Radius.circular(16)) 
              ),
              padding: const EdgeInsets.all(8),
              child: Image.asset(imagePath),
            ), 
            trailing: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: (statusText=="Getting Started")?Color(0xFFFFD60A):(statusText=="Complete")?Color(0xFF00C566):Color(0xFF5AC8FA),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: commonText(statusText,
                    size: 10, color: AppColors.white, isBold: true),
              ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              commonText("${(progress * 100).toStringAsFixed(0)}%", size: 12),
              commonText(remainingText, size: 12, isBold: true),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: progress,
            color: statusColor,
            backgroundColor: Colors.grey.shade300,
            minHeight: 12,
            borderRadius: BorderRadius.circular(8),
          ), const SizedBox(height: 10),
        ],
      ),
    );
  }

  Widget _buildMealItem({
    required String title,
    required String time,
    required List<Widget> stats,
  }) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.boxBG,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          commonText(title, size: 14, isBold: true),
          const SizedBox(height: 2),
          commonText(time, size: 12, color: AppColors.textSecondary),
          const SizedBox(height: 8),
          Wrap(
            spacing: 6,
            children: stats,
          ),
        ],
      ),
    );
  }

  Widget _mealStat(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(6),
      ),
      child: commonText("$label  \n$value", size: 10, color: AppColors.white, isBold: true),
    );
  }
}
