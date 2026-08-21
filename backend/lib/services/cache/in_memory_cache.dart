/// In-memory cache entry with expiration timestamp.
class CacheEntry<T> {
  const CacheEntry({
    required this.value,
    required this.expiresAt,
  });

  final T value;
  final DateTime expiresAt;

  /// Whether this entry has exceeded its time-to-live.
  bool get isExpired => DateTime.now().isAfter(expiresAt);
}

/// Generic, high-performance in-memory TTL cache with request deduplication.
class InMemoryCache<T> {
  InMemoryCache({this.defaultTtl = const Duration(minutes: 5)});

  final Duration defaultTtl;
  final Map<String, CacheEntry<T>> _store = {};
  final Map<String, Future<T>> _inFlight = {};

  /// Retrieves a value by [key] if present and unexpired.
  T? get(String key) {
    final entry = _store[key];
    if (entry == null) return null;
    if (entry.isExpired) {
      _store.remove(key);
      return null;
    }
    return entry.value;
  }

  /// Retrieves cached value, joins in-flight request, or invokes [fetcher].
  Future<T> getOrFetch(String key, Future<T> Function() fetcher, {Duration? ttl}) async {
    final cached = get(key);
    if (cached != null) return cached;

    final inFlightFuture = _inFlight[key];
    if (inFlightFuture != null) return inFlightFuture;

    final future = fetcher();
    _inFlight[key] = future;

    try {
      final result = await future;
      set(key, result, ttl: ttl);
      return result;
    } finally {
      final _ = _inFlight.remove(key);
    }
  }

  /// Stores a [value] under [key] with optional custom [ttl].
  void set(String key, T value, {Duration? ttl}) {
    final effectiveTtl = ttl ?? defaultTtl;
    _store[key] = CacheEntry(
      value: value,
      expiresAt: DateTime.now().add(effectiveTtl),
    );
  }

  /// Invalidates a specific [key].
  void invalidate(String key) {
    _store.remove(key);
    final _ = _inFlight.remove(key);
  }

  /// Invalidates all entries whose keys start with [prefix].
  void invalidatePrefix(String prefix) {
    _store.removeWhere((k, _) => k.startsWith(prefix));
    _inFlight.removeWhere((k, _) => k.startsWith(prefix));
  }

  /// Clears all entries from the cache.
  void clear() {
    _store.clear();
    _inFlight.clear();
  }
}
