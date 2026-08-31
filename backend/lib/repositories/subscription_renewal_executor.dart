import 'package:backend/database/schema.dart';
import 'package:backend/exceptions/subscription_exceptions.dart';
import 'package:backend/repositories/subscription_lifecycle.dart';
import 'package:backend/repositories/subscription_storage_helper.dart';
import 'package:backend/repositories/subscription_transaction_repository.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Domain executor for extending, recording, and updating renewed store subscriptions.
class SubscriptionRenewalExecutor {
  const SubscriptionRenewalExecutor._();

  /// Executes plan renewal math, transaction logging, and database updates.
  static Future<StoreSubscriptionRow> execute({
    required ts.Database<DatabaseSchema> db,
    required SubscriptionTransactionRepository transactionRepo,
    required String storeId,
    required SubscriptionPlanRow? plan,
    required StoreSubscriptionRow? currentSub,
    required SubscriptionPlanCode planCode,
    SubscriptionPaymentMethod paymentMethod =
        SubscriptionPaymentMethod.simulated,
    String? reference,
  }) async {
    if (plan == null) throw SubscriptionPlanNotFoundException(planCode.name);

    final now = DateTime.now();
    final (endsAt, graceEndsAt) = SubscriptionLifecycle.computeRenewalDates(
      existingEndsAt: currentSub?.endsAt,
      planDurationDays: plan.durationDays,
      now: now,
    );

    if (reference != null) {
      await transactionRepo.recordCompleted(
        storeId: storeId,
        planCode: planCode,
        amountInPaise: plan.priceInPaise,
        currency: plan.currency,
        paymentMethod: paymentMethod,
        reference: reference,
      );
    }

    if (currentSub == null) {
      return SubscriptionStorageHelper.insert(
        db: db,
        storeId: storeId,
        planCode: planCode.name,
        status: SubscriptionStatus.active.name,
        endsAt: endsAt,
        graceEndsAt: graceEndsAt,
      );
    }

    final updated = await SubscriptionStorageHelper.updateRenewal(
      db: db,
      id: currentSub.id,
      planCode: planCode.name,
      endsAt: endsAt,
      graceEndsAt: graceEndsAt,
    );

    return updated ?? (throw SubscriptionNotFoundException(storeId));
  }
}
