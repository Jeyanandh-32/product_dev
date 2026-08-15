import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Helper utility for PhonePe HMAC webhook signature verification and URL endpoints.
class PhonePeSecurityHelper {
  const PhonePeSecurityHelper._();

  /// Verifies PhonePe HMAC-SHA256 signature against the raw webhook body payload.
  static bool verifyWebhookHmac({
    required String rawRequestBody,
    required String signatureHeader,
    required String secretKey,
  }) {
    if (signatureHeader.isEmpty || secretKey.isEmpty) return false;
    final hmac = Hmac(sha256, utf8.encode(secretKey));
    final digest = hmac.convert(utf8.encode(rawRequestBody));
    final computedSignature = digest.toString();
    return computedSignature == signatureHeader;
  }
}
