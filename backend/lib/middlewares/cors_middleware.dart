import 'package:dart_frog/dart_frog.dart';

Middleware corsMiddleware() {
  return (handler) => (context) async {
    final request = context.request;
    final origin = request.headers['origin'] ?? '*';

    if (request.method == .options) {
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
}
