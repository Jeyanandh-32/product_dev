import 'package:backend/database/schema.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Storage helper for low-level database operations on store subscriptions.
abstract final class SubscriptionStorageHelper {
  /// Inserts a new store subscription record.
  static Future<StoreSubscriptionRow> insert({
    required ts.Database<DatabaseSchema> db,
    required String storeId,
    required String planCode,
    required String status,
    required DateTime endsAt,
    required DateTime graceEndsAt,
  }) => db.storeSubscriptions
      .insertValue(
        storeId: storeId,
        planCode: planCode,
        status: status,
        startsAt: DateTime.now(),
        endsAt: endsAt,
        graceEndsAt: graceEndsAt,
        autoRenew: true,
      )
      .returnInserted()
      .executeAndFetch();

  /// Updates status timestamp for an existing store subscription.
  static Future<StoreSubscriptionRow?> updateStatus({
    required ts.Database<DatabaseSchema> db,
    required String id,
    required SubscriptionStatus status,
  }) => db.storeSubscriptions
      .byKey(id)
      .update(
        (s, set) => set(
          status: ts.toExpr(status.name),
          updatedAt: ts.Expr.currentTimestamp,
        ),
      )
      .returnUpdated()
      .executeAndFetch();

  /// Updates renewal details for an existing subscription.
  static Future<StoreSubscriptionRow?> updateRenewal({
    required ts.Database<DatabaseSchema> db,
    required String id,
    required String planCode,
    required DateTime endsAt,
    required DateTime graceEndsAt,
  }) => db.storeSubscriptions
      .byKey(id)
      .update(
        (s, set) => set(
          planCode: ts.toExpr(planCode),
          status: ts.toExpr(SubscriptionStatus.active.name),
          endsAt: ts.toExpr(endsAt),
          graceEndsAt: ts.toExpr(graceEndsAt),
          updatedAt: ts.Expr.currentTimestamp,
        ),
      )
      .returnUpdated()
      .executeAndFetch();
}
