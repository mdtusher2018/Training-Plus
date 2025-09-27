import 'package:flutter/material.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/helper.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class RecentSessionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String tag;
  final String tagImageUrl; // <-- Network image URL
  final VoidCallback? onTap;

  const RecentSessionCard({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.tagImageUrl,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
     color: AppColors.boxBG,
          borderRadius: BorderRadius.circular(8),
     
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  commonText(title, size: 14, fontWeight: FontWeight.w600),
                  commonSizedBox(height: 6),
                  commonText(subtitle, size: 12, color: AppColors.textSecondary),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
       color: AppColors.white,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Row(
                children: [
                  Image.network(
                    getFullImagePath(tagImageUrl),
                    width: 16,
                    height: 16,
                    errorBuilder: (_, __, ___) => const Icon(Icons.image_not_supported),
                  ),
                  SizedBox(width: 4,),
                  commonText(tag,size: 12)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
