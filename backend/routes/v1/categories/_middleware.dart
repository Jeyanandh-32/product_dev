import 'package:backend/enums/user_role.dart';
import 'package:backend/middlewares/auth_middleware.dart';
import 'package:dart_frog/dart_frog.dart';

/// Middleware for categories endpoints allowing public category browsing for guest customers.
Handler middleware(Handler handler) {
  return handler.use(
    authMiddleware(
      allowedRoles: [
        .merchant,
        .terminal,
        .customer,
      ],
      publicPaths: ['/v1/categories'],
      roleRestrictedMethods: {
        UserRole.customer: [
          .post,
          .patch,
          .delete,
          .put,
        ],
      },
    ),
  );
}
