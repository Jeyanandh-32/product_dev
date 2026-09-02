import 'package:backend/middlewares/auth_middleware.dart';
import 'package:dart_frog/dart_frog.dart';

/// Middleware securing bottle return endpoints.
Handler middleware(Handler handler) {
  return handler.use(
    authMiddleware(
      allowedRoles: [.merchant, .terminal, .customer],
      publicPaths: [
        '/v1/bottle-returns/config',
        '/v1/bottle-returns/iot',
      ],
    ),
  );
}
