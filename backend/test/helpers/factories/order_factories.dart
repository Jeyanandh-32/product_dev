import 'package:backend/database/schema.dart';

/// Test factory for [TerminalRow].
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
  return constructTerminalRow(
    code: code,
    merchantId: merchantId,
    storeId: storeId,
    name: name,
    passwordHash: passwordHash,
    isActive: isActive,
    createdAt: createdAt ?? now,
    updatedAt: updatedAt ?? now,
  );
}

/// Test factory for [OrderRow].
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
  return constructOrderRow(
    id: id,
    merchantId: merchantId,
    storeId: storeId,
    orderReference: orderReference,
    billNo: billNo,
    source: source,
    type: type,
    status: status,
    paymentStatus: paymentStatus,
    paymentMethod: paymentMethod,
    subtotal: subtotal,
    taxTotal: taxTotal,
    grandTotal: grandTotal,
    createdAt: createdAt ?? now,
    updatedAt: updatedAt ?? now,
    discountTotal: discountTotal,
    walletDeduction: walletDeduction,
    terminalCode: terminalCode,
    customerId: customerId,
  );
}

/// Test factory for [OrderItemRow].
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
  return constructOrderItemRow(
    id: id,
    orderId: orderId,
    productId: productId,
    storeId: storeId,
    quantity: quantity,
    unitPrice: unitPrice,
    taxRate: taxRate,
    discount: discount,
  );
}
