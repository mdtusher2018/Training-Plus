
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/view/profile/profile_providers.dart';
import 'package:training_plus/widgets/common_widgets.dart';

class FaqView extends ConsumerWidget {
  const FaqView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final faqState = ref.watch(faqControllerProvider);
    final controller = ref.watch(faqControllerProvider.notifier);
    

    return Scaffold(
      backgroundColor: AppColors.boxBG,
      appBar: AppBar(
        backgroundColor: AppColors.boxBG,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => Navigator.pop(context),
        ),
        centerTitle: true,
        title: commonText("FAQ", size: 21, isBold: true),
      ),
      body: RefreshIndicator(
        onRefresh: () async{
          await controller.fetchFaqs();
        },
        child: faqState.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, stack) => Center(child: Text('Error: $error')),
          data: (faqList) {
            final Set<int> expandedIndexes = {};
        
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: faqList.length,
              itemBuilder: (context, index) {
                final faq = faqList[index];
        
                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      width: 2,
                      color: expandedIndexes.contains(index)
                          ? AppColors.primary
                          : Colors.grey.withOpacity(0.5),
                    ),
                    color: AppColors.white,
                  ),
                  child: Theme(
                    data: Theme.of(context)
                        .copyWith(dividerColor: Colors.transparent),
                    child: ExpansionTile(
                      onExpansionChanged: (expanded) {
                        if (expanded) {
                          expandedIndexes.add(index);
                        } else {
                          expandedIndexes.remove(index);
                        }
                        // Force rebuild
                        (context as Element).markNeedsBuild();
                      },
                      title: commonText(
                        faq.question,
                        size: 16,
                        isBold: true,
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          child: commonText(
                            faq.answer,
                            size: 14,
                            color: Colors.grey.shade700,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
