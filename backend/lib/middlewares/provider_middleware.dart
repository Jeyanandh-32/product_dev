import 'package:backend/config/database.dart';
import 'package:backend/repositories/category_repository.dart';
import 'package:backend/repositories/counter_repository.dart';
import 'package:backend/repositories/merchant_repository.dart';
import 'package:backend/repositories/store_repository.dart'; // Import your new StoreRepository
import 'package:backend/repositories/terminal_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

Middleware providerMiddleware() {
  return (handler) {
    return handler
        .use(
          provider<CategoryRepository>(
            (context) => CategoryRepository(session: context.read<Session>()),
          ),
        )
        .use(
          provider<CounterRepository>(
            (context) => CounterRepository(session: context.read<Session>()),
          ),
        )
        .use(
          provider<TerminalRepository>(
            (context) => TerminalRepository(session: context.read<Session>()),
          ),
        )
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
