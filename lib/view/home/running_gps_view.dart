// import 'dart:ui';
// import 'package:flutter/material.dart';
// import 'package:flutter_map/flutter_map.dart';
// import 'package:geolocator/geolocator.dart';
// 
// import 'package:latlong2/latlong.dart';
// import 'package:share_plus/share_plus.dart';
// import 'package:training_plus/utils/colors.dart';
// import 'package:training_plus/widgets/common_widgets.dart';
// class RunningTrackerPage extends StatefulWidget {
//   const RunningTrackerPage({super.key});
//   @override
//   State<RunningTrackerPage> createState() => _RunningTrackerPageState();
// }
// class _RunningTrackerPageState extends State<RunningTrackerPage> {
//   String runningTime = "01:09:44";
//   double distance = 10.9;
//   double pace = 12.4;
// bool isRunning=false;
// final String apiKey = '506107e66ed04133be2159f7b7ea222d';
//   MapController mapController = MapController();
//   LatLng? _currentLocation;
//   @override
//   void initState() {
//     super.initState();
//     _getCurrentLocation();
//   }
//   Future<void> _getCurrentLocation() async {
//     // Check permissions
//     LocationPermission permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied ||
//         permission == LocationPermission.deniedForever) {
//       permission = await Geolocator.requestPermission();
//     }
//     if (permission == LocationPermission.whileInUse ||
//         permission == LocationPermission.always) {
//       Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );
//       LatLng userLocation = LatLng(position.latitude, position.longitude);
//       setState(() {
//         _currentLocation = userLocation;
//       });
//       // Move the map to the user location
//       mapController.move(userLocation, 18);
//     }
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         alignment: Alignment.bottomCenter,
//         children: [
//           // Map section (placeholder for now)
//         FlutterMap(
//         mapController: mapController,
//         options: MapOptions(
//           initialCenter: _currentLocation ?? LatLng(20.5937, 78.9629), // Default India
//           initialZoom: 10,
//         ),
//         children: [
//           TileLayer(
//             urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
//             additionalOptions: {
//               'apiKey': apiKey,
//             },
//           ),
//           if (_currentLocation != null)
//             MarkerLayer(
//               markers: [
//                 Marker(
//                   point: _currentLocation!,
//                   width: 40,
//                   height: 40,
//                   child: const Icon(Icons.my_location,
//                       color: Colors.blue, size: 32),
//                 ),
//               ],
//             ),
//         ],
//       ),
//           Positioned(
//             top: 70,left: 32,
//             child: GestureDetector(
//               onTap: () {
//                 Navigator.pop(context);
//               },
//               child: Icon(Icons.arrow_back_ios_new)),
//           ),
//           // Bottom stats section with blur
//           ClipRRect(
//             borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
//             child: BackdropFilter(
//               filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30), // blur only inside container
//               child: Container(
//                 padding: const EdgeInsets.all(16),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     commonText(runningTime,
//                         size: 28, isBold: true, ),
//                     commonText("Running time", size: 14, color: AppColors.textSecondary),
//                     const SizedBox(height: 12),
//                     // Distance & Pace Row
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: [
//                         _statItem(distance.toString(), "Distance (km)"),
//                         _statItem(pace.toString(), "Pace (min/km)"),
//                       ],
//                     ),
//                     const SizedBox(height: 20),
//                     // Control Buttons
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.center,
//                       children: [
//                         _roundButton((isRunning)?Icons.pause:Icons.play_arrow, Colors.yellow.shade700, () {
//                           setState(() {
//                             isRunning=!isRunning;
//                           });
//                           if(isRunning){
//                               commonSnackbar(context: context,
//                                 title: "Run Started", message: "Good luck!");}
//                                 else{
//                               commonSnackbar(context: context,
//                                 title: "Paused", message: "Run paused");
//                               }
//                         }),
//                         const SizedBox(width: 20),
//                         _roundButton(Icons.stop, Colors.red, () {
//                           _showRunCompleteSheet(context);
//                         }),
//                       ],
//                     ),
//                     const SizedBox(height: 10),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//   Widget _statItem(String value, String label) {
//     return Column(
//       children: [
//         commonText(value, size: 18, isBold: true, color: Colors.black),
//         commonText(label, size: 12, color: AppColors.textSecondary),
//       ],
//     );
//   }
//   Widget _roundButton(IconData icon, Color color, VoidCallback onTap) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 56,
//         height: 56,
//         decoration: BoxDecoration(
//           shape: BoxShape.circle,
//           color: color,
//         ),
//         child: Icon(icon, color: Colors.white, size: 28),
//       ),
//     );
//   }
//   void _showRunCompleteSheet(BuildContext context) {
//     showModalBottomSheet(
//       context: context,
//       backgroundColor: Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
//       ),
//       builder: (context) {
//         return Padding(
//           padding: const EdgeInsets.all(16),
//           child: Stack(
//             children: [
//               Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   CommonImage(imagePath: "assest/images/home/tophy.png",isAsset: true,width: 70,height: 70,),
//                   const SizedBox(height: 4),
//                   commonText("Running Complete", size: 18, isBold: true),
//                   const SizedBox(height: 4),
//                   commonText("Great Workout !", size: 16, ),
//                   const SizedBox(height: 12),
//                   commonText(runningTime,
//                       size: 26, isBold: true, color: Colors.black),
//                   commonText("Running time", size: 12, color: AppColors.textSecondary),
//                   const SizedBox(height: 12),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                     children: [
//                       _statItem(distance.toString(), "Distance (km)"),
//                       _statItem(pace.toString(), "Pace (min/km)"),
//                     ],
//                   ),
//                   const SizedBox(height: 16),
//                   commonButton(
//                     "  Share Results",
//               iconWidget: Icon(Icons.share),
//                     width: double.infinity,
//                     onTap: () {
//                       Share.share(
//                           "🏃‍♂️ Running Complete!\nTime: $runningTime\nDistance: $distance km\nPace: $pace min/km");
//                     },
//                   ),
//                   const SizedBox(height: 16),
//                   commonButton(
//                     "  Start New Run",
//                     color: Colors.transparent,
//                     iconWidget: Transform(
//                       alignment: Alignment.center,
//                       transform: Matrix4.rotationY(3.1416), // pi radians
//                       child: Icon(Icons.replay_sharp),
//                     ),
//                     boarder: Border.all(width: 2,color: Colors.grey.withOpacity(0.3)),
//                     width: double.infinity,
//                     onTap: () {
//                       Navigator.pop(context); // Close sheet
//                     },
//                   ),   const SizedBox(height: 16),
//                 ],
//               ),
//           Positioned(
//             right: 0,
//             top: 0,
//             child: commonCloseButton()
//           )
//             ],
//           ),
//         );
//       },
//     );
//   }
// }
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';

import 'package:latlong2/latlong.dart';
import 'package:share_plus/share_plus.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class RunningTrackerPage extends StatefulWidget {
  const RunningTrackerPage({super.key});
  @override
  State<RunningTrackerPage> createState() => _RunningTrackerPageState();
}

