import 'package:freezed_annotation/freezed_annotation.dart';

@JsonEnum()
enum PaymentGatewayEnv {
  @JsonValue('UAT')
  uat,
  @JsonValue('PROD')
  prod;
}

@JsonEnum()
enum PaymentProvider {
  @JsonValue('phonepe')
  phonepe,
  @JsonValue('cashfree')
  cashfree,
  @JsonValue('razorpay')
  razorpay;
}

@JsonEnum()
enum WebhookAuthType {
  @JsonValue('HMAC')
  hmac,
  @JsonValue('BEARER')
  bearer,
  @JsonValue('BASIC')
  basic;
}
