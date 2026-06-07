import 'package:backend/config/database.dart';
import 'package:backend/repositories/merchant_repository.dart';
import 'package:backend/repositories/store_repository.dart'; // Import your new StoreRepository
import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

Middleware providerMiddleware() {
  return (handler) {
    return handler
        .use(
          provider<StoreRepository>(
            (context) => StoreRepository(session: context.read<Session>()),
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
  };
}
