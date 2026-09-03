import 'package:typed_sql/typed_sql.dart';

part 'constructors/bottle_return_config_constructors.dart';
part 'constructors/bottle_return_token_constructors.dart';
part 'constructors/category_counter_constructors.dart';
part 'constructors/customer_constructors.dart';
part 'constructors/merchant_constructors.dart';
part 'constructors/order_constructors.dart';
part 'constructors/platform_fee_settlement_constructors.dart';
part 'constructors/product_stock_constructors.dart';
part 'constructors/store_constructors.dart';
part 'constructors/subscription_constructors.dart';
part 'constructors/terminal_constructors.dart';
part 'schema.g.dart';
part 'schema/bottle_return_config_schema.dart';
part 'schema/bottle_return_token_schema.dart';
part 'schema/category_counter_schema.dart';
part 'schema/customer_schema.dart';
part 'schema/merchant_schema.dart';
part 'schema/order_schema.dart';
part 'schema/platform_fee_settlement_schema.dart';
part 'schema/product_stock_schema.dart';
part 'schema/store_schema.dart';
part 'schema/subscription_schema.dart';
part 'schema/terminal_schema.dart';

/// Database schema definition defining tables, foreign keys, and indexes for TypedSQL.
@SqlOverride.schema(naming: Naming.snake_case)
abstract final class DatabaseSchema extends Schema {
  Table<MerchantRow> get merchants;
  Table<MerchantSettingsRow> get merchantSettings;
  Table<StoreRow> get stores;
  Table<StorePhonePeConfigRow> get storePhonepeConfigs;
  Table<CategoryRow> get categories;
  Table<CounterRow> get counters;
  Table<ProductRow> get products;
  Table<StockRow> get stocks;
  Table<StockTransactionRow> get stockTransactions;
  Table<TerminalRow> get terminals;
  Table<CustomerRow> get customers;
  Table<CustomerRecentStoresRow> get customerRecentStores;
  Table<CustomerStoreWalletRow> get customerStoreWallets;
  Table<CustomerWalletTransactionRow> get customerWalletTransactions;
  Table<PlatformFeeSettlementRow> get platformFeeSettlements;
  Table<OrderRow> get orders;
  Table<OrderItemRow> get orderItems;
  Table<BottleReturnConfigRow> get bottleReturnConfigs;
  Table<BottleReturnProductRow> get bottleReturnProducts;
  Table<BottleQrTokenRow> get bottleQrTokens;
  Table<BottleCreditRow> get bottleCredits;
  Table<BottleCreditTransactionRow> get bottleCreditTransactions;
  Table<BottlePhysicalCouponRow> get bottlePhysicalCoupons;
  Table<SubscriptionPlanRow> get subscriptionPlans;
  Table<StoreSubscriptionRow> get storeSubscriptions;
  Table<SubscriptionTransactionRow> get subscriptionTransactions;
}
