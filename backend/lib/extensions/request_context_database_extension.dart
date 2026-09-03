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
import 'package:backend/repositories/platform_fee_repository.dart';
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

/// Database and repository accessors on RequestContext.
extension RequestContextDatabaseExtension on RequestContext {
  /// Resolves the database instance provided via root middleware.
  ts.Database<DatabaseSchema> get db {
    try {
      return read<ts.Database<DatabaseSchema>>();
    } catch (_) {
      return Database.db;
    }
  }

  /// Repository for customer profiles, identity, and recent stores.
  CustomerRepository get customerRepo => _repo((db) => CustomerRepository(db: db));

  /// Repository for order placement, status, and summaries.
  OrderRepository get orderRepo => _repo((db) => OrderRepository(db: db));

  /// Repository for order line items and pricing snapshots.
  OrderItemRepository get orderItemRepo => _repo((db) => OrderItemRepository(db: db));

  /// Repository for catalog products and barcodes.
  ProductRepository get productRepo => _repo((db) => ProductRepository(db: db));

  /// Repository for inventory levels and stock adjustments.
  StockRepository get stockRepo => _repo((db) => StockRepository(db: db));

  /// Repository for catalog product categories.
  CategoryRepository get categoryRepo => _repo((db) => CategoryRepository(db: db));

  /// Repository for billing counters and POS stations.
  CounterRepository get counterRepo => _repo((db) => CounterRepository(db: db));

  /// Repository for physical POS terminal stations.
  TerminalRepository get terminalRepo => _repo((db) => TerminalRepository(db: db));

  /// Repository for merchant store profiles.
  StoreRepository get storeRepo => _repo((db) => StoreRepository(db: db));

  /// Repository for merchant accounts and owners.
  MerchantRepository get merchantRepo => _repo((db) => MerchantRepository(db: db));

  /// Repository for merchant preferences and settings.
  MerchantSettingsRepository get merchantSettingsRepo =>
      _repo((db) => MerchantSettingsRepository(db: db));

  /// Repository for store subscriptions and billing tiers.
  SubscriptionRepository get subscriptionRepo =>
      _repo((db) => SubscriptionRepository(db: db));

  /// Repository for smart bottle return operations and vouchers.
  BottleReturnRepository get bottleReturnRepo =>
      _repo((db) => BottleReturnRepository(db: db));

  /// Handler for IoT bottle return dispenser integration.
  BottleReturnDispenserHandler get bottleReturnDispenserHandler =>
      _repo((db) => BottleReturnDispenserHandler(db: db));

  /// Handler for bottle return products and deposit values.
  BottleReturnProductHandler get bottleReturnProductHandler =>
      _repo((db) => BottleReturnProductHandler(db: db));

  /// Handler for active bottle return scanner sessions.
  BottleReturnSessionHandler get bottleReturnSessionHandler =>
      _repo((db) => BottleReturnSessionHandler(db: db));

  /// Configuration repository for platform PhonePe payment credentials.
  PlatformPhonePeConfigRepository get platformPhonePeConfigRepo =>
      _repo((_) => const PlatformPhonePeConfigRepository());

  /// Repository for merchant platform fee calculations and settlements.
  PlatformFeeRepository get platformFeeRepo =>
      _repo((_) => const PlatformFeeRepository());

  /// Domain service coordinating product creation and stock initialization.
  ProductService get productService {
    try {
      return read<ProductService>();
    } catch (_) {
      return ProductService(
        productRepo: productRepo,
        stockRepo: stockRepo,
        categoryRepo: categoryRepo,
        counterRepo: counterRepo,
      );
    }
  }

  /// Domain service coordinating order validation, totals, and stock deductions.
  OrderService get orderService {
    try {
      return read<OrderService>();
    } catch (_) {
      return OrderService(
        orderRepo: orderRepo,
        orderItemRepo: orderItemRepo,
        productRepo: productRepo,
        stockRepo: stockRepo,
      );
    }
  }

  T _repo<T>(T Function(ts.Database<DatabaseSchema> db) factory) {
    try {
      return read<T>();
    } catch (_) {
      return factory(db);
    }
  }
}
