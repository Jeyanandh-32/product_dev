import 'package:backend/enums/user_role.dart';
import 'package:backend/middlewares/auth_middleware.dart';
import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) {
  return handler.use(
    merchantTerminalAuthMiddleware(
      roleRestrictedMethods: {
        UserRole.terminal: [.post],
      },
    ),
  );
}
