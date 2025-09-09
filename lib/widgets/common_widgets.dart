import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

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
      fontSize: size,
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
  Color backgroundColor = Colors.black,
  Color textColor = Colors.white,
  Duration duration = const Duration(seconds: 3),
}) {
  final snackBar = SnackBar(
    content: Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          message,
          style: TextStyle(color: textColor),
        ),
      ],
    ),
    backgroundColor: backgroundColor,
    duration: duration,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
  );

  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}


Widget commonTextfieldWithTitle(
  String title,
  TextEditingController controller, {
  FocusNode? focusNode,
  String hintText = "",
  bool isBold = true,
  bool issuffixIconVisible = false,
  bool isPasswordVisible = false,
  enable,
  textSize = 14.0,
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
          commonText(title, size: textSize, fontWeight: FontWeight.w500,color: AppColors.textPrimary),
          if (optional)
            commonText("(Optional)", size: textSize, color: Colors.grey),
        ],
      ),
      const SizedBox(height: 8),
      Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(10.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            border: Border.all(color: borderColor, width: borderWidth),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: TextField(
              controller: controller,
              enabled: enable,
              focusNode: focusNode,
              onChanged: onChnage,
              keyboardType: keyboardType,
              onSubmitted: onsubmit,
              maxLines: maxLine,
              obscureText: isPasswordVisible,
              decoration: InputDecoration(
                contentPadding: const EdgeInsets.all(12.0),
                hintText: hintText,
                fillColor: AppColors.white,
                filled: true,
                hintStyle: TextStyle(fontSize: 14, color: AppColors.textSecondary),
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
                          padding: const EdgeInsets.all(10.0),
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
  Function? onTap,
  Duration duration = const Duration(milliseconds: 600),
}) {
  PageRouteBuilder route = PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      // Fade transition
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    transitionDuration: duration,
  );

  if (clearStack) {
    Navigator.of(context).pushAndRemoveUntil(route, (route) => false)
        .then((value) => onTap?.call(value));
  } else if (replace) {
    Navigator.of(context).pushReplacement(route)
        .then((value) => onTap?.call(value));
  } else {
    Navigator.of(context).push(route).then((value) => onTap?.call(value));
  }
}

