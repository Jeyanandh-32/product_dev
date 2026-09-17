/// Standardized REST API route path constants used across all clients.
abstract final class ApiEndpoints {
  /// Current active API version segment.
  static const String version = 'v1';

  // Auth
  /// Merchant login authentication endpoint.
  static const String merchantLogin = '/$version/auth/merchant/login';
  /// Merchant account registration endpoint.
  static const String merchantRegister = '/$version/auth/merchant/register';
  /// Customer login authentication endpoint.
  static const String customerLogin = '/$version/auth/customer/login';
  /// Customer account registration endpoint.
  static const String customerRegister = '/$version/auth/customer/register';
  /// POS terminal login authentication endpoint.
  static const String terminalLogin = '/$version/auth/terminal/login';
  /// User logout and session invalidation endpoint.
  static const String logout = '/$version/auth/logout';

  // Resources
  /// Merchants resource endpoint.
  static const String merchants = '/$version/merchants';
  /// Customers resource endpoint.
  static const String customers = '/$version/customers';
  /// Customer recently visited stores endpoint.
  static const String customerRecentStores =
      '/$version/customers/recent-stores';
  /// Customer order history endpoint.
  static const String customerOrders = '/$version/customers/orders';
  /// Customer digital wallet details endpoint.
  static const String customerWallet = '/$version/customers/wallet';
  /// Stores management resource endpoint.
  static const String stores = '/$version/stores';
  /// Store POS terminals resource endpoint.
  static const String terminals = '/$version/terminals';
  /// Store checkout counters resource endpoint.
  static const String counters = '/$version/counters';
  /// Product categories resource endpoint.
  static const String categories = '/$version/categories';
  /// Store products resource endpoint.
  static const String products = '/$version/products';
  /// Inventory stock levels resource endpoint.
  static const String stocks = '/$version/stocks';
  /// Store orders resource endpoint.
  static const String orders = '/$version/orders';
  /// PhonePe payment gateway configuration endpoint for a store.
  static String storePhonePeConfig(String storeId) =>
      '/$version/stores/$storeId/phonepe-config';
  /// Payments processing resource endpoint.
  static const String payments = '/$version/payments';
  /// Orders report endpoint.
  static const String reportsOrders = '/$version/reports/orders';
  /// Payments report endpoint.
  static const String reportsPayments = '/$version/reports/payments';
  /// Profit and loss financial report endpoint.
  static const String profitLoss = '/$version/reports/profit-loss';
  /// Inventory stock summary report endpoint.
  static const String stockSummary = '/$version/reports/stock-summary';
  /// Analytics dashboard metrics report endpoint.
  static const String dashboardReport = '/$version/reports/dashboard';

  // Subscriptions
  /// Available subscription plans listing endpoint.
  static const String subscriptionPlans = '/$version/subscriptions/plans';
  /// Subscription details endpoint for a store.
  static String storeSubscription(String storeId) =>
      '/$version/stores/$storeId/subscription';
  /// Subscription renewal endpoint for a store.
  static String storeSubscriptionRenew(String storeId) =>
      '/$version/stores/$storeId/subscription/renew';
  /// Subscription payment initiation endpoint for a store.
  static String storeSubscriptionInitiatePayment(String storeId) =>
      '/$version/stores/$storeId/subscription/initiate-payment';
  /// Subscription payment verification endpoint for a store.
  static String storeSubscriptionVerifyPayment(String storeId) =>
      '/$version/stores/$storeId/subscription/verify-payment';

  // Bottle Returns
  /// Bottle return system configuration endpoint.
  static const String bottleReturnsConfig = '/$version/bottle-returns/config';
  /// Eligible bottle return products endpoint.
  static const String bottleReturnsProducts =
      '/$version/bottle-returns/products';
  /// Bottle return token generation endpoint.
  static const String bottleReturnsTokens =
      '/$version/bottle-returns/generate-tokens';
  /// Bottle return credits balance endpoint.
  static const String bottleReturnsCreditsBalance =
      '/$version/bottle-returns/credits/balance';
  /// Apply bottle return credits to an order endpoint.
  static const String bottleReturnsCreditsApply =
      '/$version/bottle-returns/credits/apply';
  /// Validate bottle return coupon endpoint.
  static const String bottleReturnsCouponsValidate =
      '/$version/bottle-returns/coupons/validate';
  /// Redeem bottle return coupon endpoint.
  static const String bottleReturnsCouponsRedeem =
      '/$version/bottle-returns/coupons/redeem';
  /// IoT reverse vending machine bottle scan endpoint.
  static const String bottleReturnsIotScan =
      '/$version/bottle-returns/iot/scan-return';
  /// IoT sticker dispenser action endpoint.
  static const String bottleReturnsIotDispense =
      '/$version/bottle-returns/iot/dispense-stickers';

  // Platform Fees
  /// Merchant platform fee summary endpoint.
  static const String merchantPlatformFees =
      '/$version/merchants/platform-fees';
  /// Merchant platform fee payment initiation endpoint.
  static const String merchantPlatformFeesInitiatePayment =
      '/$version/merchants/platform-fees/initiate-payment';
  /// Merchant platform fee payment verification endpoint.
  static const String merchantPlatformFeesVerifyPayment =
      '/$version/merchants/platform-fees/verify-payment';
}
