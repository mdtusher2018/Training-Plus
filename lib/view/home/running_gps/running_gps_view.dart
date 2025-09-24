import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:latlong2/latlong.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/helper.dart';
import 'package:training_plus/widgets/common_widgets.dart';

import '../home_providers.dart';

class RunningTrackerPage extends ConsumerStatefulWidget {
  const RunningTrackerPage({super.key});

  @override
  ConsumerState<RunningTrackerPage> createState() => _RunningTrackerPageState();
}

class _RunningTrackerPageState extends ConsumerState<RunningTrackerPage> {
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
  List<LatLng> _routePoints = [];
  final GlobalKey _mapKey = GlobalKey();

  void _fitMapToRoute() {
    if (_routePoints.length < 2) return;

    final bounds = LatLngBounds.fromPoints(_routePoints);
    mapController.fitCamera(
      CameraFit.bounds(
        bounds: bounds,
        padding: EdgeInsets.all(16),
        forceIntegerZoomLevel: true,
      ),
    );
  }


Future<String> _getPlaceName(LatLng location) async {
  try {
    log(location.longitude.toString());
    log(location.latitude.toString());

    List<Placemark> placemarks = await placemarkFromCoordinates(
      location.latitude,
      location.longitude,
    );

    if (placemarks.isNotEmpty) {
      final place = placemarks.first;

      // Safely handle nulls
      final locality = place.locality ?? place.subLocality ?? "";
      final country = place.country ?? "";

      if (locality.isNotEmpty && country.isNotEmpty) {
        return "$locality, $country";
      } else if (country.isNotEmpty) {
        return country;
      }
    }
  } catch (e) {
    log("Error fetching place name: $e");
  }
  return "Unknown place";
}




  Future<File> _bytesToFile(Uint8List bytes) async {
    final tempDir = await getTemporaryDirectory();
    final file = File("${tempDir.path}/run_map.png");
    await file.writeAsBytes(bytes);
    return file;
  }

  Future<Uint8List?> _captureMap() async {
    try {
      if (_mapKey.currentContext != null) {
        RenderRepaintBoundary boundary =
            _mapKey.currentContext!.findRenderObject() as RenderRepaintBoundary;

        final image = await boundary.toImage(pixelRatio: 3.0);
        final byteData = await image.toByteData(format: ImageByteFormat.png);
        return byteData?.buffer.asUint8List();
      }
    } catch (e) {
      debugPrint("Error capturing map: $e");
      return null;
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
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

      if (isRunning) {
        final d = Distance();
        // Only add point if moved more than 1 meters
        if (_lastLocation == null ||
            d.as(LengthUnit.Meter, _lastLocation!, userLocation) >= 1) {
          // Update distance only if we have a previous location
          if (_lastLocation != null) {
            final dist = d.as(
              LengthUnit.Kilometer,
              _lastLocation!,
              userLocation,
            );
            distance += dist;
            _calculatePace();
          }

          _routePoints.add(userLocation);
          _recalculateDistanceFromRoute();
        }
      }

      _lastLocation = userLocation;
    }
  }

  void _recalculateDistanceFromRoute() {
    if (_routePoints.length < 2) return;
    double total = 0.0;
    final d = Distance();

    for (int i = 0; i < _routePoints.length - 1; i++) {
      total += d.as(LengthUnit.Meter, _routePoints[i], _routePoints[i + 1]);
    }
    setState(() {
      distance = (total / 1000.0);
      _calculatePace(); // also update pace based on new distance
    });
  }

  void _calculatePace() {
    if (distance > 0) {
      int seconds = elapsedTime.inSeconds;
      double minutes = seconds / 60.0;
      log(minutes.toString());
      double paceValue = minutes / distance; // ⚠ can be NaN if distance == 0
      pace = paceValue.toStringAsFixed(5);
    } else {
      pace = "--";
    }
  }

  void _pauseRun() {
    setState(() {
      _getCurrentLocation();
      isRunning = false;
    });
    _locationUpdateTimer?.cancel();
    _timer?.cancel();
    commonSnackbar(context: context, title: "Paused", message: "Run paused");
  }

