import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/helper.dart';

Widget commonText(
  String text, {
  double size = 12.0,
  Color color = Colors.black,
  bool isBold = false,
  softwarp,
  double? wordSpacing,
  maxline = 1000,
  bool haveUnderline = false,
  fontWeight,
  TextAlign textAlign = TextAlign.left,
}) {
  return Text(
    text,
    overflow: TextOverflow.ellipsis,
    maxLines: maxline,
    softWrap: softwarp,
    textAlign: textAlign,

    style: TextStyle(
      fontSize: size.sp,
      fontFamily: "EurostileExtendedBlack",
      decoration:
          (haveUnderline) ? TextDecoration.underline : TextDecoration.none,
      color: color,
      wordSpacing: wordSpacing,
      fontWeight:
          isBold
              ? FontWeight.bold
              : (fontWeight != null)
              ? fontWeight
              : FontWeight.normal,
    ),
  );
}

void commonSnackbar({
  required BuildContext context,
  required String title,
  required String message,
  bool isTop = false,
  Color backgroundColor = Colors.black,
  Color textColor = Colors.white,
  Duration duration = const Duration(seconds: 3),
}) {
  Flushbar(
    title: title,
    message: message,
    duration: duration,
    backgroundColor: backgroundColor,
    flushbarPosition: FlushbarPosition.TOP, // This shows it at top
    margin: EdgeInsets.all(8.r),
    borderRadius: BorderRadius.circular(8.r),
    titleColor: textColor,
    messageColor: textColor,
  ).show(context);

  // ScaffoldMessenger.of(context).showSnackBar(snackBar);
}

Widget commonTextfieldWithTitle(
  String title,
  TextEditingController controller, {
  FocusNode? focusNode,
  String hintText = "",
  bool isBold = true,
  bool issuffixIconVisible = false,
  bool isPasswordVisible = false,
  bool? enable,
  double textSize = 14.0,
  suffixIcon,
  borderWidth = 0.0,
  double? scale = 2.0,
  optional = false,
  changePasswordVisibility,
  TextInputType keyboardType = TextInputType.text,
  String? assetIconPath,
  Color borderColor = Colors.grey,
  int maxLine = 1,
  Function(String)? onsubmit,
  Function(String)? onChnage,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          commonText(
            title,
            size: textSize,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
          if (optional)
            commonText("(Optional)", size: textSize, color: Colors.grey),
        ],
      ),
      commonSizedBox(height: 8),
      Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(10.0.r),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0.r),
            border: Border.all(color: borderColor, width: borderWidth),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0.r),
            child: TextField(
              controller: controller,
              enabled: enable,
              focusNode: focusNode,
              style: TextStyle(
                fontSize: textSize.sp,
                color: AppColors.textSecondary,
                fontWeight: isBold ? FontWeight.w500 : FontWeight.normal,
              ),
              onChanged: onChnage,
              keyboardType: keyboardType,
              onSubmitted: onsubmit,
              maxLines: maxLine,
              obscureText: isPasswordVisible,
              decoration: InputDecoration(
                contentPadding: EdgeInsets.all(12.r),
                hintText: hintText,
                fillColor: AppColors.white,
                filled: true,

                hintStyle: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.textSecondary,
                ),
                border: InputBorder.none,
                suffixIcon:
                    (issuffixIconVisible)
                        ? (!isPasswordVisible)
                            ? InkWell(
                              onTap: changePasswordVisibility,
                              child: Icon(Icons.visibility),
                            )
                            : InkWell(
                              onTap: changePasswordVisibility,
                              child: Icon(Icons.visibility_off),
                            )
                        : suffixIcon,
                prefixIcon:
                    assetIconPath != null
                        ? Padding(
                          padding: EdgeInsets.all(10.0).r,
                          child: Image.asset(assetIconPath, scale: scale),
                        )
                        : null,
              ),
            ),
          ),
        ),
      ),
    ],
  );
}

void navigateToPage(
  Widget page, {
  required BuildContext context,
  bool replace = false,
  bool clearStack = false,
  Function(dynamic)? onPopCallback,
  Duration duration = const Duration(milliseconds: 600),
}) {
  PageRouteBuilder route = PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Fade transition
      return FadeTransition(opacity: animation, child: child);
    },
    transitionDuration: duration,
  );

  if (clearStack) {
    Navigator.of(context)
        .pushAndRemoveUntil(route, (route) => false)
        .then((value) => onPopCallback?.call(value));
  } else if (replace) {
    Navigator.of(
      context,
    ).pushReplacement(route).then((value) => onPopCallback?.call(value));
  } else {
    Navigator.of(
      context,
    ).push(route).then((value) => onPopCallback?.call(value));
  }
}

Widget commonButton(
  String title, {
  Color color = AppColors.primary,
  Color textColor = AppColors.textPrimary,
  double textSize = 18,
  double width = double.infinity,
  double height = 50,
  VoidCallback? onTap,
  TextAlign textalign = TextAlign.left,
  boarder,
  double boarderRadious = 50.0,
  bool iconLeft = true,
  Widget? iconWidget,
  bool isLoading = false,
  bool haveNextIcon = false,
}) {
  return GestureDetector(
    onTap: isLoading ? null : onTap,
    child: Container(
      height: height.h,
      width: width.w,
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
                if (iconWidget != null && iconLeft) iconWidget,
                commonText(
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
                if (iconWidget != null && !iconLeft) iconWidget,
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

Widget commonImageErrorWidget({
  double width = double.infinity,

  double iconSize = 48,
  String message = "Image\nnot available",
}) {
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
          child: commonText(message, textAlign: TextAlign.center, isBold: true),
        ),
      ],
    ),
  );
}

