import 'package:backend/enums/user_role.dart';
import 'package:backend/middlewares/auth_middleware.dart';
import 'package:dart_frog/dart_frog.dart';

/// Middleware for stores endpoints allowing public access to `/v1/stores/online` for guest users.
Handler middleware(Handler handler) {
  return handler.use(
    authMiddleware(
      allowedRoles: [UserRole.merchant, UserRole.customer],
      publicPaths: ['/v1/stores/online'],
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
