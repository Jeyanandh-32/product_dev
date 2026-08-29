/// Typed exception thrown when a subscription plan cannot be found.
final class SubscriptionPlanNotFoundException implements Exception {
  /// Creates a [SubscriptionPlanNotFoundException] for the given [planCode].
  const SubscriptionPlanNotFoundException(this.planCode);

  /// The invalid or missing plan code.
  final String planCode;

  @override
  String toString() => 'SubscriptionPlanNotFoundException: Plan "$planCode" not found.';
}

/// Typed exception thrown when a store subscription cannot be found or retrieved.
final class SubscriptionNotFoundException implements Exception {
  /// Creates a [SubscriptionNotFoundException] for the given [storeId].
  const SubscriptionNotFoundException(this.storeId);

  /// The store identifier whose subscription could not be found.
  final String storeId;

  @override
  String toString() => 'SubscriptionNotFoundException: Store "$storeId" subscription not found.';
}