class _RunningTrackerPageState extends State<RunningTrackerPage> {
  Duration elapsedTime = Duration.zero;
  double distance = 0.0; // in km
  String pace = "--"; // min/km
  bool isRunning = false;

  final String apiKey = '506107e66ed04133be2159f7b7ea222d';
  MapController mapController = MapController();

  LatLng? _currentLocation;
  LatLng? _startLocation;
  LatLng? _lastLocation;

  Timer? _locationUpdateTimer;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _locationUpdateTimer?.cancel();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _getCurrentLocation({bool moveCamera = true}) async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      LatLng userLocation = LatLng(position.latitude, position.longitude);

      setState(() {
        _currentLocation = userLocation;
      });

      if (moveCamera) {
        mapController.move(userLocation, 18);
      }

      // distance calculation (if last location exists)
      if (isRunning && _lastLocation != null) {
        final dist = Distance().as(
          LengthUnit.Kilometer,
          _lastLocation!,
          userLocation,
        );
        distance += dist;
        _calculatePace();
      }
      _lastLocation = userLocation;
    }
  }

  void _calculatePace() {
    if (distance > 0) {
      double minutes = elapsedTime.inSeconds / 60;
      double paceValue = minutes / distance;
      pace = paceValue.toStringAsFixed(2); // min/km
    } else {
      pace = "--";
    }
  }

  void _startRun() {
    if (_currentLocation != null) {
      setState(() {
        _startLocation = _currentLocation;
        _lastLocation = _currentLocation;
        isRunning = true;
        elapsedTime = Duration.zero;
        distance = 0.0;
        pace = "--";
      });

      // Timer for run time
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (isRunning) {
          setState(() {
            elapsedTime += const Duration(seconds: 1);
          });
          _calculatePace();
        }
      });

      // Timer for GPS updates every 20s
      _locationUpdateTimer?.cancel();
      _locationUpdateTimer =
          Timer.periodic(const Duration(seconds: 20), (timer) {
        _getCurrentLocation(moveCamera: false);
      });

      commonSnackbar(context: context,title: "Run Started", message: "Good luck!");
    }
  }

  void _pauseRun() {
    setState(() {
      isRunning = false;
    });
    _locationUpdateTimer?.cancel();
    _timer?.cancel();
    commonSnackbar(context: context,title: "Paused", message: "Run paused");
  }

  String _formatDuration(Duration d) {
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String h = twoDigits(d.inHours);
    String m = twoDigits(d.inMinutes.remainder(60));
    String s = twoDigits(d.inSeconds.remainder(60));
    return "$h:$m:$s";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          FlutterMap(
            mapController: mapController,
            options: MapOptions(
              initialCenter: _currentLocation ?? LatLng(20.5937, 78.9629),
              initialZoom: 10,
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                additionalOptions: {'apiKey': apiKey},
              ),
              MarkerLayer(
                markers: [
                  if (_startLocation != null)
                    Marker(
                      point: _startLocation!,
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.flag,
                          color: Colors.green, size: 36),
                    ),
                  if (_currentLocation != null)
                    Marker(
                      point: _currentLocation!,
                      width: 40,
                      height: 40,
                      child: const Icon(Icons.my_location,
                          color: Colors.blue, size: 32),
                    ),
                ],
              ),
            ],
          ),

          // Back Button
          Positioned(
            top: 70,
            left: 32,
            child: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back_ios_new),
            ),
          ),

          // Bottom controls
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    commonText(
                      _formatDuration(elapsedTime),
                      size: 28,
                      isBold: true,
                    ),
                    commonText("Running time",
                        size: 14, color: AppColors.textSecondary),
                    const SizedBox(height: 12),

                    // Distance & Pace
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _statItem(distance.toStringAsFixed(2), "Distance (km)"),
                        _statItem(pace, "Pace (min/km)"),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Play/Pause + Stop
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _roundButton(
                          (isRunning) ? Icons.pause : Icons.play_arrow,
                          Colors.yellow.shade700,
                          () {
                            if (isRunning) {
                              _pauseRun();
                            } else {
                              _startRun();
                            }
                          },
                        ),
                        const SizedBox(width: 20),
                        _roundButton(Icons.stop, Colors.red, () {
                          _pauseRun();
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
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
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
                  CommonImage(
                    imagePath: "assest/images/home/tophy.png",
                    isAsset: true,
                    width: 70,
                    height: 70,
                  ),
                  const SizedBox(height: 4),
                  commonText("Running Complete", size: 18, isBold: true),
                  const SizedBox(height: 4),
                  commonText("Great Workout !", size: 16),
                  const SizedBox(height: 12),
                  commonText(_formatDuration(elapsedTime),
                      size: 26, isBold: true, color: Colors.black),
                  commonText("Running time",
                      size: 12, color: AppColors.textSecondary),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _statItem(distance.toStringAsFixed(2), "Distance (km)"),
                      _statItem(pace, "Pace (min/km)"),
                    ],
                  ),
                  const SizedBox(height: 16),
                  commonButton(
                    "  Share Results",
                    iconWidget: const Icon(Icons.share),
                    width: double.infinity,
                    onTap: () {
                      Share.share(
                          "🏃‍♂️ Running Complete!\nTime: ${_formatDuration(elapsedTime)}\nDistance: ${distance.toStringAsFixed(2)} km\nPace: $pace min/km");
                    },
                  ),
                  const SizedBox(height: 16),
                  commonButton(
                    "  Start New Run",
                    color: Colors.transparent,
                    iconWidget: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.rotationY(3.1416),
                      child: const Icon(Icons.replay_sharp),
                    ),
                    boarder: Border.all(
                        width: 2, color: Colors.grey.withOpacity(0.3)),
                    width: double.infinity,
                    onTap: () {
                      Navigator.pop(context);
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
              Positioned(right: 0, top: 0, child: commonCloseButton())
            ],
          ),
        );
      },
    );
  }
}
