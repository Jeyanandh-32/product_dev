import 'package:backend/enums/user_role.dart';
import 'package:backend/middlewares/auth_middleware.dart';
import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) {
  return handler.use(
    authMiddleware(
      allowedRoles: [UserRole.merchant, UserRole.customer],
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
