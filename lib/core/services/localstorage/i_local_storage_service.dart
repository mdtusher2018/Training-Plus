import 'storage_key.dart';

/// Abstract interface (for testability)
abstract class ILocalStorageService {
  Future<void> saveString(StorageKey key, String value);
  Future<String?> getString(StorageKey key);
  Future<void> saveBool(StorageKey key, bool value);
  Future<bool?> getBool(StorageKey key);
  Future<void> remove(StorageKey key);
  Future<void> clearAll();
}
