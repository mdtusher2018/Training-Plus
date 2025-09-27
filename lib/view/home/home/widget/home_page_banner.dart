import 'dart:async';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:training_plus/view/home/home/home_page_model.dart';
import 'package:training_plus/widgets/common_widgets.dart';

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
    if (widget.quotes.isEmpty) return commonSizedBox();

    final quote = widget.quotes[_currentIndex];

    return SizedBox(
      height: 160,
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
            borderRadius: BorderRadius.circular(12),
            color: Colors.transparent,
          ),
          child: Stack(
            fit: StackFit.expand,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: CommonImage(imagePath: quote.image, fit: BoxFit.cover,)
                
              
              ),
              // Container(
              //   decoration: BoxDecoration(
              //     borderRadius: BorderRadius.circular(12),
              //     color: Colors.black.withOpacity(0.3),
              //   ),
              // ),
              // Center(
              //   child: Padding(
              //     padding: const EdgeInsets.symmetric(horizontal: 12),
              //     child: AnimatedOpacity(
              //       opacity: 1.0,
              //       duration: const Duration(milliseconds: 800),
              //       child: commonText(
              //         quote.text,
              //         size: 14,
              //         color: Colors.white,
              //         textAlign: TextAlign.center,
              //         isBold: true,
              //         maxline: 5,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
