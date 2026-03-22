import 'dart:async';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:latlong2/latlong.dart' as latlong2;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/core/utils/extention.dart';
import 'package:training_plus/core/utils/helper.dart';
import 'package:training_plus/widgets/common_sized_box.dart';
import 'package:training_plus/widgets/common_close_button.dart';
import 'package:training_plus/widgets/common_text.dart';
import 'package:training_plus/widgets/common_button.dart';
import 'package:training_plus/widgets/common_image.dart';

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

  // Google Maps controller
  GoogleMapController? _googleMapController;

  LatLng? _currentLocation;
  LatLng? _startLocation;
  LatLng? _lastLocation;

  Timer? _locationUpdateTimer;
  Timer? _timer;

  // Google Maps uses its own LatLng — keep route as List<LatLng>
  final List<LatLng> _routePoints = [];

  // For map screenshot
  final GlobalKey _mapKey = GlobalKey();

  // Markers shown on Google Map
  final Set<Marker> _markers = {};

  // Polyline drawn on Google Map
  final Set<Polyline> _polylines = {};

  // ── Map helpers ──────────────────────────────────────────────────────────────

  void _fitMapToRoute() {
    if (_routePoints.length < 2 || _googleMapController == null) return;

    double minLat = _routePoints
        .map((p) => p.latitude)
        .reduce((a, b) => a < b ? a : b);
    double maxLat = _routePoints
        .map((p) => p.latitude)
        .reduce((a, b) => a > b ? a : b);
    double minLng = _routePoints
        .map((p) => p.longitude)
        .reduce((a, b) => a < b ? a : b);
    double maxLng = _routePoints
        .map((p) => p.longitude)
        .reduce((a, b) => a > b ? a : b);

    final bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    _googleMapController!.animateCamera(
      CameraUpdate.newLatLngBounds(bounds, 48.0),
    );
  }

  void _updateMapOverlays() {
    final Set<Marker> newMarkers = {};
    final Set<Polyline> newPolylines = {};

    if (_startLocation != null) {
      newMarkers.add(
        Marker(
          markerId: const MarkerId('start'),
          position: _startLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
          infoWindow: const InfoWindow(title: 'Start'),
        ),
      );
    }

    if (_currentLocation != null) {
      newMarkers.add(
        Marker(
          markerId: const MarkerId('current'),
          position: _currentLocation!,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueAzure,
          ),
          infoWindow: const InfoWindow(title: 'You'),
        ),
      );
    }

    if (_routePoints.length > 1) {
      newPolylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points:
              _routePoints
                  .where((p) => p.latitude.isFinite && p.longitude.isFinite)
                  .toList(),
          color: Colors.blue,
          width: 4,
        ),
      );
    }

    setState(() {
      _markers
        ..clear()
        ..addAll(newMarkers);
      _polylines
        ..clear()
        ..addAll(newPolylines);
    });
  }

  // ── Place name ───────────────────────────────────────────────────────────────

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

  // ── Map screenshot ───────────────────────────────────────────────────────────

  Future<Uint8List?> _captureMap() async {
    try {
      if (_googleMapController != null) {
        // Google Maps native screenshot
        final bytes = await _googleMapController!.takeSnapshot();
        return bytes;
      }
      // Fallback: RepaintBoundary screenshot
      if (_mapKey.currentContext != null) {
        RenderRepaintBoundary boundary =
            _mapKey.currentContext!.findRenderObject() as RenderRepaintBoundary;
        final image = await boundary.toImage(pixelRatio: 3.0);
        final byteData = await image.toByteData(format: ImageByteFormat.png);
        return byteData?.buffer.asUint8List();
      }
    } catch (e) {
      debugPrint("Error capturing map: $e");
    }
    return null;
  }

  Future<File> _bytesToFile(Uint8List bytes) async {
    final tempDir = await getTemporaryDirectory();
    final file = File("${tempDir.path}/run_map.png");
    await file.writeAsBytes(bytes);
    return file;
  }

  // ── Lifecycle ────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _locationUpdateTimer?.cancel();
    _googleMapController?.dispose();
    super.dispose();
  }

  // ── Location tracking ────────────────────────────────────────────────────────

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

      final userLocation = LatLng(position.latitude, position.longitude);

      setState(() {
        _currentLocation = userLocation;
      });

      if (moveCamera && _googleMapController != null) {
        _googleMapController!.animateCamera(
          CameraUpdate.newLatLngZoom(userLocation, 18),
        );
      }

      if (isRunning) {
        final d = latlong2.Distance();
        final lastLatLng =
            _lastLocation == null
                ? null
                : latlong2.LatLng(
                  _lastLocation!.latitude,
                  _lastLocation!.longitude,
                );
        final userLatLng = latlong2.LatLng(
          userLocation.latitude,
          userLocation.longitude,
        );

        if (lastLatLng == null ||
            d.as(latlong2.LengthUnit.Meter, lastLatLng, userLatLng) >= 1) {
          _routePoints.add(userLocation);
          _recalculateDistanceFromRoute();
        }
      }

      _lastLocation = userLocation;
      _updateMapOverlays();
    }
  }

  void _recalculateDistanceFromRoute() {
    if (_routePoints.length < 2) return;
    double total = 0.0;
    final d = latlong2.Distance();

    for (int i = 0; i < _routePoints.length - 1; i++) {
      total += d.as(
        latlong2.LengthUnit.Meter,
        latlong2.LatLng(_routePoints[i].latitude, _routePoints[i].longitude),
        latlong2.LatLng(
          _routePoints[i + 1].latitude,
          _routePoints[i + 1].longitude,
        ),
      );
    }
    setState(() {
      distance = total / 1000.0;
      _calculatePace();
    });
  }

  void _calculatePace() {
    if (distance > 0) {
      int seconds = elapsedTime.inSeconds;
      double minutes = seconds / 60.0;
      log(minutes.toString());
      double paceValue = minutes / distance;
      pace = paceValue.toStringAsFixed(5);
    } else {
      pace = "--";
    }
  }

  // ── Run controls ─────────────────────────────────────────────────────────────

  void _pauseRun() {
    setState(() {
      isRunning = false;
    });
    _locationUpdateTimer?.cancel();
    _timer?.cancel();
    _getCurrentLocation();
    context.showCommonSnackbar(title: "Paused", message: "Run paused");
  }

  void _resumeOrStartRun() async {
    if (_currentLocation == null) return;

    setState(() {
      if (_startLocation == null) {
        _startLocation = _currentLocation;
        _lastLocation = _currentLocation;
        elapsedTime = Duration.zero;
        distance = 0.0;
        pace = "--";
        _routePoints.add(_currentLocation!);
      }
      isRunning = true;
    });

    _updateMapOverlays();

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

    context.showCommonSnackbar(title: "Run Started", message: "Good luck!");
  }

  void _stopRun() {
    _timer?.cancel();
    _locationUpdateTimer?.cancel();
    setState(() {
      isRunning = false;
      elapsedTime = Duration.zero;
      pace = "--";
      _routePoints.clear();
      _startLocation = null;
      _lastLocation = null;
    });
    _updateMapOverlays();
    _getCurrentLocation();
    context.showCommonSnackbar(
      title: "Run Stopped",
      message: "All data has been reset",
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // ── Google Map ──
          RepaintBoundary(
            key: _mapKey,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: _currentLocation ?? const LatLng(20.5937, 78.9629),
                zoom: 15,
              ),
              onMapCreated: (controller) {
                _googleMapController = controller;
                // Move camera once controller is ready
                if (_currentLocation != null) {
                  controller.animateCamera(
                    CameraUpdate.newLatLngZoom(_currentLocation!, 18),
                  );
                }
              },
              markers: _markers,
              polylines: _polylines,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
              compassEnabled: false,
            ),
          ),

          // ── Back button ──
          Positioned(
            top: 70,
            left: 32,
            child: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: const Icon(Icons.arrow_back_ios_new),
            ),
          ),

          // ── Bottom controls ──
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
              child: Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CommonText(
                      formatDuration(elapsedTime),
                      size: 28,
                      isBold: true,
                    ),
                    CommonText(
                      "Running time",
                      size: 14,
                      color: AppColors.textSecondary,
                    ),
                    CommonSizedBox(height: 12),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _statItem(distance.toStringAsFixed(2), "Distance (km)"),
                        _statItem(pace, "Pace (min/km)"),
                      ],
                    ),
                    CommonSizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _roundButton(
                          isRunning ? Icons.pause : Icons.play_arrow,
                          Colors.yellow.shade700,
                          () {
                            if (isRunning) {
                              _pauseRun();
                            } else {
                              _resumeOrStartRun();
                            }
                          },
                        ),
                        CommonSizedBox(width: 20),
                        _roundButton(
                          ref.watch(runningGpsControllerProvider).isLoading
                              ? const Center(child: CircularProgressIndicator())
                              : const Icon(Icons.stop),
                          Colors.red,
                          () async {
                            if (!isRunning && _routePoints.isEmpty) return;

                            _pauseRun();
                            _fitMapToRoute();

                            // Small delay so the camera animation completes before snapshot
                            await Future.delayed(
                              const Duration(milliseconds: 600),
                            );

                            final imageBytes = await _captureMap();

                            if (imageBytes != null) {
                              final file = await _bytesToFile(imageBytes);
                              final placeName = await _getPlaceName(
                                _currentLocation ??
                                    const LatLng(-122.084, 37.4219983),
                              );
                              final result = await ref
                                  .read(runningGpsControllerProvider.notifier)
                                  .postRunningData(
                                    body: {
                                      "place": placeName,
                                      "distance": distance,
                                      "time": elapsedTime.inSeconds,
                                      "pace": pace,
                                    },
                                    image: file,
                                  );

                              if (result["success"] == true) {
                                _showRunCompleteSheet(
                                  context,
                                  image: file,
                                  userId: result["userId"] ?? "",
                                  runId: result["runId"] ?? "",
                                  imageUrl: result["imageUrl"] ?? "",
                                  place: result["place"],
                                );
                              } else {
                                context.showCommonSnackbar(
                                  title: "Error",
                                  backgroundColor: AppColors.error,
                                  message:
                                      result["message"] ??
                                      "Something went wrong",
                                );
                              }
                            }
                          },
                        ),
                      ],
                    ),
                    CommonSizedBox(height: 10),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Helpers ───────────────────────────────────────────────────────────────────

  Widget _statItem(String value, String label) {
    return Column(
      children: [
        CommonText(value, size: 18, isBold: true, color: Colors.black),
        CommonText(label, size: 12, color: AppColors.textSecondary),
      ],
    );
  }

  Widget _roundButton(dynamic icon, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        child:
            icon is Widget ? icon : Icon(icon, color: Colors.white, size: 28),
      ),
    );
  }

  void _showRunCompleteSheet(
    BuildContext context, {
    required File image,
    required String runId,
    required String userId,
    required String imageUrl,
    required String place,
  }) {
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
                spacing: 8,
                mainAxisSize: MainAxisSize.min,
                children: [
                  CommonImage(
                    imagePath: "assest/images/home/tophy.png",
                    isAsset: true,
                    width: 70.sp,
                    height: 70.sp,
                  ),
                  CommonText("Running Complete", size: 18, isBold: true),
                  CommonText("Great Workout !", size: 16),
                  CommonText(
                    formatDuration(elapsedTime),
                    size: 26,
                    isBold: true,
                    color: Colors.black,
                  ),
                  CommonText(
                    "Running time",
                    size: 12,
                    color: AppColors.textSecondary,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _statItem(distance.toStringAsFixed(2), "Distance (km)"),
                      _statItem(pace, "Pace (min/km)"),
                    ],
                  ),
                  CommonButton(
                    "  Share Results",
                    iconWidget: const Icon(Icons.share),
                    width: double.infinity,
                    onTap: () async {
                      final Uri shareUri = Uri.parse(
                        ApiEndpoints.runSharingUrl(runId),
                      );
                      await Share.shareUri(shareUri);
                    },
                  ),
                  CommonButton(
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
                      context.navigateTo(RunningTrackerPage(), replace: true);
                    },
                  ),
                ],
              ),
              Positioned(right: 0, top: 0, child: CommonCloseButton(context)),
            ],
          ),
        );
      },
    ).then((_) => _stopRun());
  }
}
