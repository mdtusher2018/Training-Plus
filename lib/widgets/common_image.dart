import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/helper.dart';
import 'package:training_plus/widgets/common_text.dart';

class CommonImage extends StatelessWidget {
  final String imagePath;
  final double? width;
  final double? height;
  final BoxFit? fit;
  final bool isAsset;
  final bool isFile;
  final Duration fadeDuration;
  final Widget? placeholder;

  const CommonImage({
    super.key,
    required this.imagePath,
    this.width,
    this.height,
    this.fit,
    this.isAsset = false,
    this.isFile = false,
    this.fadeDuration = const Duration(milliseconds: 500),
    this.placeholder,
  });

  @override
  Widget build(BuildContext context) {
    final Widget imageWidget;

    if (isAsset) {
      imageWidget = Image.asset(
        imagePath,
        width: width?.w,
        height: height?.h,
        fit: fit,
        errorBuilder:
            (context, error, stackTrace) =>
                CommonImageErrorWidget(width: width ?? double.infinity),
      );
    } else if (isFile) {
      imageWidget = Image.file(
        File(imagePath),
        width: width?.w,
        height: height?.h,
        fit: fit,
        errorBuilder:
            (context, error, stackTrace) =>
                CommonImageErrorWidget(width: width ?? double.infinity),
      );
    } else {
      imageWidget = Image.network(
        getFullImagePath(imagePath),
        width: width?.w,
        height: height?.h,
        fit: fit,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return AnimatedOpacity(
              opacity: 1,
              duration: fadeDuration,
              child: child,
            );
          }
          return placeholder ??
              commonImagePlaceholderWidget(
                width: width?.w ?? double.infinity,
                height: height?.h ?? 150.h,
              );
        },
        errorBuilder:
            (context, error, stackTrace) =>
                CommonImageErrorWidget(width: width ?? double.infinity),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12.r),
      child: imageWidget,
    );
  }

  Widget commonImagePlaceholderWidget({
    double width = double.infinity,
    double height = 150,
  }) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      padding: EdgeInsets.all(16.r),
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: const CircularProgressIndicator(
        strokeWidth: 2,
        color: AppColors.primary,
      ),
    );
  }
}




class CommonImageErrorWidget extends StatelessWidget {
  final double width;
  final double iconSize;
  final String message;

  const CommonImageErrorWidget({
    super.key,
    this.width = double.infinity,
    this.iconSize = 48,
    this.message = "Image\nnot available",
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width.w,
      padding: EdgeInsets.all(16.r),
      color: Colors.grey.shade300,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Icon(Icons.broken_image, size: iconSize.sp, color: Colors.grey),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: CommonText(
              message,
              textAlign: TextAlign.center,
              isBold: true,
            ),
          ),
        ],
      ),
    );
  }
}
