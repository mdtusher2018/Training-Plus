import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:training_plus/core/services/link_sharing/universal_link_service.dart';
import 'package:training_plus/core/services/providers.dart';
import 'package:training_plus/core/utils/global_keys.dart';
import 'package:training_plus/core/utils/theme.dart';
import 'package:training_plus/view/intro_and_onBoarging/splash_view.dart';
import 'package:training_plus/widgets/common_text.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      child: ScreenUtilInit(
        designSize: Size(360, 640),
        child: AppStartupWidget(),
      ),
    ),
  );
}

class AppStartupWidget extends ConsumerStatefulWidget {
  const AppStartupWidget({super.key});

  @override
  ConsumerState<AppStartupWidget> createState() => _AppStartupWidgetState();
}

class _AppStartupWidgetState extends ConsumerState<AppStartupWidget> {
  @override
  Widget build(BuildContext context) {
    final appStartup = ref.watch(appStartupProvider);

    return ScreenUtilInit(
      designSize: const Size(360, 640),
      builder: (context, _) {
        return MaterialApp(
          title: 'Training Plus',
          debugShowCheckedModeBanner: false,
          navigatorKey: navigatorKey,
          theme: AppTheme.lightTheme(),
          home: appStartup.when(
            loading: () => const AppStartupLoadingWidget(),
            error:
                (error, _) => AppStartupErrorWidget(
                  error: error,
                  onRetry: () {
                    debugPrint('Retrying app initialization...');
                    ref.invalidate(appStartupProvider);
                  },
                ),
            data: (_) => const MyApp(),
          ),
        );
      },
    );
  }
}

/// --- LOADING WIDGET ---
class AppStartupLoadingWidget extends StatelessWidget {
  const AppStartupLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}

/// --- ERROR WIDGET ---
class AppStartupErrorWidget extends StatelessWidget {
  final Object error;
  final VoidCallback onRetry;

  const AppStartupErrorWidget({
    super.key,
    required this.error,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 16),
              CommonText(
                'Something went wrong during startup.\n${error.toString()}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// --- Main WIDGET ---
class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  final DeepLinkService _deepLinkService = DeepLinkService();

  @override
  void initState() {
    super.initState();
    // Initialize after build to ensure context is ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _deepLinkService.initDeepLinks(context, ref);
    });
  }

  @override
  void dispose() {
    _deepLinkService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SplashView();
  }
}
