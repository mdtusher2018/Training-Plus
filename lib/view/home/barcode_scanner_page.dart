import 'dart:convert';
import 'dart:developer';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner_plus/flutter_barcode_scanner_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/view/home/home_providers.dart';
import 'package:training_plus/widgets/common_widgets.dart';
import 'package:http/http.dart' as http;

class BarcodeDemoPage extends ConsumerStatefulWidget {
  const BarcodeDemoPage({super.key});

  @override
  ConsumerState<BarcodeDemoPage> createState() => _BarcodeDemoPageState();
}

class _BarcodeDemoPageState extends ConsumerState<BarcodeDemoPage> {
  String _barcodeToShow = '';

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
        _barcodeToShow = result == '-1' ? _barcodeToShow : result;
      });
      if (_barcodeToShow.isNotEmpty) {
        sendScanDataToOpenFood(barcode: _barcodeToShow).then((value) {
          showManualEntrySheet(readOnly: true);
        });
      } else {
        
        showFoodNotFoundSheet();
      }
    } catch (e) {
      setState(() {
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
        title: CommonText("Product Scan", size: 21, isBold: true),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          child: Column(
            spacing: 10,
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
                  : SizedBox(),

              CommonButton(
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
    final controller = ref.read(nutritionTrackerControllerProvider.notifier);
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

          controller.mealNameController.text = product['product_name'] ?? '';
          controller.caloriesController.text =
              product['nutriments'] != null
                  ? product['nutriments']['energy-kcal'].toString()
                  : "0";
          controller.proteinsController.text =
              product['nutriments'] != null
                  ? product['nutriments']['proteins'].toString()
                  : "0";
          controller.carbsController.text =
              product['nutriments'] != null
                  ? product['nutriments']['carbohydrates'].toString()
                  : "0";
          controller.fatController.text =
              product['nutriments'] != null
                  ? product['nutriments']['fat'].toString()
                  : "0";
        } else {}
      } else {}
    } catch (e) {
      return {"title": "Error", "message": e.toString()};
    }
  }

  //==========================================================show food not found sheet
  void showFoodNotFoundSheet() {
    
    final controller = ref.read(nutritionTrackerControllerProvider.notifier);
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
                children: [CommonCloseButton(context)],
              ),
              CommonText(
                "Food Data\nNot Found!",
                size: 32,
                isBold: true,
                textAlign: TextAlign.center,
              ),
              CommonSizedBox(height: 8),
              CommonText(
                "Add Manually",
                size: 16,
                isBold: true,
                color: AppColors.black,
                textAlign: TextAlign.center,
              ),
              CommonSizedBox(height: 20),
              CommonButton(
                "Add Manually",
                iconLeft: true,
                iconWidget: Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Icon(Icons.add_box_rounded, size: 32),
                ),
                onTap: () {
                  controller.mealNameController.clear();
                  controller.caloriesController.clear();
                  controller.proteinsController.clear();
                  controller.carbsController.clear();
                  controller.fatController.clear();
                  
                  Navigator.pop(context);
                  showManualEntrySheet(readOnly: false);
                },
              ),
              CommonSizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  //=====================================================================show manual entry sheet
  void showManualEntrySheet({bool readOnly = false}) {
    final controller = ref.read(nutritionTrackerControllerProvider.notifier);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final state = ref.watch(nutritionTrackerControllerProvider);

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
                      Center(child: CommonText("Manual Entry", size: 18)),
                      CommonSizedBox(height: 20),

                      // Meal Name
                      CommonTextField(
                        readOnly: readOnly,
                        controller: controller.mealNameController,
                        hintText: "Meal Name (e.g., Grilled Chicken)",
                      ),
                      CommonSizedBox(height: 16),

                      // Calories & Proteins
                      Row(
                        children: [
                          Expanded(
                            child: CommonTextField(
                              readOnly: readOnly,
                              controller: controller.caloriesController,
                              keyboardType: TextInputType.number,
                              hintText: "Calories",
                            ),
                          ),
                          CommonSizedBox(width: 12),
                          Expanded(
                            child: CommonTextField(
                              readOnly: readOnly,
                              controller: controller.proteinsController,
                              keyboardType: TextInputType.number,
                              hintText: "Proteins (g)",
                            ),
                          ),
                        ],
                      ),
                      CommonSizedBox(height: 16),

                      // Carbs & Fat
                      Row(
                        children: [
                          Expanded(
                            child: CommonTextField(
                              readOnly: readOnly,
                              controller: controller.carbsController,
                              keyboardType: TextInputType.number,
                              hintText: "Carbs (g)",
                            ),
                          ),
                          CommonSizedBox(width: 12),
                          Expanded(
                            child: CommonTextField(
                              readOnly: readOnly,
                              controller: controller.fatController,
                              keyboardType: TextInputType.number,
                              hintText: "Fat (g)",
                            ),
                          ),
                        ],
                      ),
                      CommonSizedBox(height: 20),

                      // Add Food Data Button
                      CommonButton(
                        "Add Food Data",
                        isLoading: state.isLoading,
                        onTap: () {
                          controller.sendScanDataToBackend(context: context);
                        },
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 16,
                  child: CommonCloseButton(context),
                ),
              ],
            );
          },
        );
      },
    );
  }
}
