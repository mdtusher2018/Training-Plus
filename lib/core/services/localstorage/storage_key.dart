/// Enum to define all keys in a type-safe way
enum StorageKey {
  token,
  rememberMe,
}

extension StorageKeyExtension on StorageKey {
  String get key {
    switch (this) {
      case StorageKey.token:
        return 'token';
      case StorageKey.rememberMe:
        return 'rememberMe';
    }
  }
}
