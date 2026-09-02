import 'package:backend/config/database.dart';
import 'package:backend/database/schema.dart';
import 'package:backend/middlewares/cors_middleware.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

Handler middleware(Handler handler) {
  return ((RequestContext context) async {
    await Database.ensureWarm();
    return handler(context);
  })
      .use(requestLogger())
      .use(corsMiddleware())
      .use(provider<ts.Database<DatabaseSchema>>((_) => Database.db));
}
