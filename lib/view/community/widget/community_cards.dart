  import 'package:flutter/material.dart';
import 'package:training_plus/utils/colors.dart';
import 'package:training_plus/widgets/common_widgets.dart';

Widget challengeCard(String title, String status, int participants, int daysLeft, double? progress) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              commonText(title, size: 14, isBold: true),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: status == "Joined" ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(width: 1,color: Colors.grey.withOpacity(0.5))
                ),
                child: commonText(status, size: 12,),
              )
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.groups, size: 16,color: AppColors.primary,),
              const SizedBox(width: 4),
              commonText("$participants Participations", size: 12),
              const SizedBox(width: 12),
              commonText("$daysLeft Days Left", size: 12),
            ],
          ),
          if (progress != null) ...[
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                commonText("Progress", size: 12,color: AppColors.textSecondary),
                commonText("5/7 Days", size: 12,color: AppColors.textSecondary),
              ],
            ),
            const SizedBox(height: 4),
            LinearProgressIndicator(
              value: progress,minHeight: 12,
              borderRadius: BorderRadius.circular(16),
              backgroundColor: AppColors.boxBG,
              color: AppColors.primary,
            ),
          ],
        ],
      ),
    );
  }
