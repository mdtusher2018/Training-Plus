import 'package:flutter/material.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class AllAchivmentView extends StatefulWidget {
  const AllAchivmentView({super.key});

  @override
  State<AllAchivmentView> createState() => _AllAchivmentViewState();
}

class _AllAchivmentViewState extends State<AllAchivmentView> {
  @override
  Widget build(BuildContext context) {
        final achievements = [
      {"title": "First Week", "subtitle": "Complete 7 consecutive days"},
      {"title": "Soccer Starter", "subtitle": "Complete 10 soccer sessions"},
      {"title": "Zen Master", "subtitle": "Complete 5 wellness sessions"},
      {"title": "Consistency King", "subtitle": "Train for 30 days straight"},
      {"title": "First Week", "subtitle": "Complete 7 consecutive days"},
      {"title": "Soccer Starter", "subtitle": "Complete 10 soccer sessions"},
      {"title": "Zen Master", "subtitle": "Complete 5 wellness sessions"},
      {"title": "Consistency King", "subtitle": "Train for 30 days straight"},
      {"title": "First Week", "subtitle": "Complete 7 consecutive days"},
      {"title": "Soccer Starter", "subtitle": "Complete 10 soccer sessions"},
      {"title": "Zen Master", "subtitle": "Complete 5 wellness sessions"},
      {"title": "Consistency King", "subtitle": "Train for 30 days straight"},
      {"title": "First Week", "subtitle": "Complete 7 consecutive days"},
      {"title": "Soccer Starter", "subtitle": "Complete 10 soccer sessions"},
      {"title": "Zen Master", "subtitle": "Complete 5 wellness sessions"},
      {"title": "Consistency King", "subtitle": "Train for 30 days straight"},
    ];
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: commonText("Achievements", size: 21, isBold: true),
      ),
      body: GridView.builder(
        shrinkWrap: true,
        padding: EdgeInsets.all(16),
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
    );
  }
}

