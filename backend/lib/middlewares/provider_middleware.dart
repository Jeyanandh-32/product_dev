import 'package:backend/config/database.dart';
import 'package:backend/database/schema.dart';
import 'package:backend/repositories/bottle_return_dispenser_handler.dart';
import 'package:backend/repositories/bottle_return_product_handler.dart';
import 'package:backend/repositories/bottle_return_repository.dart';
import 'package:backend/repositories/bottle_return_session_handler.dart';
import 'package:backend/repositories/category_repository.dart';
import 'package:backend/repositories/counter_repository.dart';
import 'package:backend/repositories/customer_repository.dart';
import 'package:backend/repositories/merchant_repository.dart';
import 'package:backend/repositories/merchant_settings_repository.dart';
import 'package:backend/repositories/order_item_repository.dart';
import 'package:backend/repositories/order_repository.dart';
import 'package:backend/repositories/platform_phonepe_config_repository.dart';
import 'package:backend/repositories/product_repository.dart';
import 'package:backend/repositories/stock_repository.dart';
import 'package:backend/repositories/store_repository.dart';
import 'package:backend/repositories/subscription_repository.dart';
import 'package:backend/repositories/terminal_repository.dart';
import 'package:backend/services/order_service.dart';
import 'package:backend/services/product_service.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:typed_sql/typed_sql.dart' as ts;

/// Root provider middleware injecting database, repositories, and services into RequestContext.
Middleware providerMiddleware() {
  return (handler) {
    return handler
        .use(provider<ProductService>((c) => ProductService(
              productRepo: c.read<ProductRepository>(),
              stockRepo: c.read<StockRepository>(),
              categoryRepo: c.read<CategoryRepository>(),
              counterRepo: c.read<CounterRepository>(),
            )))
        .use(provider<OrderService>((c) => OrderService(
              orderRepo: c.read<OrderRepository>(),
              orderItemRepo: c.read<OrderItemRepository>(),
              productRepo: c.read<ProductRepository>(),
              stockRepo: c.read<StockRepository>(),
            )))
        .use(provider<BottleReturnDispenserHandler>((c) => BottleReturnDispenserHandler(db: c.read<ts.Database<DatabaseSchema>>())))
        .use(provider<BottleReturnProductHandler>((c) => BottleReturnProductHandler(db: c.read<ts.Database<DatabaseSchema>>())))
        .use(provider<BottleReturnSessionHandler>((c) => BottleReturnSessionHandler(db: c.read<ts.Database<DatabaseSchema>>())))
        .use(provider<BottleReturnRepository>((c) => BottleReturnRepository(db: c.read<ts.Database<DatabaseSchema>>())))
        .use(provider<PlatformPhonePeConfigRepository>((c) => const PlatformPhonePeConfigRepository()))
        .use(provider<SubscriptionRepository>((c) => SubscriptionRepository(db: c.read<ts.Database<DatabaseSchema>>())))
        .use(provider<OrderRepository>((c) => OrderRepository(db: c.read<ts.Database<DatabaseSchema>>())))
        .use(provider<OrderItemRepository>((c) => OrderItemRepository(db: c.read<ts.Database<DatabaseSchema>>())))
        .use(provider<ProductRepository>((c) => ProductRepository(db: c.read<ts.Database<DatabaseSchema>>())))
        .use(provider<StockRepository>((c) => StockRepository(db: c.read<ts.Database<DatabaseSchema>>())))
        .use(provider<CategoryRepository>((c) => CategoryRepository(db: c.read<ts.Database<DatabaseSchema>>())))
        .use(provider<CounterRepository>((c) => CounterRepository(db: c.read<ts.Database<DatabaseSchema>>())))
        .use(provider<TerminalRepository>((c) => TerminalRepository(db: c.read<ts.Database<DatabaseSchema>>())))
        .use(provider<StoreRepository>((c) => StoreRepository(db: c.read<ts.Database<DatabaseSchema>>())))
        .use(provider<CustomerRepository>((c) => CustomerRepository(db: c.read<ts.Database<DatabaseSchema>>())))
        .use(provider<MerchantRepository>((c) => MerchantRepository(db: c.read<ts.Database<DatabaseSchema>>())))
        .use(provider<MerchantSettingsRepository>((c) => MerchantSettingsRepository(db: c.read<ts.Database<DatabaseSchema>>())))
        .use(provider<ts.Database<DatabaseSchema>>((_) => Database.db));
  };
}