  void _resumeOrStartRun() async {
    if (_currentLocation == null) return;

    setState(() {
      // Only reset if starting a new run
      if (_startLocation == null) {
        _startLocation = _currentLocation;
        _lastLocation = _currentLocation;
        elapsedTime = Duration.zero;
        distance = 0.0;
        pace = "--";
        _routePoints.add(
          _startLocation ??
              LatLng(_currentLocation!.latitude, _currentLocation!.longitude),
        );
      }

      isRunning = true;
    });

    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isRunning) {
        setState(() {
          elapsedTime += const Duration(seconds: 1);
        });
        _calculatePace();
      }
    });

    _locationUpdateTimer?.cancel();
    _locationUpdateTimer = Timer.periodic(const Duration(seconds: 10), (timer) {
      _getCurrentLocation(moveCamera: false);
    });

    commonSnackbar(
      context: context,
      title: "Run Started",
      message: "Good luck!",
    );
  }

  void _stopRun() {
    if (_timer != null && _locationUpdateTimer != null) {
      _timer!.cancel();
      _locationUpdateTimer!.cancel();
    }
    setState(() {
      isRunning = false;
      elapsedTime = Duration.zero;
      // distance = 0.0;
      pace = "--";
      _routePoints.clear();
    });
    _getCurrentLocation();

    // Optionally show a snackbar
    commonSnackbar(
      context: context,
      title: "Run Stopped",
      message: "All data has been reset",
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          RepaintBoundary(
            key: _mapKey,
            child: FlutterMap(
              mapController: mapController,

              options: MapOptions(
                initialCenter: _currentLocation ?? LatLng(20.5937, 78.9629),
                initialZoom: 15,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  additionalOptions: {'apiKey': apiKey},
                ),
                if (_routePoints.length > 2)
                  PolylineLayer(
                    polylines: [
                      Polyline(
                        points:
                            _routePoints
                                .where(
                                  (p) =>
                                      p.latitude.isFinite &&
                                      p.longitude.isFinite,
                                )
                                .toList(),
                        strokeWidth: 4.0,
                        color: Colors.blue,
                      ),
                    ],
                  ),

                MarkerLayer(
                  markers: [
                    if (_startLocation != null)
                      Marker(
                        point: _startLocation!,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.flag,
                          color: Colors.green,
                          size: 36,
                        ),
                      ),
                    if (_currentLocation != null)
                      Marker(
                        point: _currentLocation!,
                        width: 40,
                        height: 40,
                        child: const Icon(
                          Icons.my_location,
                          color: Colors.blue,
                          size: 32,
                        ),
                      ),
                  ],
                ),
              ],
            ),
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
                      formatDuration(elapsedTime),
                      size: 28,
                      isBold: true,
                    ),
                    commonText(
                      "Running time",
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
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
                              _resumeOrStartRun();
                            }
                          },
                        ),
                        const SizedBox(width: 20),
                        _roundButton(Icons.stop, Colors.red, () async {
                          
                          _pauseRun();
                          _fitMapToRoute();

                          await Future.delayed(
                            const Duration(milliseconds: 500),
                          );

                          final imageBytes = await _captureMap();

                          if (imageBytes != null) {
                            final file = await _bytesToFile(
                              imageBytes,
                            ); // helper to save Uint8List as File
  final placeName = await _getPlaceName(_currentLocation??LatLng(-122.084, 37.4219983));
                            final result = await ref
                                .read(runningGpsControllerProvider.notifier)
                                .postRunningData(
                                  body: {
                                    "place":placeName ,
                                    "distance": distance,
                                    "time": elapsedTime.inSeconds,
                                    "pace": pace,
                                  },
                                  image: file,
                                );

                            if (result["success"] == true) {
                              _showRunCompleteSheet(context);
                            } else {
                              commonSnackbar(
                                context: context,
                                title: "Error",backgroundColor: AppColors.error,
                                message:
                                    result["message"] ?? "Something went wrong",
                              );
                            }
                          }
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
      isDismissible: false,
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
                  commonText(
                    formatDuration(elapsedTime),
                    size: 26,
                    isBold: true,
                    color: Colors.black,
                  ),
                  commonText(
                    "Running time",
                    size: 12,
                    color: AppColors.textSecondary,
                  ),
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
                        "🏃‍♂️ Running Complete!\nTime: ${formatDuration(elapsedTime)}\nDistance: ${distance.toStringAsFixed(2)} km\nPace: $pace min/km",
                      );
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
                      width: 2,
                      color: Colors.grey.withOpacity(0.3),
                    ),
                    width: double.infinity,
                    onTap: () {
                      Navigator.pop(context);
                      navigateToPage(
                        RunningTrackerPage(),
                        context: context,
                        replace: true,
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
              Positioned(right: 0, top: 0, child: commonCloseButton(context)),
            ],
          ),
        );
      },
    ).then((value) {
      _stopRun();
    });
  }
}
