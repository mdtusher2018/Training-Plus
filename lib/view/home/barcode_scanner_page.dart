import 'dart:convert';
import 'dart:developer';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner_plus/flutter_barcode_scanner_plus.dart';
import 'package:training_plus/core/services/localstorage/i_local_storage_service.dart';
import 'package:training_plus/core/services/localstorage/storage_key.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/widgets/common_widgets.dart';
import 'package:http/http.dart' as http;

class BarcodeDemoPage extends StatefulWidget {
  const BarcodeDemoPage({super.key});

  @override
  State<BarcodeDemoPage> createState() => _BarcodeDemoPageState();
}

class _BarcodeDemoPageState extends State<BarcodeDemoPage> {
  String _scanResult = 'No scan yet';
  String _barcodeToShow = '3017620425035';

  final TextEditingController mealNameController = TextEditingController();
  final TextEditingController caloriesController = TextEditingController();
  final TextEditingController proteinsController = TextEditingController();
  final TextEditingController carbsController = TextEditingController();
  final TextEditingController fatController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      startScan();
    });
  }

  Future<void> startScan() async {
    try {
      final result = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        true,
        ScanMode.BARCODE,
      );

      if (!mounted) return;

      setState(() {
        _scanResult = result == '-1' ? 'Scan cancelled' : result;
        _barcodeToShow = result == '-1' ? _barcodeToShow : result;
      });
      if (_barcodeToShow.isNotEmpty) {
        sendScanDataToOpenFood(barcode: _barcodeToShow).then((value) {
          showManualEntrySheet();
        });
      } else {
        showFoodNotFoundSheet();
      }
    } catch (e) {
      setState(() {
        _scanResult = 'Error: $e';
      });
    }
  }

  void updateBarcodeText(String val) {
    setState(() {
      _barcodeToShow = val.trim().isEmpty ? '' : val.trim();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: commonText("Product Scan", size: 21, isBold: true),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _barcodeToShow.isNotEmpty
                  ? SizedBox(
                    height: 100,
                    width: 200,
                    child: BarcodeWidget(
                      data: _barcodeToShow,
                      barcode: Barcode.code128(),
                    ),
                  )
                  : commonButton(
                    "Scan Again",
                    iconLeft: true,
                    onTap: () {
                      setState(() {
                        startScan();
                      });
                    },
                  ),
            ],
          ),
        ),
      ),
    );
  }

  //======================================================================send scan data ot openfoodfats

  Future sendScanDataToOpenFood({required String barcode}) async {
    const apiUrl = 'https://world.openfoodfacts.org/api/v2/product/';
    const userAgent = 'TrainingPlus/1.0 (training-plus)';
    final String url = '$apiUrl$barcode.json?user_agent=$userAgent';

    try {
      var response = await http.get(
        Uri.parse(url),
        headers: {'User-Agent': userAgent, 'Content-Type': 'application/json'},
      );

      log("=========response===$response");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1 && data['product'] != null) {
          final product = data['product'];

          mealNameController.text = product['product_name'] ?? '';
          caloriesController.text =
              product['nutriments'] != null
                  ? product['nutriments']['energy-kcal'].toString()
                  : "0";
          proteinsController.text =
              product['nutriments'] != null
                  ? product['nutriments']['proteins'].toString()
                  : "0";
          carbsController.text =
              product['nutriments'] != null
                  ? product['nutriments']['carbohydrates'].toString()
                  : "0";
          fatController.text =
              product['nutriments'] != null
                  ? product['nutriments']['fat'].toString()
                  : "0";

          log("mealname=================${mealNameController.text}");
          log("calories=================${caloriesController.text}");
          log("protein=================${proteinsController.text}");
          log("carbs=================${carbsController.text}");
          log("fats=================${fatController.text}");
        } else {}
      } else {}
    } catch (e) {
      return {"title": "Error", "message": e.toString()};
    }
  }

  //=====================================================================send data to backend

  late ILocalStorageService localStorage;

  Future sendScanDataToBackend() async {
    const apiUrl = 'http://10.10.10.33:8041/api/v1/nutration/add';

    final token = await localStorage.getString(StorageKey.token);

    final body = {
      "mealName": mealNameController.text,
      "calories": int.parse(caloriesController.text),
      "proteins": double.parse(proteinsController.text),
      "carbs": double.parse(carbsController.text),
      "fats": double.parse(fatController.text),
    };

    try {
      var response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode(body),
        headers: {
          'Authorization': "Bearer $token",
          'Content-Type': 'application/json',
        },
      );

      log("=========response===$response");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == 1 && data['product'] != null) {
          final product = data['product'];

          mealNameController.text = product['product_name'] ?? '';
          caloriesController.text =
              product['nutriments'] != null
                  ? product['nutriments']['energy-kcal'].toString()
                  : "0";
          proteinsController.text =
              product['nutriments'] != null
                  ? product['nutriments']['proteins'].toString()
                  : "0";
          carbsController.text =
              product['nutriments'] != null
                  ? product['nutriments']['carbohydrates'].toString()
                  : "0";
          fatController.text =
              product['nutriments'] != null
                  ? product['nutriments']['fat'].toString()
                  : "0";

          log("mealname=================${mealNameController.text}");
          log("calories=================${caloriesController.text}");
          log("protein=================${proteinsController.text}");
          log("carbs=================${carbsController.text}");
          log("fats=================${fatController.text}");
        } else {}
      } else {}
    } catch (e) {
      return {"title": "Error", "message": e.toString()};
    }
  }

  //==========================================================show food not found sheet
  void showFoodNotFoundSheet() {
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
                children: [commonCloseButton(context)],
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
                  child: Icon(Icons.add_box_rounded, size: 32),
                ),
                onTap: () {
                  Navigator.pop(context);
                  showManualEntrySheet();
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  //=====================================================================show manual entry sheet
  void showManualEntrySheet() {
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
                  Center(child: commonText("Manual Entry", size: 18)),
                  const SizedBox(height: 20),
                  commonTextField(
                    controller: mealNameController,
                    hintText: "Meal Name (e.g., Grilled Chicken)",
                  ),
                  const SizedBox(height: 16),

                  // Calories & Proteins
                  Row(
                    children: [
                      Expanded(
                        child: commonTextField(
                          controller: caloriesController,
                          keyboardType: TextInputType.number,
                          hintText: "Calories",
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: commonTextField(
                          controller: proteinsController,
                          keyboardType: TextInputType.number,
                          hintText: "Proteins (g)",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Carbs & Fat
                  Row(
                    children: [
                      Expanded(
                        child: commonTextField(
                          controller: carbsController,
                          keyboardType: TextInputType.number,
                          hintText: "Carbs (g)",
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: commonTextField(
                          controller: fatController,
                          keyboardType: TextInputType.number,
                          hintText: "Fat (g)",
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Add Food Data Button
                  commonButton(
                    "Add Food Data",
                    onTap: () {
                      // Navigator.of(context).popUntil((route) => route.isFirst);
                      sendScanDataToBackend();
                   
                    },
                  ),
                ],
              ),
            ),
            Positioned(top: 8, right: 16, child: commonCloseButton(context)),
          ],
        );
      },
    );
  }
}
