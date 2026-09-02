import 'package:backend/database/schema.dart';
import 'package:backend/services/cache/in_memory_cache.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// High-performance in-memory cache for store bottle-return enablement.
class BottleReturnStoreCache {
  BottleReturnStoreCache._({Duration? ttl})
      : _cache = InMemoryCache<bool>(defaultTtl: ttl ?? const Duration(minutes: 5));

  /// Global shared singleton instance.
  static final BottleReturnStoreCache instance = BottleReturnStoreCache._();

  final InMemoryCache<bool> _cache;

  /// Checks if a store has bottle returns enabled, cached for 5 minutes.
  Future<bool> isBottleReturnEnabled(
    String storeId, {
    required ts.Database<DatabaseSchema> db,
  }) async {
    final cleanId = storeId.trim();
    if (cleanId.isEmpty) return false;

    return _cache.getOrFetch(cleanId, () async {
      final config = await db.bottleReturnConfigs
          .where(
            (c) =>
                c.storeId.equals(ts.toExpr(cleanId)) &
                c.isEnabled.equals(ts.toExpr(true)),
          )
          .first
          .fetch();
      return config != null;
    });
  }

  /// Manually invalidates cached capability for a store on config update.
  void invalidate(String storeId) {
    _cache.invalidate(storeId.trim());
  }

  /// Clears the entire store cache (primarily for tests).
  void clear() {
    _cache.clear();
  }
}
