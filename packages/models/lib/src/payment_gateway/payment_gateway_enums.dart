import 'package:freezed_annotation/freezed_annotation.dart';

/// Execution environment for payment gateway integration (sandbox vs live).
@JsonEnum()
enum PaymentGatewayEnv {
  /// User Acceptance Testing / Sandbox environment.
  @JsonValue('UAT')
  uat,

  /// Production / live transaction environment.
  @JsonValue('PROD')
  prod;
}

/// Third-party payment gateway provider supported by the platform.
@JsonEnum()
enum PaymentProvider {
  /// PhonePe PG integration.
  @JsonValue('phonepe')
  phonepe,

  /// Cashfree PG integration.
  @JsonValue('cashfree')
  cashfree,

  /// Razorpay PG integration.
  @JsonValue('razorpay')
  razorpay;
}

/// Authentication scheme used to verify incoming payment gateway webhooks.
@JsonEnum()
enum WebhookAuthType {
  /// HMAC signature verification using a shared secret.
  @JsonValue('HMAC')
  hmac,

  /// Bearer token header verification.
  @JsonValue('BEARER')
  bearer,

  /// HTTP Basic auth credentials.
  @JsonValue('BASIC')
  basic;
}

