import 'package:shared_preferences/shared_preferences.dart';
import 'i_local_storage_service.dart';
import 'storage_key.dart';

/// Implementation using SharedPreferences
class LocalStorageService implements ILocalStorageService {
  static SharedPreferences? _prefs;

  // Ensure instance is initialized only once
  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  @override
  Future<void> saveString(StorageKey key, String value) async {
    await _prefs?.setString(key.key, value);
  }

  @override
  Future<String?> getString(StorageKey key) async {
    return _prefs?.getString(key.key);
  }

  @override
  Future<void> saveBool(StorageKey key, bool value) async {
    await _prefs?.setBool(key.key, value);
  }

  @override
  Future<bool?> getBool(StorageKey key) async {
    return _prefs?.getBool(key.key);
  }

  @override
  Future<void> remove(StorageKey key) async {
    await _prefs?.remove(key.key);
  }

  @override
  Future<void> clearAll() async {
    await _prefs?.clear();
  }
}
