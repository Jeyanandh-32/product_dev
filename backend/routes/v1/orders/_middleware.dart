import 'package:backend/middlewares/auth_middleware.dart';
import 'package:dart_frog/dart_frog.dart';

/// Middleware for orders endpoints allowing public payment status check via `/v1/orders/verify-status`.
Handler middleware(Handler handler) {
  return handler.use(
    authMiddleware(
      publicPaths: ['/v1/orders/verify-status'],
      roleRestrictedMethods: {
        .merchant: [.post],
      },
    ),
  );
}