Widget commonButton(
  String title, {
  Color? color = AppColors.primary,
  Color textColor = AppColors.textPrimary,
  double textSize = 18,
  double width = double.infinity,
  double height = 50,
  VoidCallback? onTap,
  TextAlign textalign = TextAlign.left,
  boarder,
  double boarderRadious = 50.0,
  bool iconLeft=true,
  Widget? iconWidget,
  bool isLoading = false,
  bool haveNextIcon = false,
}) {
  return GestureDetector(
    onTap: onTap,
    child: Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(boarderRadious)),
        color: color,
        border: boarder,
      ),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child:
              isLoading
                  ? const CircularProgressIndicator()
                  : FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (iconWidget != null && iconLeft) iconWidget,
                        commonText( 
                          textAlign: textalign,
                          title,
                          size: textSize,
                          color: textColor,
                          fontWeight: FontWeight.w500,
                        ),
                        if (haveNextIcon)
                          Padding(
                            padding: const EdgeInsets.only(left: 8.0),
                            child: Container(
                              padding: const EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                color: AppColors.mainBG.withOpacity(0.4),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              child: Icon(
                                Icons.arrow_forward_rounded,
                                color: textColor,
                                size: 24,
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
    width: width,
    
padding: EdgeInsets.all(16),
    color: Colors.grey.shade300,
    child: Stack(
alignment: Alignment.center,
      children: [
        Icon(Icons.broken_image, size: iconSize, color: Colors.grey),
   
        commonText(
          message,textAlign: TextAlign.center,
          isBold: true

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
        borderRadius: BorderRadius.circular(10),
        color: AppColors.white,
        border: Border.all(width: 1.5,color: Colors.grey)
    
      ),
    
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        cursorColor: Colors.black,
        style: const TextStyle(fontSize: 20),
        maxLength: 1,
        decoration: InputDecoration(
          counterText: '',
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(8),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent),
            borderRadius: BorderRadius.circular(8),
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

Widget commonNumberInputField({
  required String hintText,
  required int value,
  required TextEditingController controller,
  required Function(int) onChanged,
}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      commonText(hintText, size: 16, fontWeight: FontWeight.w500),
      SizedBox(height: 4),
      Container(
        margin: const EdgeInsets.symmetric(vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 4)],
        ),
        child: Row(
          children: [
            SizedBox(width: 10),
            Expanded(
              child: TextField(
                controller: controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: hintText,
                  hintStyle: const TextStyle(color: Colors.grey),
                  isCollapsed: true,
                  contentPadding: const EdgeInsets.symmetric(vertical: 8),
                ),
                onChanged: (text) {
                  final parsed = int.tryParse(text);
                  if (parsed != null) {
                    onChanged(parsed);
                  }
                },
                style: const TextStyle(fontSize: 14),
              ),
            ),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                InkWell(
                  child: const Icon(Icons.arrow_drop_up_outlined),
                  onTap: () {
                    final current = int.tryParse(controller.text) ?? 0;
                    final updated = current + 1;
                    controller.text = updated.toString();
                    onChanged(updated);
                  },
                ),
                InkWell(
                  child: const Icon(Icons.arrow_drop_down),
                  onTap: () {
                    final current = int.tryParse(controller.text) ?? 0;
                    if (current > 0) {
                      final updated = current - 1;
                      controller.text = updated.toString();
                      onChanged(updated);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

Widget commonTextField({
  TextEditingController? controller,
  String? hintText,
  int? minLine,
  bool? enabled,
  Color boarderColor=Colors.black,
  double boarderWidth=1.0,
  TextInputType keyboardType = TextInputType.number,
  void Function(String)? onChanged,
}) {
  return SizedBox(
 
    child: TextField(
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
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: boarderColor,width: boarderWidth),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
             borderSide: BorderSide(color: boarderColor,width: boarderWidth),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: boarderColor,width: boarderWidth),
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
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        side: BorderSide(
          color: value ? AppColors.primary : Colors.grey,
          width: 2,
        ),
      ),
      if (label.isNotEmpty)
        Flexible(child: commonText(label, size: 14)),
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
    padding: EdgeInsets.symmetric(horizontal: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.grey.shade300),
    ),
    child: DropdownButton<T>(
      isExpanded: true,
      underline: SizedBox(),
      value: value,
      icon: Icon(Icons.keyboard_arrow_down_rounded),
      hint: commonText(hint, size: 14),
      borderRadius: BorderRadius.circular(8),
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


Widget commonCloseButton(){
  return GestureDetector(
    onTap: () {
      // pop
    },
    child: Container(
      padding: EdgeInsets.all(6),
      decoration: BoxDecoration(color: AppColors.boxBG,shape: BoxShape.circle),
      child: Icon(Icons.close)),
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
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            commonImageErrorWidget(width: width ?? double.infinity),
      );
    } else if (isFile) {
      imageWidget = Image.file(
        File(imagePath),
        width: width,
        height: height,
        fit: fit,
        errorBuilder: (context, error, stackTrace) =>
            commonImageErrorWidget(width: width ?? double.infinity),
      );
    } else {
      imageWidget = Image.network(
        getFullImagePath(imagePath),
        width: width,
        height: height,
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
                width: width ?? double.infinity,
                height: height ?? 150,
              );
        },
        errorBuilder: (context, error, stackTrace) =>
            commonImageErrorWidget(width: width ?? double.infinity),
      );
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
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
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.grey.shade200,
      borderRadius: BorderRadius.circular(12),
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
      children: parts
          .map(
            (part) => TextSpan(
              text: part.text,recognizer: part.clickRecognized,
              style: TextStyle(wordSpacing: 3,
                fontSize: part.size,
                fontFamily: "EurostileExtendedBlack",
                color: part.color,
                fontWeight: part.isBold ? FontWeight.bold : FontWeight.normal,
                decoration: part.haveUnderline ? TextDecoration.underline : TextDecoration.none,
              ),
            ),
          )
          .toList(),
    ),
  );
}



