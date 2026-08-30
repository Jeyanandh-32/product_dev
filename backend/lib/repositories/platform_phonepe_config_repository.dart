import 'dart:io';

import 'package:backend/config/env.dart';
import 'package:models/models.dart';

/// Provider for accessing developer/platform PhonePe configuration directly from environment.
class PlatformPhonePeConfigRepository {
  const PlatformPhonePeConfigRepository();

  /// Retrieves the active platform PhonePe config from environment variables.
  PlatformPhonePeConfig? getConfig() {
    Env.reload();
    final envClientId =
        Env.phonepePlatformClientId ??
        Platform.environment['PHONEPE_PLATFORM_CLIENT_ID'] ??
        Env.phonepePlatformMerchantId ??
        Platform.environment['PHONEPE_PLATFORM_MERCHANT_ID'];
    final envClientSecret =
        Env.phonepePlatformClientSecret ??
        Platform.environment['PHONEPE_PLATFORM_CLIENT_SECRET'];
    final envClientVersion =
        Env.phonepePlatformClientVersion ??
        Platform.environment['PHONEPE_PLATFORM_CLIENT_VERSION'] ??
        '1';
    final envSaltKey =
        Env.phonepePlatformSaltKey ??
        Platform.environment['PHONEPE_PLATFORM_SALT_KEY'];
    final envSaltIndex = Env.phonepePlatformSaltIndex;
    final envEnv = Env.phonepePlatformEnv;

    if (envClientId == null && envSaltKey == null) {
      return null;
    }

    return PlatformPhonePeConfig(
      id: 'env-platform-phonepe',
      env: envEnv.toUpperCase() == 'PROD'
          ? PaymentGatewayEnv.prod
          : PaymentGatewayEnv.uat,
      clientId: envClientId,
      clientSecret: envClientSecret,
      clientVersion: envClientVersion,
      saltKey: envSaltKey,
      saltIndex: envSaltIndex,
      enableCards: false,
      enableNetBanking: false,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
