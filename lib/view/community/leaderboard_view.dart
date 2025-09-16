import 'package:flutter/material.dart';

import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/view/community/widget/community_cards.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class LeaderboardView extends StatefulWidget {
  const LeaderboardView({super.key});

  @override
  State<LeaderboardView> createState() => _LeaderboardViewState();
}

class _LeaderboardViewState extends State<LeaderboardView> {

    final leaders = [
      ["Jordan Lee", 1350],
      ["Sarah Smith", 1270],
      ["Morgan Davis", 1210],
      ["Jamie Brown", 1150],
      ["Casey Taylor", 1050],
      ["Jordan Lee", 1350],
      ["Sarah Smith", 1270],
      ["Morgan Davis", 1210],
      ["Jamie Brown", 1150],
      ["Casey Taylor", 1050],
      ["Jordan Lee", 1350],
      ["Sarah Smith", 1270],
      ["Morgan Davis", 1210],
      ["Jamie Brown", 1150],
      ["Casey Taylor", 1050],
      ["Jordan Lee", 1350],
      ["Sarah Smith", 1270],
      ["Morgan Davis", 1210],
      ["Jamie Brown", 1150],
      ["Casey Taylor", 1050],
    ];

  @override
  Widget build(BuildContext context) {
      return Scaffold(
      backgroundColor: AppColors.boxBG,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: AppColors.boxBG,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Icon(Icons.arrow_back_ios_new)),
        title: commonText("Active Community", size: 20, isBold: true),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: SingleChildScrollView(
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          
            ...leaders.asMap().entries.map((entry) {
              final index = entry.key;
              final name = entry.value[0];
              final points = entry.value[1];
              return leaderboardCard(points: points as num, index: index, name: name as String,image: "");
            })
          ],
              ),
        ),
      )
    );
  
  }
}