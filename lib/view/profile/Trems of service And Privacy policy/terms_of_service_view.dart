import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/view/profile/profile_providers.dart';

import 'package:training_plus/widgets/common_widgets.dart';

class TermsOfServiceView extends ConsumerStatefulWidget {
  const TermsOfServiceView({super.key});

  @override
  ConsumerState<TermsOfServiceView> createState() => _TermsOfServiceViewState();
}

class _TermsOfServiceViewState extends ConsumerState<TermsOfServiceView> {
  final String contentType = "privacy-policy";
  @override
  void initState() {
    super.initState();
    // ✅ fetch once after widget is mounted
    Future.microtask(() {
      ref
          .read(staticContentControllerProvider(contentType).notifier)
          .fetchStaticContent(contentType);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(staticContentControllerProvider(contentType));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: commonText('Terms of service', size: 21),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref
              .read(staticContentControllerProvider(contentType).notifier)
              .fetchStaticContent(contentType);
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Builder(
            builder: (context) {
              if ((state.content == null || state.content!.content.isEmpty) &&
                  state.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state.error != null &&
                  (state.content == null || state.content!.content.isEmpty)) {
                return commonErrorMassage(
                  context: context,
                  massage: state.error!,
                );
              }
              if (state.content != null) {
                return Html(
                  data: state.content!.content,
                  style: {"body": Style(fontSize: FontSize.medium)},
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
