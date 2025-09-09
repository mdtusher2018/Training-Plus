import 'package:training_plus/core/services/api/i_api_service.dart';
import 'package:training_plus/core/services/localstorage/i_local_storage_service.dart';
import 'package:training_plus/core/services/localstorage/storage_key.dart';
import 'package:training_plus/core/utils/ApiEndpoints.dart';
import 'api_client.dart';

class ApiService implements IApiService {
  final ApiClient _client;
  final ILocalStorageService _localStorage;

  ApiService(this._client, this._localStorage);

  Future<Map<String, String>> _getHeaders({Map<String, String>? extra}) async {
    final token = await _localStorage.getString(StorageKey.token);
    final headers = {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
      if (extra != null) ...extra,
    };
    return headers;
  }

  @override
  Future<dynamic> get(String endpoint, {Map<String, String>? extraHeaders}) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}$endpoint');
    final headers = await _getHeaders(extra: extraHeaders);
    return _client.get(url, headers: headers);
  }

  @override
  Future<dynamic> post(String endpoint, Map<String, dynamic> body, {Map<String, String>? extraHeaders}) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}$endpoint');
    final headers = await _getHeaders(extra: extraHeaders);
    return _client.post(url, headers: headers, body: body);
  }

  @override
  Future<dynamic> put(String endpoint, Map<String, dynamic> body, {Map<String, String>? extraHeaders}) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}$endpoint');
    final headers = await _getHeaders(extra: extraHeaders);
    return _client.put(url, headers: headers, body: body);
  }

  @override
  Future<dynamic> patch(String endpoint, Map<String, dynamic> body, {Map<String, String>? extraHeaders}) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}$endpoint');
    final headers = await _getHeaders(extra: extraHeaders);
    return _client.patch(url, headers: headers, body: body);
  }

  @override
  Future<dynamic> delete(String endpoint, {Map<String, String>? extraHeaders}) async {
    final url = Uri.parse('${ApiEndpoints.baseUrl}$endpoint');
    final headers = await _getHeaders(extra: extraHeaders);
    return _client.delete(url, headers: headers);
  }
}
