import 'dart:convert';

import 'package:backend/database/schema.dart';
import 'package:models/models.dart';

/// Extension methods to convert subscription database rows to domain models.
extension SubscriptionPlanRowExtension on SubscriptionPlanRow {
  /// Converts [SubscriptionPlanRow] to [SubscriptionPlan].
  SubscriptionPlan toSubscriptionPlan() {
    var parsedFeatures = <String>[];
    try {
      final decoded = jsonDecode(features);
      if (decoded is List) {
        parsedFeatures = decoded.map((e) => e.toString()).toList();
      }
    } catch (_) {}

    return SubscriptionPlan(
      code: SubscriptionPlanCode.tryParse(code) ?? SubscriptionPlanCode.trial,
      name: name,
      priceInPaise: priceInPaise,
      currency: currency,
      durationDays: durationDays,
      features: parsedFeatures,
    );
  }
}

/// Extension on [StoreSubscriptionRow] providing model conversions.
extension StoreSubscriptionRowExtension on StoreSubscriptionRow {
  /// Converts [StoreSubscriptionRow] to [StoreSubscription].
  StoreSubscription toStoreSubscription() {
    return StoreSubscription(
      id: id,
      storeId: storeId,
      planCode: SubscriptionPlanCode.tryParse(planCode) ?? SubscriptionPlanCode.trial,
      status: SubscriptionStatus.values.where(
        (s) => s.name == status || s.name == status.replaceAll('_', ''),
      ).firstOrNull ?? SubscriptionStatus.active,
      startsAt: startsAt,
      endsAt: endsAt,
      graceEndsAt: graceEndsAt,
      autoRenew: autoRenew,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

/// Extension on [SubscriptionTransactionRow] providing model conversions.
extension SubscriptionTransactionRowExtension on SubscriptionTransactionRow {
  /// Converts [SubscriptionTransactionRow] to [SubscriptionTransaction].
  SubscriptionTransaction toSubscriptionTransaction() {
    return SubscriptionTransaction(
      id: id,
      storeId: storeId,
      planCode: SubscriptionPlanCode.tryParse(planCode) ?? SubscriptionPlanCode.trial,
      amountInPaise: amountInPaise,
      currency: currency,
      paymentMethod: SubscriptionPaymentMethod.tryParse(paymentMethod) ?? SubscriptionPaymentMethod.simulated,
      status: PaymentStatus.values.asNameMap()[status.toLowerCase().trim()] ?? PaymentStatus.completed,
      reference: reference,
      createdAt: createdAt,
    );
  }
}
