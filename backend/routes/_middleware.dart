import 'package:backend/config/database.dart';
import 'package:backend/config/env.dart';
import 'package:backend/repositories/merchant_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:dart_frog_cors/dart_frog_cors.dart';
import 'package:postgres/postgres.dart';

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(
        cors(
          allowOrigin: Env.allowedOrigin,
          additional: {
            'Access-Control-Allow-Credentials': 'true',
          },
        ),
      )
      .use(
        provider<MerchantRepository>(
          (context) => MerchantRepository(session: context.read<Session>()),
        ),
      )
      .use(
        provider<Session>(
          (context) => Database.pool,
        ),
      );
}
