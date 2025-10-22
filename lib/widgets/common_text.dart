
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class CommonText extends StatelessWidget {
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

  const CommonText(
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
