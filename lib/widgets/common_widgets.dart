import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/helper.dart';

class commonText extends StatelessWidget {
  final String text;
  final double size;
  final Color color;
  final bool isBold;
  final bool? softwarp;
  final double? wordSpacing;
  final int maxline;
  final bool haveUnderline;
  final FontWeight? fontWeight;
  final TextAlign textAlign;

  const commonText(
    this.text, {
    super.key,
    this.size = 12.0,
    this.color = Colors.black,
    this.isBold = false,
    this.softwarp,
    this.wordSpacing,
    this.maxline = 1000,
    this.haveUnderline = false,
    this.fontWeight,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
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
            haveUnderline ? TextDecoration.underline : TextDecoration.none,
        color: color,
        wordSpacing: wordSpacing,
        fontWeight:
            isBold ? FontWeight.bold : (fontWeight ?? FontWeight.normal),
      ),
    );
  }
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

class commonTextfieldWithTitle extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  final FocusNode? focusNode;
  final String hintText;
  final bool isBold;
  final bool issuffixIconVisible;
  final bool isPasswordVisible;
  final bool? enable;
  final double textSize;
  final Widget? suffixIcon;
  final double borderWidth;
  final double? scale;
  final bool optional;
  final VoidCallback? changePasswordVisibility;
  final TextInputType keyboardType;
  final String? assetIconPath;
  final Color borderColor;
  final int maxLine;
  final Function(String)? onsubmit;
  final Function(String)? onChnage;

  const commonTextfieldWithTitle(
    this.title,
    this.controller, {
    super.key,
    this.focusNode,
    this.hintText = "",
    this.isBold = true,
    this.issuffixIconVisible = false,
    this.isPasswordVisible = false,
    this.enable,
    this.textSize = 14.0,
    this.suffixIcon,
    this.borderWidth = 0.0,
    this.scale = 2.0,
    this.optional = false,
    this.changePasswordVisibility,
    this.keyboardType = TextInputType.text,
    this.assetIconPath,
    this.borderColor = Colors.grey,
    this.maxLine = 1,
    this.onsubmit,
    this.onChnage,
  });

  @override
  Widget build(BuildContext context) {
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
                                child: const Icon(Icons.visibility),
                              )
                              : InkWell(
                                onTap: changePasswordVisibility,
                                child: const Icon(Icons.visibility_off),
                              )
                          : suffixIcon,
                  prefixIcon:
                      assetIconPath != null
                          ? Padding(
                            padding: const EdgeInsets.all(10.0).r,
                            child: Image.asset(assetIconPath!, scale: scale),
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
}

// voidcontext.navigateTo(
//   Widget page, {
//   required BuildContext context,
//   bool replace = false,
//   bool clearStack = false,
//   Function(dynamic)? onPopCallback,
//   Duration duration = const Duration(milliseconds: 600),
// }) {
//   PageRouteBuilder route = PageRouteBuilder(
//     pageBuilder: (context, animation, secondaryAnimation) => page,
//     transitionsBuilder: (context, animation, secondaryAnimation, child) {
//       // Fade transition
//       return FadeTransition(opacity: animation, child: child);
//     },
//     transitionDuration: duration,
//   );

//   if (clearStack) {
//     Navigator.of(context)
//         .pushAndRemoveUntil(route, (route) => false)
//         .then((value) => onPopCallback?.call(value));
//   } else if (replace) {
//     Navigator.of(
//       context,
//     ).pushReplacement(route).then((value) => onPopCallback?.call(value));
//   } else {
//     Navigator.of(
//       context,
//     ).push(route).then((value) => onPopCallback?.call(value));
//   }
// }

class commonButton extends StatelessWidget {
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

  const commonButton(
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

class commonImageErrorWidget extends StatelessWidget {
  final double width;
  final double iconSize;
  final String message;

  const commonImageErrorWidget({
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
            child: commonText(
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

class buildOTPTextField extends StatelessWidget {
  final TextEditingController controller;
  final int index;
  final BuildContext context;

  const buildOTPTextField(
    this.controller,
    this.index,
    this.context, {
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
    );
  }
}

class commonTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final int? minLine;
  final bool? enabled;
  final Color boarderColor;
  final double boarderWidth;
  final TextInputType keyboardType;
  final void Function(String)? onChanged;
  final bool readOnly;

  const commonTextField({
    super.key,
    this.controller,
    this.hintText,
    this.minLine,
    this.enabled,
    this.boarderColor = Colors.black,
    this.boarderWidth = 1.0,
    this.keyboardType = TextInputType.number,
    this.onChanged,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: TextFormField(
        readOnly: readOnly,
        controller: controller,
        onChanged: onChanged,
        keyboardType: keyboardType,
        minLines: minLine,
        maxLines: minLine,
        enabled: enabled,
        style: TextStyle(fontSize: 14.sp),
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
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
}

class commonCheckbox extends StatelessWidget {
  final bool value;
  final Function(bool?) onChanged;
  final String label;

  const commonCheckbox({
    super.key,
    required this.value,
    required this.onChanged,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Checkbox(
          value: value,
          onChanged: onChanged,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(4.r),
          ),
          side: BorderSide(
            color: value ? AppColors.primary : Colors.grey,
            width: 2,
          ),
        ),
        if (label.isNotEmpty) Flexible(child: commonText(label, size: 14)),
      ],
    );
  }
}

class commonDropdown<T> extends StatelessWidget {
  final List<T> items;
  final T? value;
  final String hint;
  final void Function(T?) onChanged;
  final double? itemHeight;

  const commonDropdown({
    super.key,
    required this.items,
    required this.value,
    required this.hint,
    required this.onChanged,
    this.itemHeight,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: Colors.grey.shade300, width: 1.w),
      ),
      child: DropdownButton<T>(
        isExpanded: true,
        underline: const SizedBox(),
        value: value,
        icon: Icon(Icons.keyboard_arrow_down_rounded, size: 20.sp),
        hint: commonText(hint, size: 14.sp),
        borderRadius: BorderRadius.circular(8.r),
        itemHeight: itemHeight ?? 48.h,
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
}

class authAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;

  const authAppBar(this.title, {super.key});

  @override
  Widget build(BuildContext context) {
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

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class commonCloseButton extends StatelessWidget {
  final BuildContext context;

  const commonCloseButton(this.context, {super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(this.context);
      },
      child: Container(
        padding: EdgeInsets.all(6.r),
        decoration: BoxDecoration(
          color: AppColors.boxBG,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.close),
      ),
    );
  }
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

class commonRichText extends StatelessWidget {
  final List<RichTextPart> parts;
  final TextAlign textAlign;
  final int? maxLines;
  final bool softWrap;

  const commonRichText({
    super.key,
    required this.parts,
    this.textAlign = TextAlign.left,
    this.maxLines,
    this.softWrap = true,
  });

  @override
  Widget build(BuildContext context) {
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
}

class commonSizedBox extends StatelessWidget {
  final double? height;
  final double? width;
  final Widget? child;

  const commonSizedBox({super.key, this.height, this.width, this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height?.h, width: width?.w, child: child);
  }
}

class commonErrorMassage extends StatelessWidget {
  final BuildContext context;
  final String massage;

  const commonErrorMassage({
    super.key,
    required this.context,
    required this.massage,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      children: [
        SizedBox(
          height: MediaQuery.of(this.context).size.height * 0.8,
          child: Center(
            child: commonText(massage, size: 16, color: AppColors.error),
          ),
        ),
      ],
    );
  }
}
