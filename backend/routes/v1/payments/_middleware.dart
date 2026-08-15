import 'package:backend/middlewares/auth_middleware.dart';
import 'package:dart_frog/dart_frog.dart';

/// Middleware for payments endpoints allowing public PhonePe webhook callbacks.
Handler middleware(Handler handler) {
  return handler.use(
    merchantTerminalAuthMiddleware(
      publicPaths: ['/v1/payments/phonepe-webhook'],
    ),
  );
}
