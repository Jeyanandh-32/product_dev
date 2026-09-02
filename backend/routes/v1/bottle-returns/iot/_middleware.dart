import 'package:backend/database/schema.dart';
import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/models/token_payload/token_payload.dart';
import 'package:backend/services/auth_service.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Middleware for machine return endpoints validating API Key or Terminal/Merchant Bearer JWT.
Handler middleware(Handler handler) {
  return (context) async {
    final apiKey =
        context.request.headers['x-api-key'] ??
        context.request.headers['x-iot-api-key'];
    final authorization = context.request.headers['authorization'];
    final bearerToken = CookieService.extractBearerToken(authorization);

    if (apiKey != null && apiKey.isNotEmpty) {
      final db = context.db;
      final configs = await db.bottleReturnConfigs
          .where(
            (c) =>
                c.iotApiKey.equals(ts.toExpr(apiKey)) &
                c.isEnabled.equals(ts.toExpr(true)),
          )
          .fetch();
      if (configs.isNotEmpty) {
        return handler(context);
      }
    }

    if (bearerToken != null) {
      try {
        final jwt = JwtService.verifyAccessToken(bearerToken);
        final tokenPayload = TokenPayload.fromJson(
          jwt.payload as Map<String, Object?>,
        );
        return await handler(
          context.provide<TokenPayload>(() => tokenPayload),
        );
      } catch (_) {
        return forbidden(message: 'Invalid Token');
      }
    }

    return unauthorized(
      message: 'Unauthorized. Provide a valid API Key or Bearer token.',
    );
  };
}