Widget buildOTPTextField(
  TextEditingController controller,
  int index,
  BuildContext context,
) {
  return Material(
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.r),
        color: AppColors.white,
        border: Border.all(width: 1.5.w, color: Colors.grey),
      ),

      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        cursorColor: Colors.black,
        style: TextStyle(fontSize: 20.sp),
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(8.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
        onChanged: (value) {
          if (value.length == 1 && index < 5) {
            FocusScope.of(context).nextFocus();
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).previousFocus();
          }
        },
      ),
    ),
  );
}

Widget commonTextField({
  TextEditingController? controller,
  String? hintText,
  int? minLine,
  bool? enabled,
  Color boarderColor = Colors.black,
  double boarderWidth = 1.0,
  TextInputType keyboardType = TextInputType.number,
  void Function(String)? onChanged,
  bool readOnly = false,
}) {
  return SizedBox(
    child: TextFormField(
      readOnly: readOnly,
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      minLines: minLine,
      maxLines: minLine,
      enabled: enabled,

      style: const TextStyle(fontSize: 14),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 12, color: AppColors.textSecondary),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: boarderColor, width: boarderWidth),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: boarderColor, width: boarderWidth),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: boarderColor, width: boarderWidth),
        ),
      ),
    ),
  );
}

Widget commonCheckbox({
  required bool value,
  required Function(bool?) onChanged,
  required String label,
}) {
  return Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      Checkbox(
        value: value,
        onChanged: onChanged,
        // activeColor: AppColors.primary,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4.r)),
        side: BorderSide(
          color: value ? AppColors.primary : Colors.grey,
          width: 2,
        ),
      ),
      if (label.isNotEmpty) Flexible(child: commonText(label, size: 14)),
    ],
  );
}

Widget commonDropdown<T>({
  required List<T> items,
  required T? value,
  required String hint,
  required void Function(T?) onChanged,
}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16.w),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12.r),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: DropdownButton<T>(
      isExpanded: true,
      underline: SizedBox(),
      value: value,
      icon: Icon(Icons.keyboard_arrow_down_rounded),
      hint: commonText(hint, size: 14),
      borderRadius: BorderRadius.circular(8.r),
      items:
          items.map<DropdownMenuItem<T>>((T item) {
            return DropdownMenuItem<T>(
              value: item,
              child: commonText(item.toString(), size: 14),
            );
          }).toList(),
      onChanged: onChanged,
    ),
  );
}

AppBar authAppBar(String title) {
  return AppBar(
    backgroundColor: AppColors.primary,
    elevation: 0,
    leading: IconButton(
      icon: const Icon(Icons.arrow_back, color: AppColors.white),
      onPressed: () {},
    ),
    title: commonText(title, size: 20, isBold: true, color: Colors.white),
    centerTitle: true,
  );
}

Widget commonCloseButton(BuildContext context) {
  return GestureDetector(
    onTap: () {
      Navigator.pop(context);
    },
    child: Container(
      padding: EdgeInsets.all(6.r),
      decoration: BoxDecoration(color: AppColors.boxBG, shape: BoxShape.circle),
      child: Icon(Icons.close),
    ),
  );
}

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
                commonImageErrorWidget(width: width ?? double.infinity),
      );
    } else if (isFile) {
      imageWidget = Image.file(
        File(imagePath),
        width: width?.w,
        height: height?.h,
        fit: fit,
        errorBuilder:
            (context, error, stackTrace) =>
                commonImageErrorWidget(width: width ?? double.infinity),
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
                commonImageErrorWidget(width: width ?? double.infinity),
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

class RichTextPart {
  final String text;
  final Color color;
  final double size;
  final bool isBold;
  final bool haveUnderline;
  final TextAlign? align;
  GestureRecognizer? clickRecognized;

  RichTextPart({
    required this.text,
    this.color = Colors.black,
    this.size = 12.0,
    this.clickRecognized,
    this.isBold = false,
    this.haveUnderline = false,
    this.align,
  });
}

Widget commonRichText({
  required List<RichTextPart> parts,
  TextAlign textAlign = TextAlign.left,
  int? maxLines,
  bool softWrap = true,
}) {
  return RichText(
    textAlign: textAlign,
    maxLines: maxLines,
    softWrap: softWrap,
    text: TextSpan(
      children:
          parts
              .map(
                (part) => TextSpan(
                  text: part.text,
                  recognizer: part.clickRecognized,
                  style: TextStyle(
                    wordSpacing: 3,
                    fontSize: part.size.sp,
                    fontFamily: "EurostileExtendedBlack",
                    color: part.color,
                    fontWeight:
                        part.isBold ? FontWeight.bold : FontWeight.normal,
                    decoration:
                        part.haveUnderline
                            ? TextDecoration.underline
                            : TextDecoration.none,
                  ),
                ),
              )
              .toList(),
    ),
  );
}

Widget commonSizedBox({double? height, double? width, Widget? child}) {
  return SizedBox(height: height?.h, width: width?.w, child: child);
}
