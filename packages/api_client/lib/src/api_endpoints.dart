abstract final class ApiEndpoints {
  static const String version = 'v1';

  // Auth
  static const String merchantLogin = '/$version/auth/merchant/login';
  static const String merchantRegister = '/$version/auth/merchant/register';
  static const String customerLogin = '/$version/auth/customer/login';
  static const String customerRegister = '/$version/auth/customer/register';
  static const String terminalLogin = '/$version/auth/terminal/login';
  static const String logout = '/$version/auth/logout';

  // Resources
  static const String merchants = '/$version/merchants';
  static const String customers = '/$version/customers';
  static const String customerRecentStores =
      '/$version/customers/recent-stores';
  static const String customerOrders = '/$version/customers/orders';
  static const String customerWallet = '/$version/customers/wallet';
  static const String stores = '/$version/stores';
  static const String terminals = '/$version/terminals';
  static const String counters = '/$version/counters';
  static const String categories = '/$version/categories';
  static const String products = '/$version/products';
  static const String stocks = '/$version/stocks';
  static const String orders = '/$version/orders';
  static String storePhonePeConfig(String storeId) =>
      '/$version/stores/$storeId/phonepe-config';
  static const String payments = '/$version/payments';
  static const String reportsOrders = '/$version/reports/orders';
  static const String reportsPayments = '/$version/reports/payments';
  static const String profitLoss = '/$version/reports/profit-loss';
  static const String stockSummary = '/$version/reports/stock-summary';
  static const String dashboardReport = '/$version/reports/dashboard';

  // Subscriptions
  static const String subscriptionPlans = '/$version/subscriptions/plans';
  static String storeSubscription(String storeId) =>
      '/$version/stores/$storeId/subscription';
  static String storeSubscriptionRenew(String storeId) =>
      '/$version/stores/$storeId/subscription/renew';

  // Bottle Returns
  static const String bottleReturnsConfig = '/$version/bottle-returns/config';
  static const String bottleReturnsProducts =
      '/$version/bottle-returns/products';
  static const String bottleReturnsTokens =
      '/$version/bottle-returns/generate-tokens';
  static const String bottleReturnsCreditsBalance =
      '/$version/bottle-returns/credits/balance';
  static const String bottleReturnsCreditsApply =
      '/$version/bottle-returns/credits/apply';
  static const String bottleReturnsCouponsValidate =
      '/$version/bottle-returns/coupons/validate';
  static const String bottleReturnsCouponsRedeem =
      '/$version/bottle-returns/coupons/redeem';
  static const String bottleReturnsIotScan =
      '/$version/bottle-returns/iot/scan-return';
  static const String bottleReturnsIotDispense =
      '/$version/bottle-returns/iot/dispense-stickers';
}
