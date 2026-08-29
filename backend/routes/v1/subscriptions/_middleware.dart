import 'package:backend/middlewares/auth_middleware.dart';
import 'package:dart_frog/dart_frog.dart';

/// Middleware for subscription endpoints allowing merchant and terminal authentication.
Handler middleware(Handler handler) {
  return handler.use(
    merchantTerminalAuthMiddleware(),
  );
}
