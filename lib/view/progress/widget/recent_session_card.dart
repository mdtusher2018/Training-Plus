import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/helper.dart';
import 'package:training_plus/widgets/common_sized_box.dart';
import 'package:training_plus/widgets/common_text.dart';

class RecentSessionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String tag;
  final String tagImageUrl; // <-- Network image URL
  final VoidCallback? onTap;

  const RecentSessionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.tagImageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Container(
        padding:EdgeInsets.all(16.r),
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
                  CommonText(title, size: 14, fontWeight: FontWeight.w600),
                  CommonSizedBox(height: 6),
                  CommonText(subtitle, size: 12, color: AppColors.textSecondary),
                ],
              ),
            ),
            Container(
              padding:  EdgeInsets.all(4.sp),
              decoration: BoxDecoration(
       color: AppColors.white,
                borderRadius: BorderRadius.circular(4.r),
              ),
              child: Row(
                children: [
                  Image.network(
                    getFullImagePath(tagImageUrl),
                    width: 16.sp,
                    height: 16.sp,
                    errorBuilder: (_, __, ___) => Icon(Icons.image_not_supported,size: 20.sp,),
                  ),
                  SizedBox(width: 4,),
                  CommonText(tag,size: 12)
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
