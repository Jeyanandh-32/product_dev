import 'package:backend/config/database.dart';
import 'package:backend/database/schema.dart';
import 'package:backend/repositories/category_repository.dart';
import 'package:backend/repositories/counter_repository.dart';
import 'package:backend/repositories/merchant_repository.dart';
import 'package:backend/repositories/order_item_repository.dart';
import 'package:backend/repositories/order_repository.dart';
import 'package:backend/repositories/product_repository.dart';
import 'package:backend/repositories/stock_repository.dart';
import 'package:backend/repositories/store_repository.dart';
import 'package:backend/repositories/terminal_repository.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

Middleware providerMiddleware() {
  return (handler) {
    return handler
        .use(
          provider<OrderRepository>(
            (context) => OrderRepository(
              db: context.read<ts.Database<DatabaseSchema>>(),
            ),
          ),
        )
        .use(
          provider<OrderItemRepository>(
            (context) => OrderItemRepository(
              db: context.read<ts.Database<DatabaseSchema>>(),
            ),
          ),
        )
        .use(
          provider<ProductRepository>(
            (context) => ProductRepository(
              db: context.read<ts.Database<DatabaseSchema>>(),
            ),
          ),
        )
        .use(
          provider<StockRepository>(
            (context) => StockRepository(
              db: context.read<ts.Database<DatabaseSchema>>(),
            ),
          ),
        )
        .use(
          provider<CategoryRepository>(
            (context) => CategoryRepository(
              db: context.read<ts.Database<DatabaseSchema>>(),
            ),
          ),
        )
        .use(
          provider<CounterRepository>(
            (context) => CounterRepository(
              db: context.read<ts.Database<DatabaseSchema>>(),
            ),
          ),
        )
        .use(
          provider<TerminalRepository>(
            (context) => TerminalRepository(
              db: context.read<ts.Database<DatabaseSchema>>(),
            ),
          ),
        )
        .use(
          provider<StoreRepository>(
            (context) => StoreRepository(
              db: context.read<ts.Database<DatabaseSchema>>(),
            ),
          ),
        )
        .use(
          provider<MerchantRepository>(
            (context) => MerchantRepository(
              db: context.read<ts.Database<DatabaseSchema>>(),
            ),
          ),
        )
        .use(
          provider<ts.Database<DatabaseSchema>>(
            (context) => Database.db,
          ),
        );
  };
}
