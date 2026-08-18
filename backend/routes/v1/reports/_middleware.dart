import 'package:backend/enums/user_role.dart';
import 'package:backend/middlewares/auth_middleware.dart';
import 'package:dart_frog/dart_frog.dart';

/// Middleware for reports and orders query endpoints allowing merchant and terminal access.
Handler middleware(Handler handler) {
  return handler.use(
    authMiddleware(
      allowedRoles: [
        UserRole.merchant,
        UserRole.terminal,
      ],
    ),
  );
}
