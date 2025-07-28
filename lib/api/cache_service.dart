import 'dart:collection';

class CacheEntry {
  final dynamic data;
  final DateTime timestamp;

  CacheEntry(this.data, this.timestamp);

  bool isValid(Duration cacheDuration) {
    return DateTime.now().difference(timestamp) < cacheDuration;
  }
}

class CacheService {
  final Map<String, CacheEntry> _cache = HashMap();

  dynamic get(String key, Duration cacheDuration) {
    final entry = _cache[key];
    if (entry != null && entry.isValid(cacheDuration)) {
      return entry.data;
    }
    return null;
  }

  void put(String key, dynamic data) {
    _cache[key] = CacheEntry(data, DateTime.now());
  }

  void clear() {
    _cache.clear();
  }
}