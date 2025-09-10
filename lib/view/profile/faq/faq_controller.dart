import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'faq_model.dart'; // the model we created

// StateNotifier to manage FAQ state
class FaqController extends StateNotifier<AsyncValue<List<FaqAttribute>>> {
  final IApiService _apiService;

  FaqController(this._apiService) : super(const AsyncValue.loading());

  // Fetch FAQs
  Future<void> fetchFaqs() async {
    try {
      state = const AsyncValue.loading();
      

      final response = await _apiService.get(ApiEndpoints.faq); // replace with your endpoint
      // Parse JSON into model
      final faqResponse = FaqResponse.fromJson(response);

      state = AsyncValue.data(faqResponse.data);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

