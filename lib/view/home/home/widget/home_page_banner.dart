import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_plus/view/home/home/home_page_model.dart';
import 'package:training_plus/widgets/common_sized_box.dart';
import 'package:training_plus/widgets/common_image.dart';

class QuoteBanner extends StatefulWidget {
  final List<Quote> quotes;

  const QuoteBanner({super.key, required this.quotes});

  @override
  State<QuoteBanner> createState() => _QuoteBannerState();
}

class _QuoteBannerState extends State<QuoteBanner> {
  int _currentIndex = 0;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    log(widget.quotes.length.toString());

    if (widget.quotes.length > 1) {
      _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % widget.quotes.length;
        });
      });
    }
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.quotes.isEmpty) return CommonSizedBox();

    final quote = widget.quotes[_currentIndex];

    return SizedBox(
      height: 100.sp,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 800),
        switchInCurve: Curves.easeIn,
        switchOutCurve: Curves.easeOut,
        transitionBuilder: (child, animation) {
          return FadeTransition(
            opacity: animation,
            child: child,
          );
        },
        child: Container(
          key: ValueKey(quote.id),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: Colors.transparent,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: CommonImage(imagePath: quote.image, fit: BoxFit.cover,)
                
              
              ),
            ],
          ),
        ),
      ),
    );
  }
}
