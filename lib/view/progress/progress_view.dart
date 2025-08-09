// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:training_plus/utils/colors.dart';
import 'package:training_plus/view/progress/recentSessionsView.dart';
import 'package:training_plus/view/progress/widget/recent_session_card.dart';
import 'package:training_plus/widgets/common_widgets.dart';
import 'package:fl_chart/fl_chart.dart';

class ProgressView extends StatefulWidget {
   ProgressView({super.key});

  @override
  State<ProgressView> createState() => _ProgressViewState();
}

class _ProgressViewState extends State<ProgressView> {
bool isMonthly=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.boxBG,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        backgroundColor: AppColors.boxBG,
        title: commonText("Progress", size: 20, fontWeight: FontWeight.bold),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTrainingActivityChart(isMonthly:isMonthly,ontap: (){
              setState(() {
                isMonthly=!isMonthly;
              });
            } ),
            const SizedBox(height: 16),
            _buildSportsActivityChart(),
            const SizedBox(height: 16),
            _buildGoalsSection(),
            const SizedBox(height: 16),
            _buildRecentSessions(),
            const SizedBox(height: 16),
            _buildAchievements(),
            const SizedBox(height: 20),
            _buildSetGoalsButton(context),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // Widget _buildTrainingActivityChart() {
Widget _buildTrainingActivityChart({required bool isMonthly,required Function() ontap}) {
  return StatefulBuilder(
    builder: (context, setState) {
      // Monthly data
      final monthlyData = [30, 40, 28, 32, 29, 25, 33, 20, 15, 10, 12, 14];
      final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];

      // Weekly data
      final weeklyData = [5, 8, 7, 6, 10, 9, 4];
      final weekDays = ['Sat', 'Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri'];

      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              children: [
                commonText("Training Activity", size: 14, fontWeight: FontWeight.w600),
                const Spacer(),
                GestureDetector(
                  onTap:ontap,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Row(
                      children: [
                        commonText(isMonthly ? "Monthly" : "Weekly", size: 12),
                        const Icon(Icons.arrow_drop_down),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 160,
              child: BarChart(
                BarChartData(
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    topTitles: AxisTitles(),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          if (isMonthly) {
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(months[value.toInt() % 12], style: const TextStyle(fontSize: 8)),
                            );
                          } else {
                            return Padding(
                              padding: const EdgeInsets.only(top: 6),
                              child: Text(weekDays[value.toInt() % 7], style: const TextStyle(fontSize: 10)),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  gridData: FlGridData(show: false),
                  barGroups: List.generate(
                    isMonthly ? 12 : 7,
                    (index) => BarChartGroupData(
                      x: index,
                      barRods: [
                        BarChartRodData(
                          toY: isMonthly ? monthlyData[index].toDouble() : weeklyData[index].toDouble(),
                          width: isMonthly?16:24,
                          borderRadius: BorderRadius.circular(4),
                          color: AppColors.primary,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      );
    },
  );
}

  Widget _buildSportsActivityChart() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              commonText("Sports Activity", size: 14, fontWeight: FontWeight.w600),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 150,
            child: PieChart(
              PieChartData(
                sectionsSpace: 0,
                centerSpaceRadius: 40,
                sections: [
                  PieChartSectionData(color: Colors.amber.shade200, value: 20, title: ''),
                  PieChartSectionData(color: Colors.amber.shade400, value: 20, title: ''),
                  PieChartSectionData(color: Colors.amber.shade600, value: 20, title: ''),
                  PieChartSectionData(color: Colors.brown.shade400, value: 20, title: ''),
                  PieChartSectionData(color: Colors.yellow.shade300, value: 10, title: ''),
                  PieChartSectionData(color: Colors.yellow.shade600, value: 10, title: ''),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 12,
            alignment: WrapAlignment.center,
            runSpacing: 6,
            children: [
              _buildDot("Soccer", Colors.amber.shade200),
              _buildDot("Yoga", Colors.amber.shade400),
              _buildDot("Swimming", Colors.amber.shade600),
              _buildDot("Basketball", Colors.brown.shade400),
              _buildDot("Ice Hockey", Colors.yellow.shade300),
              _buildDot("Tennis", Colors.yellow.shade600),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildDot(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        commonText(label, size: 11),
      ],
    );
  }

  Widget _buildGoalsSection() {
    final goals = [
      {"title": "Weekly Training Goals", "current": 5, "total": 7},
      {"title": "Monthly Soccer Goals", "current": 12, "total": 20},
      {"title": "Monthly Wellness Goals", "current": 10, "total": 10},
    ];

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: AppColors.white, borderRadius: BorderRadius.circular(12)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          commonText("Goals", size: 14, fontWeight: FontWeight.w600),
          const SizedBox(height: 12),
          ...goals.map((goal) {
            double percent = (goal["current"]! as num).toDouble() / (goal["total"]! as num).toDouble();
            return Padding(
              padding:  EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      commonText("${goal["title"]}", size: 12),
                      commonText("${goal["current"]}/${goal["total"]} Sessions", size: 12),
                    ],
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: percent,
                    backgroundColor: AppColors.boxBG,
                    color: AppColors.primary,
                    minHeight: 16,
                    borderRadius: BorderRadius.circular(16),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }

  Widget _buildRecentSessions() {
    final sessions = [
      {
        "title": "Master Ball Control",
        "subtitle": "Today | 20 Min",
        "tag": "Soccer",
        "image": "https://cdn-icons-png.flaticon.com/512/1161/1161660.png"
      },
      {
        "title": "Morning Yoga Flow",
        "subtitle": "Yesterday | 20 Min",
        "tag": "Yoga",
        "image": "https://cdn-icons-png.flaticon.com/512/2903/2903984.png"
      },
      {
        "title": "Butterfly Stroke 101",
        "subtitle": "1 days ago | 20 Min",
        "tag": "Swimming",
        "image": "https://cdn-icons-png.flaticon.com/512/2909/2909824.png"
      },
    ];

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
decoration: BoxDecoration(color: AppColors.mainBG,borderRadius: BorderRadius.circular(10),border: Border.all(width: 1,color: Colors.grey.withOpacity(0.5))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              commonText("Recent Sessions", size: 14, fontWeight: FontWeight.w600),
              const Spacer(),
              TextButton(
                onPressed: () {
                  navigateToPage(RecentSessionsView());
                },
                child: Row(
                  children: [
                    commonText("See all", size: 12),SizedBox(width: 4,),Icon(Icons.arrow_forward)
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ...sessions.map((s) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: RecentSessionCard(
                  title: s["title"]!,
                  subtitle: s["subtitle"]!,
                  tag: s["tag"]!,
                  tagImageUrl: s["image"]!,
                  onTap: () {},
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildAchievements() {
    final achievements = [
      {"title": "First Week", "subtitle": "Complete 7 consecutive days"},
      {"title": "Soccer Starter", "subtitle": "Complete 10 soccer sessions"},
      {"title": "Zen Master", "subtitle": "Complete 5 wellness sessions"},
      {"title": "Consistency King", "subtitle": "Train for 30 days straight"},
    ];

    return Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
decoration: BoxDecoration(color: AppColors.mainBG,borderRadius: BorderRadius.circular(10),border: Border.all(width: 1,color: Colors.grey.withOpacity(0.5))),
   
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              commonText("Achievements", size: 14, fontWeight: FontWeight.w600),
              const Spacer(),
              TextButton(
                onPressed: () {},
                child: Row(
                  children: [
                    commonText("See all", size: 12),SizedBox(width: 4,),Icon(Icons.arrow_forward)
                  ],
                ),
              ),
            ],
          ),
   
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: achievements.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, ),
            itemBuilder: (_, i) {
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary),
                  borderRadius: BorderRadius.circular(12),
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  
                  children: [
                    Image.asset("assest/images/progress/achivment.png",width: 60,height: 60,),
                    const SizedBox(height: 8),
                    commonText(achievements[i]["title"]!, size: 13, fontWeight: FontWeight.w600,textAlign: TextAlign.center),
                    commonText(achievements[i]["subtitle"]!, size: 11, color: AppColors.textSecondary,textAlign: TextAlign.center),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 16,)
        ],
      ),
    );
  }

  Widget _buildSetGoalsButton(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showSetGoalBottomSheet(context);
      },
      child: Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF724C21), Color(0xFFE0CC64)],
          begin: Alignment.centerLeft,
          end:Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset("assest/images/home/goals.png",height: 32,width: 32,),
          const SizedBox(width: 6),
          Expanded(child: commonText("Set Goals", size: 16, color: Colors.white, isBold: true,)),
        ],
      ),
        ),
    );
  }

void showSetGoalBottomSheet(BuildContext context) {
  final TextEditingController targetController = TextEditingController();

  final List<String> sportsList = ["Soccer", "Basketball", "Yoga", "Swimming"];
  final List<String> timeFrameList = ["This Week", "This Month", "Next Month"];

  String? selectedSport = sportsList.first;
  String? selectedTimeFrame = timeFrameList.first;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 10,
        ),
        child: StatefulBuilder(
          builder: (context, setState) {
            return SingleChildScrollView(
              child: Stack(

                children: [
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 16),
                      Center(child: commonText("Set Goal", size: 20, isBold: true)),
                      const SizedBox(height: 24),
                  
                      /// Sports Dropdown
                      commonText("Select Sports", size: 14, fontWeight: FontWeight.w500),
                      const SizedBox(height: 8),
                      commonDropdown<String>(
                        items: sportsList,
                        value: selectedSport,
                        hint: "Select Sports",
                        onChanged: (value) {
                          setState(() => selectedSport = value);
                        },
                      ),
                  
                      const SizedBox(height: 24),
                  
                      /// Target TextField
                      commonTextfieldWithTitle(
                        "Target",
                        targetController,
                        hintText: "Type Target",
                        keyboardType: TextInputType.number,
                      ),
                  
                      const SizedBox(height: 24),
                  
                      /// Time Frame Dropdown
                      commonText("Select Time Frame", size: 14, fontWeight: FontWeight.w500),
                      const SizedBox(height: 8),
                      commonDropdown<String>(
                        items: timeFrameList,
                        value: selectedTimeFrame,
                        hint: "Select Time Frame",
                        onChanged: (value) {
                          setState(() => selectedTimeFrame = value);
                        },
                      ),
                  
                      const SizedBox(height: 32),
                  
                      /// Set Goal Button
                    commonButton("Set Goal"),
                  
                      const SizedBox(height: 32),
                    ],
                  ),
              Positioned(
                top: 0,right: 0,
                child: commonCloseButton()) 
                ],
              ),
            );
          },
        ),
      );
    },
  );
}
}
