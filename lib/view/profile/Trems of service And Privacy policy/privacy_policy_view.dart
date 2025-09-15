import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/utils/colors.dart';
import 'package:training_plus/view/profile/profile_providers.dart';
import 'package:training_plus/widgets/common_widgets.dart';
import 'package:flutter_html/flutter_html.dart';


class PrivacyPolicyView extends ConsumerStatefulWidget {
  const PrivacyPolicyView({super.key});

  @override
  ConsumerState<PrivacyPolicyView> createState() => _PrivacyPolicyViewState();
}

class _PrivacyPolicyViewState extends ConsumerState<PrivacyPolicyView> {
  final String contentType="terms-of-condition";
  @override
  void initState() {
    super.initState();
    // ✅ fetch once after widget is mounted
    Future.microtask(() {
      ref.read(staticContentControllerProvider(contentType).notifier).fetchStaticContent(contentType);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(staticContentControllerProvider(contentType));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: commonText(
          'Privacy Policy',
          size: 21,
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(staticContentControllerProvider(contentType).notifier).fetchStaticContent("terms-of-condition");
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Builder(
            builder: (context) {
               if (state.isLoading && (state.content == null || state.content!.content.isEmpty)) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.error != null && (state.content == null || state.content!.content.isEmpty)) {
                return ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.8,
                  child: Center(
                    child: commonText(
                      state.error!,
                      size: 16,
                      color:  AppColors.error,
                    ),
                  ),
                ),
              ],
            );
              }
              if (state.content != null) {
                return  Html(
              data: state.content!.content,
              style: {
                "body": Style(fontSize: FontSize.medium),
              },
            );
              }
              return const Center(child: Text("No content available"));
            },
          ),
        ),
      ),
    );
  }
}
