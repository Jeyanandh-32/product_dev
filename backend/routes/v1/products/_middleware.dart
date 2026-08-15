import 'package:backend/enums/user_role.dart';
import 'package:backend/middlewares/auth_middleware.dart';
import 'package:dart_frog/dart_frog.dart';

/// Middleware for products endpoints allowing public catalog browsing for guest customers.
Handler middleware(Handler handler) {
  return handler.use(
    authMiddleware(
      allowedRoles: [
        UserRole.merchant,
        UserRole.terminal,
        UserRole.customer,
      ],
      publicPaths: ['/v1/products'],
      roleRestrictedMethods: {
        UserRole.customer: [
          HttpMethod.post,
          HttpMethod.patch,
          HttpMethod.delete,
          HttpMethod.put,
        ],
      },
    ),
  );
}
