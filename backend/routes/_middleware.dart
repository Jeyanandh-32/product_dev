import 'package:backend/config/database.dart';
import 'package:backend/middlewares/cors_middleware.dart';
import 'package:backend/middlewares/provider_middleware.dart';
import 'package:dart_frog/dart_frog.dart';

Handler middleware(Handler handler) {
  return ((RequestContext context) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    await Database.ensureWarm();
    return handler(context);
  }).use(requestLogger()).use(corsMiddleware()).use(providerMiddleware());
}
