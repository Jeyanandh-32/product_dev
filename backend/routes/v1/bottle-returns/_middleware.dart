import 'package:backend/database/schema.dart';
import 'package:backend/middlewares/auth_middleware.dart';
import 'package:backend/repositories/bottle_return_dispenser_handler.dart';
import 'package:backend/repositories/bottle_return_product_handler.dart';
import 'package:backend/repositories/bottle_return_repository.dart';
import 'package:backend/repositories/bottle_return_session_handler.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Middleware securing bottle return endpoints and injecting repositories.
Handler middleware(Handler handler) {
  return handler
      .use(
        authMiddleware(
          allowedRoles: [.merchant, .terminal, .customer],
          publicPaths: [
            '/v1/bottle-returns/config',
            '/v1/bottle-returns/iot',
          ],
        ),
      )
      .use(
        provider<BottleReturnProductHandler>(
          (context) => BottleReturnProductHandler(
            db: context.read<ts.Database<DatabaseSchema>>(),
          ),
        ),
      )
      .use(
        provider<BottleReturnDispenserHandler>(
          (context) => BottleReturnDispenserHandler(
            db: context.read<ts.Database<DatabaseSchema>>(),
          ),
        ),
      )
      .use(
        provider<BottleReturnSessionHandler>(
          (context) => BottleReturnSessionHandler(
            db: context.read<ts.Database<DatabaseSchema>>(),
          ),
        ),
      )
      .use(
        provider<BottleReturnRepository>(
          (context) => BottleReturnRepository(
            db: context.read<ts.Database<DatabaseSchema>>(),
          ),
        ),
      );
}
