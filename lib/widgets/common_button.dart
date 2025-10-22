


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/widgets/common_text.dart';

class CommonButton extends StatelessWidget {
  final String title;
  final Color color;
  final Color textColor;
  final double textSize;
  final double width;
  final double height;
  final VoidCallback? onTap;
  final TextAlign textalign;
  final BoxBorder? boarder;
  final double boarderRadious;
  final bool iconLeft;
  final Widget? iconWidget;
  final bool isLoading;
  final bool haveNextIcon;

  const CommonButton(
    this.title, {
    super.key,
    this.color = AppColors.primary,
    this.textColor = AppColors.textPrimary,
    this.textSize = 18,
    this.width = double.infinity,
    this.height = 40,
    this.onTap,
    this.textalign = TextAlign.left,
    this.boarder,
    this.boarderRadious = 50.0,
    this.iconLeft = true,
    this.iconWidget,
    this.isLoading = false,
    this.haveNextIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: height.h,
        width: width.w,
        constraints: const BoxConstraints(minHeight: 50),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(boarderRadious.r)),
          color: isLoading ? color.withOpacity(0.5) : color,
          border: boarder,
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w),
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (iconWidget != null && iconLeft) iconWidget!,
                  CommonText(
                    textAlign: textalign,
                    isLoading ? "Loading..." : title,
                    size: textSize,
                    color: textColor,
                    fontWeight: FontWeight.w500,
                  ),
                  if (haveNextIcon)
                    Padding(
                      padding: EdgeInsets.all(8.r),
                      child: Container(
                        padding: EdgeInsets.all(2.0.r),
                        decoration: BoxDecoration(
                          color: AppColors.mainBG.withOpacity(0.4),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          color: textColor,
                          size: 24.sp,
                        ),
                      ),
                    ),
                  if (iconWidget != null && !iconLeft) iconWidget!,
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
