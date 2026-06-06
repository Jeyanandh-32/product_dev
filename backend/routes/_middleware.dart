import 'package:backend/config/database.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_cors/dart_frog_cors.dart';
import 'package:postgres/postgres.dart';

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(
        cors(
          allowOrigin: 'http://localhost:3000',
          additional: {
            'Access-Control-Allow-Credentials': 'true',
          },
        ),
      )
      .use(
        provider<Connection>(
          (context) => Database.connection,
        ),
      );
}
