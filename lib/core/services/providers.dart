import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/link_sharing/universal_link_service.dart';
import 'package:training_plus/core/services/localstorage/i_local_storage_service.dart';
import 'api/api_client.dart';
import 'api/api_service.dart';
import 'localstorage/local_storage_service.dart';
import 'api/i_api_service.dart';

final appStartupProvider = FutureProvider<void>((ref) async {
  await LocalStorageService.init();
  final deepLinkService = DeepLinkService();
  ref.onDispose(() => deepLinkService.dispose());
});

final Provider<ILocalStorageService> localStorageProvider =
    Provider<ILocalStorageService>((ref) {
      return LocalStorageService();
    });

final Provider<ApiClient> apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

final Provider<IApiService> apiServiceProvider = Provider<IApiService>((ref) {
  final client = ref.read(apiClientProvider);
  final storage = ref.read(localStorageProvider);
  return ApiService(client, storage);
});
