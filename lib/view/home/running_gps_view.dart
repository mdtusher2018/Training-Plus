import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
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
final String apiKey = '506107e66ed04133be2159f7b7ea222d'; 
  MapController mapController = MapController();
  LatLng? _currentLocation;
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }
  Future<void> _getCurrentLocation() async {
    // Check permissions
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
      // Move the map to the user location
      mapController.move(userLocation, 18);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Map section (placeholder for now)
        FlutterMap(
        mapController: mapController,
        options: MapOptions(
          initialCenter: _currentLocation ?? LatLng(20.5937, 78.9629), // Default India
          initialZoom: 10,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            additionalOptions: {
              'apiKey': apiKey,
            },
          ),
          if (_currentLocation != null)
            MarkerLayer(
              markers: [
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
          Positioned(
            top: 70,left: 32,
            child: GestureDetector(
              onTap: () {
                Get.back();
              },
              child: Icon(Icons.arrow_back_ios_new)),
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
