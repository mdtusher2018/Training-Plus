// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';

// import 'package:training_plus/core/utils/colors.dart';
// import 'package:training_plus/view/training/training_provider.dart';
// import 'package:training_plus/widgets/common_widgets.dart';

// class ChooseYourSportChangeView extends ConsumerWidget {
//   const ChooseYourSportChangeView({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final state = ref.watch(trainingControllerProvider);
//     final controller = ref.read(trainingControllerProvider.notifier);

//     return Scaffold(
//       backgroundColor: AppColors.mainBG,

//       appBar: AppBar(
//         title: commonText(
//           "Choose your sports",
//           size: 22,
//           isBold: true,
//           textAlign: TextAlign.center,
//         ),
//         bottom: PreferredSize(
//           preferredSize: Size.fromHeight(16),
//           child: Center(
//             child: commonText(
//               "Select the sports you're\ninterested in.",
//               size: 14,
//               textAlign: TextAlign.center,
//               color: AppColors.textSecondary,
//             ),
//           ),
//         ),
//         centerTitle: true,
//         leading: GestureDetector(
//           onTap: () {
//             controller.changeCategory();
//             Navigator.pop(context);
//           },
//           child: Icon(Icons.arrow_back_ios_new),
//         ),
//       ),
//       body: SafeArea(
//         child: RefreshIndicator(
//           onRefresh: () async {
//             await controller.fetchCategories();
//           },
//           child:
//               state.isLoading && state.categories.isEmpty
//                   ? const Center(child: CircularProgressIndicator())
//                   : state.error != null
//                   ? commonErrorMassage(context: context, massage: state.error!)
//                   : state.categories.isEmpty
//                   ? const Center(child: Text("No categories found"))
//                   : GridView.count(
//                     padding: EdgeInsets.all(16),
//                     crossAxisCount: 2,
//                     mainAxisSpacing: 16,
//                     crossAxisSpacing: 16,
//                     children:
//                         state.categories.map((category) {
//                           // Only one sport can be selected
//                           final isSelected =
//                               state.sport != null &&
//                               state.sport == category.name;

//                           return GestureDetector(
//                             onTap: () {
//                               // Set the selected sport
//                               controller.updateSport(
//                                 sport: category.name,
//                                 sportId: category.id,
//                               );
//                             },
//                             child: Container(
//                               decoration: BoxDecoration(
//                                 color:
//                                     isSelected
//                                         ? const Color(0xFFFFFBEF)
//                                         : Colors.white,
//                                 borderRadius: BorderRadius.circular(12),
//                                 border: Border.all(
//                                   color:
//                                       isSelected
//                                           ? AppColors.primary
//                                           : Colors.grey.shade300,
//                                   width: 1.5,
//                                 ),
//                                 boxShadow: [
//                                   BoxShadow(
//                                     color: Colors.black.withOpacity(0.03),
//                                     blurRadius: 4,
//                                     offset: const Offset(0, 2),
//                                   ),
//                                 ],
//                               ),
//                               padding: const EdgeInsets.only(bottom: 14),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Expanded(
//                                     child: CommonImage(
//                                       imagePath: category.image,
//                                       isAsset: false,
//                                     ),
//                                   ),
//                                   commonSizedBox(height: 16),
//                                   commonText(
//                                     category.name,
//                                     size: 10,
//                                     isBold: true,
//                                     textAlign: TextAlign.center,
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           );
//                         }).toList(),
//                   ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/view/training/training_provider.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class ChooseYourSportChangeView extends ConsumerWidget {
  const ChooseYourSportChangeView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(trainingControllerProvider);
    final controller = ref.read(trainingControllerProvider.notifier);

    return WillPopScope(
      onWillPop: () async {
        final result = await controller.changeCategory();
        Navigator.pop(context, result);
        return false; 
      },
      child: Scaffold(
        backgroundColor: AppColors.mainBG,
        appBar: AppBar(
          title: commonText(
            "Choose your sports",
            size: 22,
            isBold: true,
            textAlign: TextAlign.center,
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(16),
            child: Center(
              child: commonText(
                "Select the sports you're\ninterested in.",
                size: 14,
                textAlign: TextAlign.center,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          centerTitle: true,
          leading: GestureDetector(
            onTap: () async {
              // 🔁 Same as pressing back
              final result = await controller.changeCategory();
              Navigator.pop(context, result);
            },
            child: const Icon(Icons.arrow_back_ios_new),
          ),
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              await controller.fetchCategories();
            },
            child: state.isLoading && state.categories.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : state.error != null
                    ? commonErrorMassage(
                        context: context, massage: state.error!)
                    : state.categories.isEmpty
                        ? const Center(child: Text("No categories found"))
                        : GridView.count(
                            padding: const EdgeInsets.all(16),
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 16,
                            children: state.categories.map((category) {
                              final isSelected = state.sport == category.name;

                              return GestureDetector(
                                onTap: () {
                                  controller.updateSport(
                                    sport: category.name,
                                    sportId: category.id,
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFFFFFBEF)
                                        : Colors.white,
                                    borderRadius: BorderRadius.circular(12),
                                    border: Border.all(
                                      color: isSelected
                                          ? AppColors.primary
                                          : Colors.grey.shade300,
                                      width: 1.5,
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.03),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  padding:
                                      const EdgeInsets.only(bottom: 14),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: CommonImage(
                                          imagePath: category.image,
                                          isAsset: false,
                                        ),
                                      ),
                                      commonSizedBox(height: 16),
                                      commonText(
                                        category.name,
                                        size: 10,
                                        isBold: true,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
          ),
        ),
      ),
    );
  }
}
