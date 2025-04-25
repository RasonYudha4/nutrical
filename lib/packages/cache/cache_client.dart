class CacheClient {
  CacheClient({this.maxSize = 100}) : _cache = <String, _CacheEntry>{};

  final Map<String, _CacheEntry> _cache;
  final int maxSize;

  void write<T extends Object>({
    required String key,
    required T value,
    Duration? ttl,
  }) {
    if (_cache.length >= maxSize && !_cache.containsKey(key)) {
      _evictOldest();
    }

    final expiryTime = ttl != null ? DateTime.now().add(ttl) : null;
    _cache[key] = _CacheEntry(value, DateTime.now(), expiryTime);
  }

  T? read<T extends Object>({required String key}) {
    final entry = _cache[key];

    if (entry == null) return null;

    if (entry.expiryTime != null && DateTime.now().isAfter(entry.expiryTime!)) {
      _cache.remove(key);
      return null;
    }

    _cache[key] = entry.withUpdatedAccessTime();

    if (entry.value is T) return entry.value as T;
    return null;
  }

  void invalidate(String key) {
    _cache.remove(key);
  }

  void clear() {
    _cache.clear();
  }

  void _evictOldest() {
    if (_cache.isEmpty) return;

    String? oldestKey;
    DateTime? oldestAccess;

    for (final entry in _cache.entries) {
      if (oldestAccess == null ||
          entry.value.lastAccessTime.isBefore(oldestAccess)) {
        oldestAccess = entry.value.lastAccessTime;
        oldestKey = entry.key;
      }
    }

    if (oldestKey != null) {
      _cache.remove(oldestKey);
    }
  }
}

class _CacheEntry {
  final Object value;
  final DateTime lastAccessTime;
  final DateTime? expiryTime;

  _CacheEntry(this.value, this.lastAccessTime, this.expiryTime);

  _CacheEntry withUpdatedAccessTime() {
    return _CacheEntry(value, DateTime.now(), expiryTime);
  }
}
