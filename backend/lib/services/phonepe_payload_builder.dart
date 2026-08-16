import 'package:backend/services/phonepe_payment_mode_builder.dart';
import 'package:models/models.dart';

/// Builder for constructing PhonePe checkout request payloads and meta info.
class PhonePePayloadBuilder {
  const PhonePePayloadBuilder._();

  static Map<String, dynamic> buildCheckoutPayload({
    required StorePhonePeConfig config,
    required String merchantOrderId,
    required int amountInPaisa,
    required String redirectUrl,
    String? customerName,
    String? customerEmail,
    String? customerPhone,
    String? storeId,
    String? customerId,
  }) {
    final paymentModeConfig = PhonePePaymentModeBuilder.build(config);

    return <String, dynamic>{
      'merchantOrderId': merchantOrderId,
      'amount': amountInPaisa,
      'expireAfter': 1200,
      'paymentFlow': {
        'type': 'PG_CHECKOUT',
        'merchantUrls': {'redirectUrl': redirectUrl},
        if (paymentModeConfig != null) 'paymentModeConfig': paymentModeConfig,
      },
      if (customerPhone != null && customerPhone.isNotEmpty)
        'prefillUserLoginDetails': {'phoneNumber': customerPhone},
      if (customerName != null || customerEmail != null || customerPhone != null)
        'customerDetails': {
          if (customerName != null) 'name': customerName,
          if (customerEmail != null) 'email': customerEmail,
          if (customerPhone != null) 'phoneNumber': customerPhone,
        },
      'metaInfo': {
        if (storeId != null) 'udf1': storeId,
        if (customerId != null) 'udf2': customerId,
      },
    };
  }
}
