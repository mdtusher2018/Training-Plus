
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


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

class CommonRichText extends StatelessWidget {
  final List<RichTextPart> parts;
  final TextAlign textAlign;
  final int? maxLines;
  final bool softWrap;

  const CommonRichText({
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
