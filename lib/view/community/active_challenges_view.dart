import 'package:flutter/material.dart';

import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/view/community/widget/community_cards.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class ActiveChallengesView extends StatefulWidget {
  const ActiveChallengesView({super.key});

  @override
  State<ActiveChallengesView> createState() => _ActiveChallengesViewState();
}

class _ActiveChallengesViewState extends State<ActiveChallengesView> {


  final List<Map<String, dynamic>> challenges = [
    {
      'title': "7 Day Soccer Challenge",
      'status': "Joined",
      'participants': 234,
      'daysLeft': 3,
      'progress': 5 / 7,
    },
    {
      'title': "Wellness Week",
      'status': "Join",
      'participants': 189,
      'daysLeft': 3,
      'progress': null,
    },
    {
      'title': "21 Day Meditation Challenge",
      'status': "Join",
      'participants': 234,
      'daysLeft': 3,
      'progress': null,
    }, {
      'title': "Wellness Week",
      'status': "Join",
      'participants': 189,
      'daysLeft': 3,
      'progress': null,
    },
    {
      'title': "21 Day Meditation Challenge",
      'status': "Join",
      'participants': 234,
      'daysLeft': 3,
      'progress': null,
    }, {
      'title': "Wellness Week",
      'status': "Join",
      'participants': 189,
      'daysLeft': 3,
      'progress': null,
    },
    {
      'title': "21 Day Meditation Challenge",
      'status': "Join",
      'participants': 234,
      'daysLeft': 3,
      'progress': null,
    },
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
      body: ListView.builder(
        shrinkWrap: true,
        padding: const EdgeInsets.all(16),
        itemCount: challenges.length,
        itemBuilder: (context, index) {
          final challenge = challenges[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: challengeCard(
              title:  challenge['title'],
              isJoined:  challenge['status'],
              count:  challenge['participants'],
              days:  challenge['daysLeft'],
              points:  challenge['progress'],
              onTap: () {
                showChallengeDetailsBottomSheet(context,isJoined: challenge['progress']==null);
              },
            ),
          );
        },
      ), 
    );
  
  }
}