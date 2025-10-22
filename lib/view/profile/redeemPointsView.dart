import 'package:flutter/material.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/widgets/common_text.dart';

class RedeemPointsview extends StatefulWidget {
  const RedeemPointsview({super.key});

  @override
  State<RedeemPointsview> createState() => _RedeemPointsviewState();
}

class _RedeemPointsviewState extends State<RedeemPointsview> {


 final List<Map<String, dynamic>> runs = const [
    {
      "title": "Training Plus Sticker Pack",
      "points": 300,
      "redeem":false
    },
       {
      "title": "Training Plus Sticker Pack",
      "points": 300,
      "redeem":false
    },
       {
      "title": "Training Plus Sticker Pack",
      "points": 300,
      "redeem":true
    },
       {
      "title": "Training Plus Sticker Pack",
      "points": 300,
      "redeem":true
    },
       {
      "title": "Training Plus Sticker Pack",
      "points": 300,
      "redeem":true
    },
   
  ];



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: CommonText(
          'Redeem Points',
          size: 21,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: ListView.separated(itemBuilder: (context, index) {
        final run = runs[index];
        return ListTile(
title: CommonText(run["title"], size: 16),
subtitle: CommonText("${run["points"]} Points", size: 14,color: AppColors.textSecondary),
trailing: Opacity(
  opacity:(run['redeem']==true)? 0.5:1,
  child: Container(
    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 8),
    decoration: BoxDecoration(color: AppColors.primary,borderRadius: BorderRadius.circular(25)),
    child: CommonText("Redeem",size: 12),
  ),
),
        );
      }, separatorBuilder: (context, index) => SizedBox(height: 16,), itemCount: runs.length),
    );
  }
}