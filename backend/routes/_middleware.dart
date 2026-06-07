import 'package:backend/config/database.dart';
import 'package:backend/repositories/merchant_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

Handler middleware(Handler handler) {
  return handler
      .use(requestLogger())
      .use(
        (handler) {
          return (context) async {
            final request = context.request;
            final origin = request.headers['origin'] ?? '*';

            if (request.method == HttpMethod.options) {
              return Response(
                statusCode: 204,
                headers: {
                  'Access-Control-Allow-Origin': origin,
                  'Access-Control-Allow-Credentials': 'true',
                  'Access-Control-Allow-Headers':
                      'Origin, X-Requested-With, Content-Type, Accept, Authorization',
                  'Access-Control-Allow-Methods':
                      'GET, POST, PUT, DELETE, OPTIONS, PATCH',
                },
              );
            }

            final response = await handler(context);

            return response.copyWith(
              headers: {
                ...response.headers,
                'Access-Control-Allow-Origin': origin,
                'Access-Control-Allow-Credentials': 'true',
              },
            );
          };
        },
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
