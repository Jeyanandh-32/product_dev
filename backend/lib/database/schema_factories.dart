part of 'schema.dart';

MerchantRow createMerchantRow({
  String id = 'm-1',
  String name = 'Jack Owner',
  String businessName = 'SuperMart',
  String whatsappNumber = '9876543210',
  String email = 'jack@test.com',
  String passwordHash = 'hash',
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final now = DateTime.now();
  return _$MerchantRow._(
    id,
    name,
    businessName,
    whatsappNumber,
    email,
    passwordHash,
    createdAt ?? now,
    updatedAt ?? now,
  );
}

CategoryRow createCategoryRow({
  String id = 'cat-1',
  String name = 'Beverages',
  String merchantId = 'm-1',
  String storeId = 'store-1',
  bool isActive = true,
  String? description,
  String? imageUrl,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final now = DateTime.now();
  return _$CategoryRow._(
    id,
    name,
    merchantId,
    storeId,
    isActive,
    description,
    imageUrl,
    createdAt ?? now,
    updatedAt ?? now,
  );
}

CounterRow createCounterRow({
  String id = 'counter-1',
  String name = 'Main Counter',
  String merchantId = 'm-1',
  String storeId = 'store-1',
  bool isActive = true,
  String? description,
  String? imageUrl,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final now = DateTime.now();
  return _$CounterRow._(
    id,
    name,
    merchantId,
    storeId,
    isActive,
    description,
    imageUrl,
    createdAt ?? now,
    updatedAt ?? now,
  );
}

ProductRow createProductRow({
  String id = 'p-1',
  String merchantId = 'm-1',
  String storeId = 'store-1',
  String name = 'Cold Coffee',
  String? sku = 'SKU123',
  String? barcode = 'BAR123',
  String? description = 'Fresh brew',
  String? imageUrl,
  String categoryId = 'cat-1',
  String counterId = 'counter-1',
  double taxRate = 5.0,
  int basePrice = 2000,
  int sellingPrice = 5000,
  bool isActive = true,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final now = DateTime.now();
  return _$ProductRow._(
    id,
    merchantId,
    storeId,
    name,
    sku,
    barcode,
    description,
    imageUrl,
    categoryId,
    counterId,
    taxRate,
    basePrice,
    sellingPrice,
    isActive,
    createdAt ?? now,
    updatedAt ?? now,
  );
}

StoreRow createStoreRow({
  String id = 'store-1',
  String merchantId = 'm-1',
  String name = 'Downtown Store',
  String? storeType = 'Grocery',
  bool isActive = true,
  bool isOnlineEnabled = true,
  String? activePaymentProvider = 'phonepe',
  String? slug = 'downtown-store',
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final now = DateTime.now();
  return _$StoreRow._(
    id,
    merchantId,
    name,
    storeType,
    isActive,
    isOnlineEnabled,
    activePaymentProvider,
    slug,
    createdAt ?? now,
    updatedAt ?? now,
  );
}

TerminalRow createTerminalRow({
  String code = 'TERM01',
  String merchantId = 'm-1',
  String storeId = 'store-1',
  String name = 'Billing Terminal 1',
  String passwordHash = 'hash',
  bool isActive = true,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final now = DateTime.now();
  return _$TerminalRow._(
    code,
    merchantId,
    storeId,
    name,
    passwordHash,
    isActive,
    createdAt ?? now,
    updatedAt ?? now,
  );
}

CustomerRow createCustomerRow({
  String id = 'cust-1',
  String name = 'John Doe',
  String mobileNumber = '9876543210',
  String pinHash = 'pin_hash',
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final now = DateTime.now();
  return _$CustomerRow._(
    id,
    name,
    mobileNumber,
    pinHash,
    createdAt ?? now,
    updatedAt ?? now,
  );
}

CustomerStoreWalletRow createCustomerStoreWalletRow({
  String customerId = 'cust-1',
  String storeId = 'store-1',
  int walletBalance = 5000,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final now = DateTime.now();
  return _$CustomerStoreWalletRow._(
    customerId,
    storeId,
    walletBalance,
    createdAt ?? now,
    updatedAt ?? now,
  );
}

CustomerRecentStoresRow createCustomerRecentStoresRow({
  String customerId = 'cust-1',
  String storeId = 'store-1',
  DateTime? lastVisitedAt,
}) {
  final now = DateTime.now();
  return _$CustomerRecentStoresRow._(
    customerId,
    storeId,
    lastVisitedAt ?? now,
  );
}

CustomerWalletTransactionRow createCustomerWalletTransactionRow({
  String id = 'tx-1',
  String customerId = 'cust-1',
  String storeId = 'store-1',
  int amount = 5000,
  String type = 'top_up',
  String? reference = 'REF123',
  String status = 'completed',
  DateTime? createdAt,
}) {
  final now = DateTime.now();
  return _$CustomerWalletTransactionRow._(
    id,
    customerId,
    storeId,
    amount,
    type,
    reference,
    status,
    createdAt ?? now,
  );
}

StorePhonePeConfigRow createStorePhonePeConfigRow({
  String id = 'phonepe-cfg-1',
  String storeId = 'store-1',
  bool isEnabled = true,
  String env = 'UAT',
  String? clientId = 'TEST_CLIENT_ID',
  String? clientVersion = 'v1',
  String? clientSecret = 'TEST_CLIENT_SECRET',
  String? saltKey = 'TEST_SALT_KEY',
  int saltIndex = 1,
  bool enableUpi = true,
  bool enableCards = false,
  bool enableNetBanking = false,
  bool enableEmi = false,
  bool enableWallets = false,
  String? allowedUpiApps,
  String webhookAuthType = 'HMAC',
  String? webhookSecretKey = 'TEST_WEBHOOK_SECRET',
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final now = DateTime.now();
  return _$StorePhonePeConfigRow._(
    id,
    storeId,
    isEnabled,
    env,
    clientId,
    clientVersion,
    clientSecret,
    saltKey,
    saltIndex,
    enableUpi,
    enableCards,
    enableNetBanking,
    enableEmi,
    enableWallets,
    allowedUpiApps,
    webhookAuthType,
    webhookSecretKey,
    createdAt ?? now,
    updatedAt ?? now,
  );
}

OrderRow createOrderRow({
  String id = 'ord-1',
  String merchantId = 'm-1',
  String storeId = 'store-1',
  String orderReference = 'ORD_001',
  int billNo = 1,
  String source = 'terminal',
  String type = 'dine_in',
  String status = 'completed',
  String paymentStatus = 'paid',
  String paymentMethod = 'cash',
  int subtotal = 10000,
  int taxTotal = 500,
  int grandTotal = 10500,
  String? terminalCode = 'TERM01',
  DateTime? createdAt,
  DateTime? updatedAt,
  int discountTotal = 0,
  int walletDeduction = 0,
  String? customerId = 'cust-1',
}) {
  final now = DateTime.now();
  return _$OrderRow._(
    id,
    merchantId,
    storeId,
    orderReference,
    billNo,
    source,
    type,
    status,
    paymentStatus,
    paymentMethod,
    subtotal,
    taxTotal,
    grandTotal,
    terminalCode,
    createdAt ?? now,
    updatedAt ?? now,
    discountTotal,
    walletDeduction,
    customerId,
  );
}

OrderItemRow createOrderItemRow({
  String id = 'item-1',
  String orderId = 'ord-1',
  String productId = 'p-1',
  String storeId = 'store-1',
  int quantity = 2,
  int unitPrice = 5000,
  double taxRate = 5.0,
  int discount = 0,
}) {
  return _$OrderItemRow._(
    id,
    orderId,
    productId,
    storeId,
    quantity,
    unitPrice,
    taxRate,
    discount,
  );
}

MerchantSettingsRow createMerchantSettingsRow({
  String merchantId = 'm-1',
  bool waNotifications = true,
  bool lowStockAlerts = true,
  bool dailyReports = false,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final now = DateTime.now();
  return _$MerchantSettingsRow._(
    merchantId,
    waNotifications,
    lowStockAlerts,
    dailyReports,
    createdAt ?? now,
    updatedAt ?? now,
  );
}

StockRow createStockRow({
  String id = 'stock-1',
  String productId = 'p-1',
  String storeId = 'store-1',
  int quantity = 100,
  int lowStockThreshold = 10,
  bool stockMonitor = false,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final now = DateTime.now();
  return _$StockRow._(
    id,
    productId,
    storeId,
    quantity,
    lowStockThreshold,
    stockMonitor,
    createdAt ?? now,
    updatedAt ?? now,
  );
}

StockTransactionRow createStockTransactionRow({
  String id = 'stock-tx-1',
  String productId = 'p-1',
  String storeId = 'store-1',
  String adjustmentType = 'add',
  int quantity = 50,
  String reason = 'restock',
  String? customReason,
  DateTime? createdAt,
}) {
  final now = DateTime.now();
  return _$StockTransactionRow._(
    id,
    productId,
    storeId,
    adjustmentType,
    quantity,
    reason,
    customReason,
    createdAt ?? now,
  );
}
