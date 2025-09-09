// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:async';

import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class CameraView extends StatefulWidget {
  const CameraView({super.key});

  @override
  State<CameraView> createState() => _CameraViewState();
}

class _CameraViewState extends State<CameraView>
    with SingleTickerProviderStateMixin {
  CameraController? _controller;
  Future<void>? _initializeControllerFuture;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    _setupCamera();

    // Animation for scanning line
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  Future<void> _setupCamera() async {
    final cameras = await availableCameras();
    final firstCamera = cameras.first;

    _controller = CameraController(
      firstCamera,
      ResolutionPreset.high,
    );

    _initializeControllerFuture = _controller!.initialize();
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _controller?.dispose();
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
   
      body: _controller == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder(
              future: _initializeControllerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Stack(
                    children: [
                      // Live camera preview
                      Positioned.fill(
                        child: CameraPreview(_controller!),
                      ),
                      // Dark overlay with transparent scanning area
                      _buildScannerOverlay(context),

                      // Cancel button
                      Positioned(
                        top: 50,
                        left: 20,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: const Icon(Icons.close,
                              color: AppColors.error, size: 48),
                        ),
                      ),

                      // Capture button
                      Positioned(
                        bottom: 80,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: GestureDetector(
                            onTap: _capturePhoto,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                Container(
                                  width: 70,
                                  height: 70,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color: Colors.white, width: 5),
                                  ),
                                ),
                                Container(
                              width: 50,
                              height: 60,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              
                              ),
                            ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
    );
  }


Widget _buildScannerOverlay(BuildContext context) {
  double scanWidth = 280;
  double scanHeight = 400;
  double top = (MediaQuery.of(context).size.height - scanHeight) / 2;
  double left = (MediaQuery.of(context).size.width - scanWidth) / 2;

  return Stack(
    children: [
      // Semi-transparent dark overlay
      ColorFiltered(
        colorFilter:
            ColorFilter.mode(Colors.black.withOpacity(0.2), BlendMode.srcOut),
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Colors.black,
                backgroundBlendMode: BlendMode.dstOut,
              ),
            ),
            Positioned(
              left: left,
              top: top,
              child: Container(
                width: scanWidth,
                height: scanHeight,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
          ],
        ),
      ),

      // Corner borders only
      Positioned(
        left: left,
        top: top,
        child: CustomPaint(
          size: Size(scanWidth, scanHeight),
          painter: CornerBorderPainter(),
        ),
      ),

      // Animated scanning line
   AnimatedBuilder(
  animation: _animationController,
  builder: (context, child) {
    return Positioned(
      left: left,
      top: top + (_animationController.value * (scanHeight - 80)),
      child: Container(
        width: scanWidth,
        height: 80,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white10,
                  Colors.white24,
               Colors.white10,
            ],
          ),
        ),
      ),
    );
  },
)

    ],
  );
}



Future<void> _capturePhoto() async {
  try {
    await _initializeControllerFuture;
    final image = await _controller!.takePicture();
    debugPrint("Photo captured: ${image.path}");

    if (mounted) {
      _showFoodNotFoundSheet();
    }
  } catch (e) {
    debugPrint("Error capturing photo: $e");
  }
}

void _showFoodNotFoundSheet() {
  showModalBottomSheet(
    context: context,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    backgroundColor: AppColors.white,
    builder: (context) {
      return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                commonCloseButton(),
              ],
            ),
            commonText(
              "Food Data\nNot Found!",
              size: 32,
              isBold: true,
          
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            commonText(
              "Add Manually",
              size: 16,
              isBold: true,
              color: AppColors.black,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            commonButton(
              "Add Manually",
              iconLeft: true,
            iconWidget: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: Icon(Icons.add_box_rounded,size: 32,),
            ),
      
               onTap: () {
                Navigator.pop(context);
                _showManualEntrySheet();
              },
            ),
            const SizedBox(height: 10),
          ],
        ),
      );
    },
  );
}




void _showManualEntrySheet() {
  final TextEditingController mealNameController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();
  final TextEditingController proteinsController = TextEditingController();
  final TextEditingController carbsController = TextEditingController();
  final TextEditingController fatController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
   
    builder: (context) {
      return Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(
              left: 20,
              right: 20,
              top: 20,
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: commonText(
                    "Manual Entry",
                    size: 18,
                  
                  ),
                ),
                const SizedBox(height: 20),
          
               
                commonTextField(
                  controller: mealNameController,
                  hintText: "Meal Name (e.g., Grilled Chicken)"
                ),
                const SizedBox(height: 16),
          
                // Calories & Proteins
                Row(
                  children: [
                    Expanded(
                      child: commonTextField(
                            controller: caloriesController,
                            keyboardType: TextInputType.number,
                            hintText: "Calories"
                          ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child:    commonTextField(
                            controller: proteinsController,
                            keyboardType: TextInputType.number,
                            hintText: "Proteins (g)"
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
          
                // Carbs & Fat
                Row(
                  children: [
                    Expanded(
                      child:  commonTextField(
                            controller: carbsController,
                            keyboardType: TextInputType.number,
                           hintText: "Carbs (g)"
                          ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child:  commonTextField(
                            controller: fatController,
                            keyboardType: TextInputType.number,
                            hintText: "Fat (g)"
                          ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
          
                // Add Food Data Button
                commonButton(
                  "Add Food Data",
             
                  onTap: () {
                     Navigator.of(context).popUntil((route) => route.isFirst);
                    
                    debugPrint(
                        "Meal: ${mealNameController.text}, Calories: ${caloriesController.text}, Protein: ${proteinsController.text}, Carbs: ${carbsController.text}, Fat: ${fatController.text}");
                  },
                ),
              ],
            ),
          ),
       Positioned(
        top: 8,right: 16,
        child: commonCloseButton())
       
        ],
      );
    },
  );
}

}



class CornerBorderPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round; // Rounded ends

    double radius = 30; // corner arc radius

    // Top-left corner
    canvas.drawArc(
      Rect.fromCircle(center: Offset(radius, radius), radius: radius),
      3.14, // start angle (180°)
      1.57, // sweep angle (90°)
      false,
      paint,
    );

    // Top-right corner
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width - radius, radius), radius: radius),
      -1.57, // start angle (-90°)
      1.57, // sweep angle (90°)
      false,
      paint,
    );

    // Bottom-left corner
    canvas.drawArc(
      Rect.fromCircle(center: Offset(radius, size.height - radius), radius: radius),
      1.57, // start angle (90°)
      1.57, // sweep angle (90°)
      false,
      paint,
    );

    // Bottom-right corner
    canvas.drawArc(
      Rect.fromCircle(center: Offset(size.width - radius, size.height - radius), radius: radius),
      0, // start angle (0°)
      1.57, // sweep angle (90°)
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

