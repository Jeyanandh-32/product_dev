/// Dedicated fee strategy calculator for payment gateway processing charges.
class PaymentGatewayFeeCalculator {
  const PaymentGatewayFeeCalculator._();

  /// Computes gateway charge in paise and percentage for a given provider.
  ///
  /// For PhonePe: 0.0% (Free).
  static ({int gatewayChargesPaise, double percentage}) calculate({
    required int amountInPaisa,
    String? provider,
  }) {
    final cleanProvider = (provider ?? 'phonepe').toLowerCase().trim();

    return switch (cleanProvider) {
      'phonepe' => (gatewayChargesPaise: 0, percentage: 0.0),
      _ => (gatewayChargesPaise: 0, percentage: 0.0),
    };
  }
}
