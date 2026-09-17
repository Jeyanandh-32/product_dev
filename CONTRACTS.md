# Finch POS — Data Contracts

Field-level signatures for the shared models in `packages/models/lib/src/`.
Source of truth is the `.dart` files themselves — this is a quick-reference,
not a substitute for reading the real file when actually editing a model.
All models use `freezed` (immutable, `fromJson`/`toJson` generated).

## Order
`order/order.dart`
```
id: String
merchantId: String
storeId: String
orderReference: String
billNo: int
source: OrderSource
type: OrderType
status: OrderStatus
paymentStatus: PaymentStatus       // unknownEnumValue -> pending
paymentMethod: PaymentMethod
subtotal: double
discountTotal: double = 0.0
walletDeduction: double = 0.0
taxTotal: double
platformFee: double = 0.0
gatewayCharges: double = 0.0
grandTotal: double
terminalCode: String?
customer: Customer?
items: List<OrderItem>
createdAt: DateTime
updatedAt: DateTime
```

## OrderItem
`order_item/order_item.dart`
```
id: String
productId: String
product: Product?
storeId: String
quantity: int
unitPrice: double
discount: double = 0.0
taxRate: double
```

## OrderSource (enum) — `order_source.dart`
`terminal | web | mobileApp`

## OrderStatus (enum) — `order_status.dart`
`pending | preparing | completed | cancelled`
No hold/resume or KOT-related states yet — V1 additions will extend this.

## OrderType (enum) — `order_type.dart`
`dineIn | takeaway | delivery`

## Product
`product/product.dart`
```
id: String
merchantId: String
name: String
taxRate: double
basePrice: double
sellingPrice: double
isActive: bool
createdAt: DateTime
updatedAt: DateTime
sku: String?
barcode: String?
description: String?
imageUrl: String?
stock: Stock?
category: Category?
counter: Counter?
```
No variant/add-on fields yet — V1 must-have, will need new fields or a
related model (e.g. `ProductVariant`).

## Store
`store/store.dart`
```
id: String
merchantId: String
name: String
createdAt: DateTime
updatedAt: DateTime
storeType: String?
isActive: bool
isOnlineEnabled: bool = false
isBottleReturnEnabled: bool = false
isOperational: bool = true
activePaymentProvider: PaymentProvider? = PaymentProvider.phonepe
slug: String?
```

## StoreSubscription
`subscription/store_subscription.dart`
```
id: String
storeId: String
planCode: SubscriptionPlanCode
status: SubscriptionStatus
startsAt: DateTime
endsAt: DateTime
graceEndsAt: DateTime?
autoRenew: bool = true
createdAt: DateTime?
updatedAt: DateTime?
```

## SubscriptionStatus (enum) — `subscription_status.dart`
`trial | active | gracePeriod | expired | canceled`
(JSON: snake_case) — getters: `isOperational` (trial/active/gracePeriod),
`isWarning` (gracePeriod/expired)

## Payment
`payment/payment.dart`
```
id: String
orderReference: String
orderId: String
orderAmount: double
discountAmount: double
paidAmount: double
paymentMode: PaymentMethod
paymentStatus: PaymentStatus       // unknownEnumValue -> pending
date: DateTime
```

## PaymentStatus (enum) — `payment_status.dart`
`completed | pending | failed` — getter: `isPaid` (completed only)
Extension `PaymentStatusStringExtension` on `String`: `isPaidStatus`
(matches `"completed"` or legacy `"paid"`)

## PaymentMethod (enum) — `payment_method.dart`
`cash | upi | complimentary` — getter: `isCash` (cash only)

## Stock
`stock/stock.dart`
```
id: String
productId: String
storeId: String
quantity: int
lowStockThreshold: int
stockMonitor: bool
createdAt: DateTime
updatedAt: DateTime
```

## BottleReturnConfig
`bottle_return/bottle_return_config.dart`
```
storeId: String
isEnabled: bool = true
rewardAmountInRupees: int = 10
iotApiKey: String?
createdAt: DateTime?
updatedAt: DateTime?
```

---

## Gaps relevant to the V1 backlog (nothing here yet, will need new fields/models)
- **Hold/resume bills** — `OrderStatus` has no `held`/`draft` state
- **KOT printing** — no KOT model or `Order`/`OrderItem` fields for kitchen
  routing/print status
- **Variants & add-ons** — `Product` has no variant or add-on relationship
- **Cashier shift handover** — no shift/session model exists yet
- **Order type selector** — `OrderType` exists but UI wiring is separate

## Maintenance
Update this file the same way as `REPO_MAP.md` — when a model's fields
change, a new shared model is added, or an enum gains/loses a value. Skip
`.freezed.dart` / `.g.dart` — those are generated, never hand-edited.
