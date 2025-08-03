import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:training_plus/utils/colors.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class RunningTrackerPage extends StatefulWidget {
  const RunningTrackerPage({super.key});

  @override
  State<RunningTrackerPage> createState() => _RunningTrackerPageState();
}

class _RunningTrackerPageState extends State<RunningTrackerPage> {
  String runningTime = "01:09:44";
  double distance = 10.9;
  double pace = 12.4;
bool isRunning=false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Map section (placeholder for now)
          SizedBox(
            height: double.infinity,
            child: Center(
              child: Image.network(
                "https://media.wired.com/photos/59269cd37034dc5f91bec0f1/3:2/w_960,c_limit/GoogleMapTA.jpg",
                fit: BoxFit.cover,
                height: double.infinity,
                width: double.infinity,
              ),
            ),
          ),

          // Bottom stats section with blur
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30), // blur only inside container
              child: Container(
                padding: const EdgeInsets.all(16),
            
              
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    commonText(runningTime,
                        size: 28, isBold: true, ),
                    commonText("Running time", size: 14, color: AppColors.textSecondary),
                    const SizedBox(height: 12),

                    // Distance & Pace Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _statItem(distance.toString(), "Distance (km)"),
                        _statItem(pace.toString(), "Pace (min/km)"),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Control Buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _roundButton((isRunning)?Icons.pause:Icons.play_arrow, Colors.yellow.shade700, () {
                          setState(() {
                            isRunning=!isRunning;
                          });
                          
                          if(isRunning){ 
                              commonSnackbar(
                                title: "Run Started", message: "Good luck!");}
                                else{
                              commonSnackbar(
                                title: "Paused", message: "Run paused");
                              }
                        }),
                  
                        const SizedBox(width: 20),
                        _roundButton(Icons.stop, Colors.red, () {
                          _showRunCompleteSheet(context);
                        }),
                      ],
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        commonText(value, size: 18, isBold: true, color: Colors.black),
        commonText(label, size: 12, color: AppColors.textSecondary),
      ],
    );
  }

  Widget _roundButton(IconData icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
        child: Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }

  void _showRunCompleteSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Stack(
            children: [
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CommonImage(imagePath: "assest/images/home/tophy.png",isAsset: true,width: 70,height: 70,),
                  const SizedBox(height: 4),
                  commonText("Running Complete", size: 18, isBold: true),
                  const SizedBox(height: 4),
                  commonText("Great Workout !", size: 16, ),
                  const SizedBox(height: 12),
                  commonText(runningTime,
                      size: 26, isBold: true, color: Colors.black),
                  commonText("Running time", size: 12, color: AppColors.textSecondary),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _statItem(distance.toString(), "Distance (km)"),
                      _statItem(pace.toString(), "Pace (min/km)"),
                    ],
                  ),
                  const SizedBox(height: 16),
                  commonButton(
                    "  Share Results",
              iconWidget: Icon(Icons.share),
                    width: double.infinity,
                    onTap: () {
                      Share.share(
                          "🏃‍♂️ Running Complete!\nTime: $runningTime\nDistance: $distance km\nPace: $pace min/km");
                    },
                  ),
                  const SizedBox(height: 16),
                  commonButton(
                    "  Start New Run",
                    color: Colors.transparent,
                    iconWidget: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(3.1416), // pi radians
                      child: Icon(Icons.replay_sharp),
                    ),
                    boarder: Border.all(width: 2,color: Colors.grey.withOpacity(0.3)),
                    width: double.infinity,
                    onTap: () {
                      Navigator.pop(context); // Close sheet
                    
                    },
                  ),   const SizedBox(height: 16),
                ],
              ),
          
          Positioned(
            right: 0,
            top: 0,
            child: commonCloseButton()
          )
            ],
          ),
        );
      },
    );
  }



}
