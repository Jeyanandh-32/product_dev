// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schemas.dart';

// **************************************************************************
// SchemaGenerator
// **************************************************************************

base class BottleReturnConfigUpdate {
  /// Creates a [BottleReturnConfigUpdate] from a JSON map.
  factory BottleReturnConfigUpdate.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  BottleReturnConfigUpdate._(this._json);

  BottleReturnConfigUpdate({
    required String storeId,
    bool? isEnabled,
    int? rewardAmountInRupees,
    String? iotApiKey,
  }) {
    _json = {
      'storeId': storeId,
      'isEnabled': ?isEnabled,
      'rewardAmountInRupees': ?rewardAmountInRupees,
      'iotApiKey': ?iotApiKey,
    };
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [BottleReturnConfigUpdate].
  static const SchemanticType<BottleReturnConfigUpdate> $schema =
      _BottleReturnConfigUpdateTypeFactory();

  String get storeId {
    return _json['storeId'] as String;
  }

  set storeId(String value) {
    _json['storeId'] = value;
  }

  bool? get isEnabled {
    return _json['isEnabled'] as bool?;
  }

  set isEnabled(bool? value) {
    if (value == null) {
      _json.remove('isEnabled');
    } else {
      _json['isEnabled'] = value;
    }
  }

  int? get rewardAmountInRupees {
    return _json['rewardAmountInRupees'] as int?;
  }

  set rewardAmountInRupees(int? value) {
    if (value == null) {
      _json.remove('rewardAmountInRupees');
    } else {
      _json['rewardAmountInRupees'] = value;
    }
  }

  String? get iotApiKey {
    return _json['iotApiKey'] as String?;
  }

  set iotApiKey(String? value) {
    if (value == null) {
      _json.remove('iotApiKey');
    } else {
      _json['iotApiKey'] = value;
    }
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [BottleReturnConfigUpdate] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _BottleReturnConfigUpdateTypeFactory
    extends SchemanticType<BottleReturnConfigUpdate> {
  const _BottleReturnConfigUpdateTypeFactory();

  @override
  BottleReturnConfigUpdate parse(Object? json) {
    return BottleReturnConfigUpdate._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'BottleReturnConfigUpdate',
    definition: $Schema
        .object(
          properties: {
            'storeId': $Schema.string(description: 'Store ID', minLength: 1),
            'isEnabled': $Schema.boolean(description: 'Is enabled'),
            'rewardAmountInRupees': $Schema.integer(
              description: 'Reward amount in rupees',
              minimum: 1,
            ),
            'iotApiKey': $Schema.string(description: 'IoT API key'),
          },
          required: ['storeId'],
        )
        .value,
    dependencies: [],
  );
}

base class BottleReturnProductUpdate {
  /// Creates a [BottleReturnProductUpdate] from a JSON map.
  factory BottleReturnProductUpdate.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  BottleReturnProductUpdate._(this._json);

  BottleReturnProductUpdate({
    required String storeId,
    String? productId,
    List<String>? productIds,
    bool? isReturnable,
  }) {
    _json = {
      'storeId': storeId,
      'productId': ?productId,
      'productIds': ?productIds,
      'isReturnable': ?isReturnable,
    };
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [BottleReturnProductUpdate].
  static const SchemanticType<BottleReturnProductUpdate> $schema =
      _BottleReturnProductUpdateTypeFactory();

  String get storeId {
    return _json['storeId'] as String;
  }

  set storeId(String value) {
    _json['storeId'] = value;
  }

  String? get productId {
    return _json['productId'] as String?;
  }

  set productId(String? value) {
    if (value == null) {
      _json.remove('productId');
    } else {
      _json['productId'] = value;
    }
  }

  List<String>? get productIds {
    return (_json['productIds'] as List?)?.cast<String>();
  }

  set productIds(List<String>? value) {
    if (value == null) {
      _json.remove('productIds');
    } else {
      _json['productIds'] = value;
    }
  }

  bool? get isReturnable {
    return _json['isReturnable'] as bool?;
  }

  set isReturnable(bool? value) {
    if (value == null) {
      _json.remove('isReturnable');
    } else {
      _json['isReturnable'] = value;
    }
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [BottleReturnProductUpdate] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _BottleReturnProductUpdateTypeFactory
    extends SchemanticType<BottleReturnProductUpdate> {
  const _BottleReturnProductUpdateTypeFactory();

  @override
  BottleReturnProductUpdate parse(Object? json) {
    return BottleReturnProductUpdate._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'BottleReturnProductUpdate',
    definition: $Schema
        .object(
          properties: {
            'storeId': $Schema.string(description: 'Store ID', minLength: 1),
            'productId': $Schema.string(description: 'Product ID'),
            'productIds': $Schema.list(
              description: 'List of product IDs',
              items: $Schema.string(),
            ),
            'isReturnable': $Schema.boolean(description: 'Is returnable'),
          },
          required: ['storeId'],
        )
        .value,
    dependencies: [],
  );
}

base class BottleReturnCreditApply {
  /// Creates a [BottleReturnCreditApply] from a JSON map.
  factory BottleReturnCreditApply.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  BottleReturnCreditApply._(this._json);

  BottleReturnCreditApply({
    required String merchantId,
    required String customerPhone,
    required int amount,
    required String storeId,
    String? orderId,
  }) {
    _json = {
      'merchantId': merchantId,
      'customerPhone': customerPhone,
      'amount': amount,
      'storeId': storeId,
      'orderId': ?orderId,
    };
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [BottleReturnCreditApply].
  static const SchemanticType<BottleReturnCreditApply> $schema =
      _BottleReturnCreditApplyTypeFactory();

  String get merchantId {
    return _json['merchantId'] as String;
  }

  set merchantId(String value) {
    _json['merchantId'] = value;
  }

  String get customerPhone {
    return _json['customerPhone'] as String;
  }

  set customerPhone(String value) {
    _json['customerPhone'] = value;
  }

  int get amount {
    return _json['amount'] as int;
  }

  set amount(int value) {
    _json['amount'] = value;
  }

  String get storeId {
    return _json['storeId'] as String;
  }

  set storeId(String value) {
    _json['storeId'] = value;
  }

  String? get orderId {
    return _json['orderId'] as String?;
  }

  set orderId(String? value) {
    if (value == null) {
      _json.remove('orderId');
    } else {
      _json['orderId'] = value;
    }
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [BottleReturnCreditApply] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _BottleReturnCreditApplyTypeFactory
    extends SchemanticType<BottleReturnCreditApply> {
  const _BottleReturnCreditApplyTypeFactory();

  @override
  BottleReturnCreditApply parse(Object? json) {
    return BottleReturnCreditApply._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'BottleReturnCreditApply',
    definition: $Schema
        .object(
          properties: {
            'merchantId': $Schema.string(
              description: 'Merchant ID',
              minLength: 1,
            ),
            'customerPhone': $Schema.string(
              description: 'Customer Phone',
              minLength: 10,
            ),
            'amount': $Schema.integer(description: 'Amount', minimum: 1),
            'storeId': $Schema.string(description: 'Store ID', minLength: 1),
            'orderId': $Schema.string(description: 'Order ID'),
          },
          required: ['merchantId', 'customerPhone', 'amount', 'storeId'],
        )
        .value,
    dependencies: [],
  );
}

base class BottleReturnCouponValidate {
  /// Creates a [BottleReturnCouponValidate] from a JSON map.
  factory BottleReturnCouponValidate.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  BottleReturnCouponValidate._(this._json);

  BottleReturnCouponValidate({
    required String merchantId,
    required String code,
    required String storeId,
  }) {
    _json = {'merchantId': merchantId, 'code': code, 'storeId': storeId};
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [BottleReturnCouponValidate].
  static const SchemanticType<BottleReturnCouponValidate> $schema =
      _BottleReturnCouponValidateTypeFactory();

  String get merchantId {
    return _json['merchantId'] as String;
  }

  set merchantId(String value) {
    _json['merchantId'] = value;
  }

  String get code {
    return _json['code'] as String;
  }

  set code(String value) {
    _json['code'] = value;
  }

  String get storeId {
    return _json['storeId'] as String;
  }

  set storeId(String value) {
    _json['storeId'] = value;
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [BottleReturnCouponValidate] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _BottleReturnCouponValidateTypeFactory
    extends SchemanticType<BottleReturnCouponValidate> {
  const _BottleReturnCouponValidateTypeFactory();

  @override
  BottleReturnCouponValidate parse(Object? json) {
    return BottleReturnCouponValidate._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'BottleReturnCouponValidate',
    definition: $Schema
        .object(
          properties: {
            'merchantId': $Schema.string(
              description: 'Merchant ID',
              minLength: 1,
            ),
            'code': $Schema.string(description: 'Coupon Code', minLength: 1),
            'storeId': $Schema.string(description: 'Store ID', minLength: 1),
          },
          required: ['merchantId', 'code', 'storeId'],
        )
        .value,
    dependencies: [],
  );
}

base class BottleReturnCouponRedeem {
  /// Creates a [BottleReturnCouponRedeem] from a JSON map.
  factory BottleReturnCouponRedeem.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  BottleReturnCouponRedeem._(this._json);

  BottleReturnCouponRedeem({
    required String merchantId,
    required String code,
    required String storeId,
    required String orderId,
  }) {
    _json = {
      'merchantId': merchantId,
      'code': code,
      'storeId': storeId,
      'orderId': orderId,
    };
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [BottleReturnCouponRedeem].
  static const SchemanticType<BottleReturnCouponRedeem> $schema =
      _BottleReturnCouponRedeemTypeFactory();

  String get merchantId {
    return _json['merchantId'] as String;
  }

  set merchantId(String value) {
    _json['merchantId'] = value;
  }

  String get code {
    return _json['code'] as String;
  }

  set code(String value) {
    _json['code'] = value;
  }

  String get storeId {
    return _json['storeId'] as String;
  }

  set storeId(String value) {
    _json['storeId'] = value;
  }

  String get orderId {
    return _json['orderId'] as String;
  }

  set orderId(String value) {
    _json['orderId'] = value;
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [BottleReturnCouponRedeem] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _BottleReturnCouponRedeemTypeFactory
    extends SchemanticType<BottleReturnCouponRedeem> {
  const _BottleReturnCouponRedeemTypeFactory();

  @override
  BottleReturnCouponRedeem parse(Object? json) {
    return BottleReturnCouponRedeem._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'BottleReturnCouponRedeem',
    definition: $Schema
        .object(
          properties: {
            'merchantId': $Schema.string(
              description: 'Merchant ID',
              minLength: 1,
            ),
            'code': $Schema.string(description: 'Coupon Code', minLength: 1),
            'storeId': $Schema.string(description: 'Store ID', minLength: 1),
            'orderId': $Schema.string(description: 'Order ID', minLength: 1),
          },
          required: ['merchantId', 'code', 'storeId', 'orderId'],
        )
        .value,
    dependencies: [],
  );
}

base class BottleReturnIotScan {
  /// Creates a [BottleReturnIotScan] from a JSON map.
  factory BottleReturnIotScan.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  BottleReturnIotScan._(this._json);

  BottleReturnIotScan({
    required String merchantId,
    required String storeId,
    required List<String> tokenStrings,
  }) {
    _json = {
      'merchantId': merchantId,
      'storeId': storeId,
      'tokenStrings': tokenStrings,
    };
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [BottleReturnIotScan].
  static const SchemanticType<BottleReturnIotScan> $schema =
      _BottleReturnIotScanTypeFactory();

  String get merchantId {
    return _json['merchantId'] as String;
  }

  set merchantId(String value) {
    _json['merchantId'] = value;
  }

  String get storeId {
    return _json['storeId'] as String;
  }

  set storeId(String value) {
    _json['storeId'] = value;
  }

  List<String> get tokenStrings {
    return (_json['tokenStrings'] as List).cast<String>();
  }

  set tokenStrings(List<String> value) {
    _json['tokenStrings'] = value;
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [BottleReturnIotScan] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _BottleReturnIotScanTypeFactory
    extends SchemanticType<BottleReturnIotScan> {
  const _BottleReturnIotScanTypeFactory();

  @override
  BottleReturnIotScan parse(Object? json) {
    return BottleReturnIotScan._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'BottleReturnIotScan',
    definition: $Schema
        .object(
          properties: {
            'merchantId': $Schema.string(
              description: 'Merchant ID',
              minLength: 1,
            ),
            'storeId': $Schema.string(description: 'Store ID', minLength: 1),
            'tokenStrings': $Schema.list(
              description: 'Token strings',
              items: $Schema.string(),
            ),
          },
          required: ['merchantId', 'storeId', 'tokenStrings'],
        )
        .value,
    dependencies: [],
  );
}

base class BottleReturnIotDispense {
  /// Creates a [BottleReturnIotDispense] from a JSON map.
  factory BottleReturnIotDispense.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  BottleReturnIotDispense._(this._json);

  BottleReturnIotDispense({required String orderReference}) {
    _json = {'orderReference': orderReference};
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [BottleReturnIotDispense].
  static const SchemanticType<BottleReturnIotDispense> $schema =
      _BottleReturnIotDispenseTypeFactory();

  String get orderReference {
    return _json['orderReference'] as String;
  }

  set orderReference(String value) {
    _json['orderReference'] = value;
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [BottleReturnIotDispense] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _BottleReturnIotDispenseTypeFactory
    extends SchemanticType<BottleReturnIotDispense> {
  const _BottleReturnIotDispenseTypeFactory();

  @override
  BottleReturnIotDispense parse(Object? json) {
    return BottleReturnIotDispense._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'BottleReturnIotDispense',
    definition: $Schema
        .object(
          properties: {
            'orderReference': $Schema.string(
              description: 'Order reference',
              minLength: 1,
            ),
          },
          required: ['orderReference'],
        )
        .value,
    dependencies: [],
  );
}

base class BottleReturnTokenItem {
  /// Creates a [BottleReturnTokenItem] from a JSON map.
  factory BottleReturnTokenItem.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  BottleReturnTokenItem._(this._json);

  BottleReturnTokenItem({
    required String productId,
    required int quantity,
    bool? isReturnableBottle,
  }) {
    _json = {
      'productId': productId,
      'quantity': quantity,
      'isReturnableBottle': ?isReturnableBottle,
    };
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [BottleReturnTokenItem].
  static const SchemanticType<BottleReturnTokenItem> $schema =
      _BottleReturnTokenItemTypeFactory();

  String get productId {
    return _json['productId'] as String;
  }

  set productId(String value) {
    _json['productId'] = value;
  }

  int get quantity {
    return _json['quantity'] as int;
  }

  set quantity(int value) {
    _json['quantity'] = value;
  }

  bool? get isReturnableBottle {
    return _json['isReturnableBottle'] as bool?;
  }

  set isReturnableBottle(bool? value) {
    if (value == null) {
      _json.remove('isReturnableBottle');
    } else {
      _json['isReturnableBottle'] = value;
    }
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [BottleReturnTokenItem] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _BottleReturnTokenItemTypeFactory
    extends SchemanticType<BottleReturnTokenItem> {
  const _BottleReturnTokenItemTypeFactory();

  @override
  BottleReturnTokenItem parse(Object? json) {
    return BottleReturnTokenItem._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'BottleReturnTokenItem',
    definition: $Schema
        .object(
          properties: {
            'productId': $Schema.string(
              description: 'Product ID',
              minLength: 1,
            ),
            'quantity': $Schema.integer(description: 'Quantity', minimum: 1),
            'isReturnableBottle': $Schema.boolean(
              description: 'Is returnable bottle',
            ),
          },
          required: ['productId', 'quantity'],
        )
        .value,
    dependencies: [],
  );
}

base class BottleReturnTokensGenerate {
  /// Creates a [BottleReturnTokensGenerate] from a JSON map.
  factory BottleReturnTokensGenerate.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  BottleReturnTokensGenerate._(this._json);

  BottleReturnTokensGenerate({
    required String merchantId,
    required String storeId,
    required String orderId,
    String? rewardMode,
    String? customerPhone,
    required List<BottleReturnTokenItem> items,
  }) {
    _json = {
      'merchantId': merchantId,
      'storeId': storeId,
      'orderId': orderId,
      'rewardMode': ?rewardMode,
      'customerPhone': ?customerPhone,
      'items': items.map((e) => e.toJson()).toList(),
    };
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [BottleReturnTokensGenerate].
  static const SchemanticType<BottleReturnTokensGenerate> $schema =
      _BottleReturnTokensGenerateTypeFactory();

  String get merchantId {
    return _json['merchantId'] as String;
  }

  set merchantId(String value) {
    _json['merchantId'] = value;
  }

  String get storeId {
    return _json['storeId'] as String;
  }

  set storeId(String value) {
    _json['storeId'] = value;
  }

  String get orderId {
    return _json['orderId'] as String;
  }

  set orderId(String value) {
    _json['orderId'] = value;
  }

  String? get rewardMode {
    return _json['rewardMode'] as String?;
  }

  set rewardMode(String? value) {
    if (value == null) {
      _json.remove('rewardMode');
    } else {
      _json['rewardMode'] = value;
    }
  }

  String? get customerPhone {
    return _json['customerPhone'] as String?;
  }

  set customerPhone(String? value) {
    if (value == null) {
      _json.remove('customerPhone');
    } else {
      _json['customerPhone'] = value;
    }
  }

  List<BottleReturnTokenItem> get items {
    return (_json['items'] as List)
        .map((e) => BottleReturnTokenItem.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  set items(List<BottleReturnTokenItem> value) {
    _json['items'] = value.map((e) => e.toJson()).toList();
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [BottleReturnTokensGenerate] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _BottleReturnTokensGenerateTypeFactory
    extends SchemanticType<BottleReturnTokensGenerate> {
  const _BottleReturnTokensGenerateTypeFactory();

  @override
  BottleReturnTokensGenerate parse(Object? json) {
    return BottleReturnTokensGenerate._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'BottleReturnTokensGenerate',
    definition: $Schema
        .object(
          properties: {
            'merchantId': $Schema.string(
              description: 'Merchant ID',
              minLength: 1,
            ),
            'storeId': $Schema.string(description: 'Store ID', minLength: 1),
            'orderId': $Schema.string(description: 'Order ID', minLength: 1),
            'rewardMode': $Schema.string(description: 'Reward mode'),
            'customerPhone': $Schema.string(description: 'Customer phone'),
            'items': $Schema.list(
              description: 'Returnable item list',
              items: $Schema.fromMap({
                '\$ref': r'#/$defs/BottleReturnTokenItem',
              }),
            ),
          },
          required: ['merchantId', 'storeId', 'orderId', 'items'],
        )
        .value,
    dependencies: [BottleReturnTokenItem.$schema],
  );
}

base class CategoryCreate {
  /// Creates a [CategoryCreate] from a JSON map.
  factory CategoryCreate.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  CategoryCreate._(this._json);

  CategoryCreate({
    required String name,
    String? description,
    String? imageUrl,
  }) {
    _json = {'name': name, 'description': ?description, 'imageUrl': ?imageUrl};
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [CategoryCreate].
  static const SchemanticType<CategoryCreate> $schema =
      _CategoryCreateTypeFactory();

  String get name {
    return _json['name'] as String;
  }

  set name(String value) {
    _json['name'] = value;
  }

  String? get description {
    return _json['description'] as String?;
  }

  set description(String? value) {
    if (value == null) {
      _json.remove('description');
    } else {
      _json['description'] = value;
    }
  }

  String? get imageUrl {
    return _json['imageUrl'] as String?;
  }

  set imageUrl(String? value) {
    if (value == null) {
      _json.remove('imageUrl');
    } else {
      _json['imageUrl'] = value;
    }
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [CategoryCreate] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _CategoryCreateTypeFactory extends SchemanticType<CategoryCreate> {
  const _CategoryCreateTypeFactory();

  @override
  CategoryCreate parse(Object? json) {
    return CategoryCreate._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'CategoryCreate',
    definition: $Schema
        .object(
          properties: {
            'name': $Schema.string(
              description: 'Category name',
              minLength: 1,
              maxLength: 255,
            ),
            'description': $Schema.string(
              description: 'Category description',
              maxLength: 255,
            ),
            'imageUrl': $Schema.string(
              description: 'Category image URL',
              maxLength: 255,
            ),
          },
          required: ['name'],
        )
        .value,
    dependencies: [],
  );
}

base class CategoryUpdate {
  /// Creates a [CategoryUpdate] from a JSON map.
  factory CategoryUpdate.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  CategoryUpdate._(this._json);

  CategoryUpdate({
    String? name,
    bool? isActive,
    String? description,
    String? imageUrl,
  }) {
    _json = {
      'name': ?name,
      'isActive': ?isActive,
      'description': ?description,
      'imageUrl': ?imageUrl,
    };
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [CategoryUpdate].
  static const SchemanticType<CategoryUpdate> $schema =
      _CategoryUpdateTypeFactory();

  String? get name {
    return _json['name'] as String?;
  }

  set name(String? value) {
    if (value == null) {
      _json.remove('name');
    } else {
      _json['name'] = value;
    }
  }

  bool? get isActive {
    return _json['isActive'] as bool?;
  }

  set isActive(bool? value) {
    if (value == null) {
      _json.remove('isActive');
    } else {
      _json['isActive'] = value;
    }
  }

  String? get description {
    return _json['description'] as String?;
  }

  set description(String? value) {
    if (value == null) {
      _json.remove('description');
    } else {
      _json['description'] = value;
    }
  }

  String? get imageUrl {
    return _json['imageUrl'] as String?;
  }

  set imageUrl(String? value) {
    if (value == null) {
      _json.remove('imageUrl');
    } else {
      _json['imageUrl'] = value;
    }
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [CategoryUpdate] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _CategoryUpdateTypeFactory extends SchemanticType<CategoryUpdate> {
  const _CategoryUpdateTypeFactory();

  @override
  CategoryUpdate parse(Object? json) {
    return CategoryUpdate._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'CategoryUpdate',
    definition: $Schema
        .object(
          properties: {
            'name': $Schema.string(
              description: 'Category name',
              minLength: 1,
              maxLength: 255,
            ),
            'isActive': $Schema.boolean(description: 'Is active status'),
            'description': $Schema.string(
              description: 'Category description',
              maxLength: 255,
            ),
            'imageUrl': $Schema.string(
              description: 'Category image URL',
              maxLength: 255,
            ),
          },
        )
        .value,
    dependencies: [],
  );
}

base class CounterCreate {
  /// Creates a [CounterCreate] from a JSON map.
  factory CounterCreate.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  CounterCreate._(this._json);

  CounterCreate({required String name, String? description, String? imageUrl}) {
    _json = {'name': name, 'description': ?description, 'imageUrl': ?imageUrl};
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [CounterCreate].
  static const SchemanticType<CounterCreate> $schema =
      _CounterCreateTypeFactory();

  String get name {
    return _json['name'] as String;
  }

  set name(String value) {
    _json['name'] = value;
  }

  String? get description {
    return _json['description'] as String?;
  }

  set description(String? value) {
    if (value == null) {
      _json.remove('description');
    } else {
      _json['description'] = value;
    }
  }

  String? get imageUrl {
    return _json['imageUrl'] as String?;
  }

  set imageUrl(String? value) {
    if (value == null) {
      _json.remove('imageUrl');
    } else {
      _json['imageUrl'] = value;
    }
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [CounterCreate] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _CounterCreateTypeFactory extends SchemanticType<CounterCreate> {
  const _CounterCreateTypeFactory();

  @override
  CounterCreate parse(Object? json) {
    return CounterCreate._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'CounterCreate',
    definition: $Schema
        .object(
          properties: {
            'name': $Schema.string(
              description: 'Counter name',
              minLength: 1,
              maxLength: 255,
            ),
            'description': $Schema.string(
              description: 'Counter description',
              maxLength: 255,
            ),
            'imageUrl': $Schema.string(
              description: 'Counter image URL',
              maxLength: 255,
            ),
          },
          required: ['name'],
        )
        .value,
    dependencies: [],
  );
}

base class CounterUpdate {
  /// Creates a [CounterUpdate] from a JSON map.
  factory CounterUpdate.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  CounterUpdate._(this._json);

  CounterUpdate({
    String? name,
    bool? isActive,
    String? description,
    String? imageUrl,
  }) {
    _json = {
      'name': ?name,
      'isActive': ?isActive,
      'description': ?description,
      'imageUrl': ?imageUrl,
    };
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [CounterUpdate].
  static const SchemanticType<CounterUpdate> $schema =
      _CounterUpdateTypeFactory();

  String? get name {
    return _json['name'] as String?;
  }

  set name(String? value) {
    if (value == null) {
      _json.remove('name');
    } else {
      _json['name'] = value;
    }
  }

  bool? get isActive {
    return _json['isActive'] as bool?;
  }

  set isActive(bool? value) {
    if (value == null) {
      _json.remove('isActive');
    } else {
      _json['isActive'] = value;
    }
  }

  String? get description {
    return _json['description'] as String?;
  }

  set description(String? value) {
    if (value == null) {
      _json.remove('description');
    } else {
      _json['description'] = value;
    }
  }

  String? get imageUrl {
    return _json['imageUrl'] as String?;
  }

  set imageUrl(String? value) {
    if (value == null) {
      _json.remove('imageUrl');
    } else {
      _json['imageUrl'] = value;
    }
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [CounterUpdate] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _CounterUpdateTypeFactory extends SchemanticType<CounterUpdate> {
  const _CounterUpdateTypeFactory();

  @override
  CounterUpdate parse(Object? json) {
    return CounterUpdate._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'CounterUpdate',
    definition: $Schema
        .object(
          properties: {
            'name': $Schema.string(
              description: 'Counter name',
              minLength: 1,
              maxLength: 255,
            ),
            'isActive': $Schema.boolean(description: 'Is active status'),
            'description': $Schema.string(
              description: 'Counter description',
              maxLength: 255,
            ),
            'imageUrl': $Schema.string(
              description: 'Counter image URL',
              maxLength: 255,
            ),
          },
        )
        .value,
    dependencies: [],
  );
}

base class CustomerRegister {
  /// Creates a [CustomerRegister] from a JSON map.
  factory CustomerRegister.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  CustomerRegister._(this._json);

  CustomerRegister({
    required String name,
    required String mobileNumber,
    required String pin,
  }) {
    _json = {'name': name, 'mobileNumber': mobileNumber, 'pin': pin};
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [CustomerRegister].
  static const SchemanticType<CustomerRegister> $schema =
      _CustomerRegisterTypeFactory();

  String get name {
    return _json['name'] as String;
  }

  set name(String value) {
    _json['name'] = value;
  }

  String get mobileNumber {
    return _json['mobileNumber'] as String;
  }

  set mobileNumber(String value) {
    _json['mobileNumber'] = value;
  }

  String get pin {
    return _json['pin'] as String;
  }

  set pin(String value) {
    _json['pin'] = value;
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [CustomerRegister] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _CustomerRegisterTypeFactory
    extends SchemanticType<CustomerRegister> {
  const _CustomerRegisterTypeFactory();

  @override
  CustomerRegister parse(Object? json) {
    return CustomerRegister._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'CustomerRegister',
    definition: $Schema
        .object(
          properties: {
            'name': $Schema.string(
              description: 'Full Name',
              minLength: 1,
              maxLength: 255,
            ),
            'mobileNumber': $Schema.string(
              description: '10-Digit Mobile Number',
              pattern: r'^[0-9]{10}$',
            ),
            'pin': $Schema.string(
              description: '6-Digit Security PIN',
              minLength: 6,
              maxLength: 6,
              pattern: r'^[0-9]{6}$',
            ),
          },
          required: ['name', 'mobileNumber', 'pin'],
        )
        .value,
    dependencies: [],
  );
}

base class CustomerLogin {
  /// Creates a [CustomerLogin] from a JSON map.
  factory CustomerLogin.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  CustomerLogin._(this._json);

  CustomerLogin({required String mobileNumber, required String pin}) {
    _json = {'mobileNumber': mobileNumber, 'pin': pin};
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [CustomerLogin].
  static const SchemanticType<CustomerLogin> $schema =
      _CustomerLoginTypeFactory();

  String get mobileNumber {
    return _json['mobileNumber'] as String;
  }

  set mobileNumber(String value) {
    _json['mobileNumber'] = value;
  }

  String get pin {
    return _json['pin'] as String;
  }

  set pin(String value) {
    _json['pin'] = value;
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [CustomerLogin] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _CustomerLoginTypeFactory extends SchemanticType<CustomerLogin> {
  const _CustomerLoginTypeFactory();

  @override
  CustomerLogin parse(Object? json) {
    return CustomerLogin._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'CustomerLogin',
    definition: $Schema
        .object(
          properties: {
            'mobileNumber': $Schema.string(
              description: '10-Digit Mobile Number',
              pattern: r'^[0-9]{10}$',
            ),
            'pin': $Schema.string(
              description: '6-Digit Security PIN',
              minLength: 6,
              maxLength: 6,
              pattern: r'^[0-9]{6}$',
            ),
          },
          required: ['mobileNumber', 'pin'],
        )
        .value,
    dependencies: [],
  );
}

base class CustomerRecentStoresUpdate {
  /// Creates a [CustomerRecentStoresUpdate] from a JSON map.
  factory CustomerRecentStoresUpdate.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  CustomerRecentStoresUpdate._(this._json);

  CustomerRecentStoresUpdate({required String storeId}) {
    _json = {'storeId': storeId};
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [CustomerRecentStoresUpdate].
  static const SchemanticType<CustomerRecentStoresUpdate> $schema =
      _CustomerRecentStoresUpdateTypeFactory();

  String get storeId {
    return _json['storeId'] as String;
  }

  set storeId(String value) {
    _json['storeId'] = value;
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [CustomerRecentStoresUpdate] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _CustomerRecentStoresUpdateTypeFactory
    extends SchemanticType<CustomerRecentStoresUpdate> {
  const _CustomerRecentStoresUpdateTypeFactory();

  @override
  CustomerRecentStoresUpdate parse(Object? json) {
    return CustomerRecentStoresUpdate._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'CustomerRecentStoresUpdate',
    definition: $Schema
        .object(
          properties: {
            'storeId': $Schema.string(description: 'Store ID', minLength: 1),
          },
          required: ['storeId'],
        )
        .value,
    dependencies: [],
  );
}

base class CustomerWalletTopUp {
  /// Creates a [CustomerWalletTopUp] from a JSON map.
  factory CustomerWalletTopUp.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  CustomerWalletTopUp._(this._json);

  CustomerWalletTopUp({required double amount, required String storeId}) {
    _json = {'amount': amount, 'storeId': storeId};
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [CustomerWalletTopUp].
  static const SchemanticType<CustomerWalletTopUp> $schema =
      _CustomerWalletTopUpTypeFactory();

  double get amount {
    return (_json['amount'] as num).toDouble();
  }

  set amount(double value) {
    _json['amount'] = value;
  }

  String get storeId {
    return _json['storeId'] as String;
  }

  set storeId(String value) {
    _json['storeId'] = value;
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [CustomerWalletTopUp] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _CustomerWalletTopUpTypeFactory
    extends SchemanticType<CustomerWalletTopUp> {
  const _CustomerWalletTopUpTypeFactory();

  @override
  CustomerWalletTopUp parse(Object? json) {
    return CustomerWalletTopUp._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'CustomerWalletTopUp',
    definition: $Schema
        .object(
          properties: {
            'amount': $Schema.number(
              description: 'Top-up amount in rupees',
              minimum: 1,
            ),
            'storeId': $Schema.string(description: 'Store ID', minLength: 1),
          },
          required: ['amount', 'storeId'],
        )
        .value,
    dependencies: [],
  );
}

base class CustomerUpdate {
  /// Creates a [CustomerUpdate] from a JSON map.
  factory CustomerUpdate.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  CustomerUpdate._(this._json);

  CustomerUpdate({
    String? name,
    String? mobileNumber,
    String? pin,
    String? currentPin,
  }) {
    _json = {
      'name': ?name,
      'mobileNumber': ?mobileNumber,
      'pin': ?pin,
      'currentPin': ?currentPin,
    };
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [CustomerUpdate].
  static const SchemanticType<CustomerUpdate> $schema =
      _CustomerUpdateTypeFactory();

  String? get name {
    return _json['name'] as String?;
  }

  set name(String? value) {
    if (value == null) {
      _json.remove('name');
    } else {
      _json['name'] = value;
    }
  }

  String? get mobileNumber {
    return _json['mobileNumber'] as String?;
  }

  set mobileNumber(String? value) {
    if (value == null) {
      _json.remove('mobileNumber');
    } else {
      _json['mobileNumber'] = value;
    }
  }

  String? get pin {
    return _json['pin'] as String?;
  }

  set pin(String? value) {
    if (value == null) {
      _json.remove('pin');
    } else {
      _json['pin'] = value;
    }
  }

  String? get currentPin {
    return _json['currentPin'] as String?;
  }

  set currentPin(String? value) {
    if (value == null) {
      _json.remove('currentPin');
    } else {
      _json['currentPin'] = value;
    }
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [CustomerUpdate] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _CustomerUpdateTypeFactory extends SchemanticType<CustomerUpdate> {
  const _CustomerUpdateTypeFactory();

  @override
  CustomerUpdate parse(Object? json) {
    return CustomerUpdate._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'CustomerUpdate',
    definition: $Schema
        .object(
          properties: {
            'name': $Schema.string(description: 'Full Name'),
            'mobileNumber': $Schema.string(
              description: '10-Digit Mobile Number',
            ),
            'pin': $Schema.string(description: 'New PIN'),
            'currentPin': $Schema.string(description: 'Current PIN'),
          },
        )
        .value,
    dependencies: [],
  );
}

base class MerchantRegister {
  /// Creates a [MerchantRegister] from a JSON map.
  factory MerchantRegister.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  MerchantRegister._(this._json);

  MerchantRegister({
    required String name,
    required String businessName,
    required String whatsappNumber,
    required String email,
    required String password,
  }) {
    _json = {
      'name': name,
      'businessName': businessName,
      'whatsappNumber': whatsappNumber,
      'email': email,
      'password': password,
    };
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [MerchantRegister].
  static const SchemanticType<MerchantRegister> $schema =
      _MerchantRegisterTypeFactory();

  String get name {
    return _json['name'] as String;
  }

  set name(String value) {
    _json['name'] = value;
  }

  String get businessName {
    return _json['businessName'] as String;
  }

  set businessName(String value) {
    _json['businessName'] = value;
  }

  String get whatsappNumber {
    return _json['whatsappNumber'] as String;
  }

  set whatsappNumber(String value) {
    _json['whatsappNumber'] = value;
  }

  String get email {
    return _json['email'] as String;
  }

  set email(String value) {
    _json['email'] = value;
  }

  String get password {
    return _json['password'] as String;
  }

  set password(String value) {
    _json['password'] = value;
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [MerchantRegister] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _MerchantRegisterTypeFactory
    extends SchemanticType<MerchantRegister> {
  const _MerchantRegisterTypeFactory();

  @override
  MerchantRegister parse(Object? json) {
    return MerchantRegister._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'MerchantRegister',
    definition: $Schema
        .object(
          properties: {
            'name': $Schema.string(description: 'Merchant name', minLength: 1),
            'businessName': $Schema.string(
              description: 'Business name',
              minLength: 1,
            ),
            'whatsappNumber': $Schema.string(
              description: 'Whatsapp number',
              pattern: r'^[0-9]{10}$',
            ),
            'email': $Schema.string(
              description: 'Email address',
              pattern: r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
            ),
            'password': $Schema.string(
              description: 'Password',
              pattern: r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,}$',
            ),
          },
          required: [
            'name',
            'businessName',
            'whatsappNumber',
            'email',
            'password',
          ],
        )
        .value,
    dependencies: [],
  );
}

base class MerchantLogin {
  /// Creates a [MerchantLogin] from a JSON map.
  factory MerchantLogin.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  MerchantLogin._(this._json);

  MerchantLogin({required String email, required String password}) {
    _json = {'email': email, 'password': password};
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [MerchantLogin].
  static const SchemanticType<MerchantLogin> $schema =
      _MerchantLoginTypeFactory();

  String get email {
    return _json['email'] as String;
  }

  set email(String value) {
    _json['email'] = value;
  }

  String get password {
    return _json['password'] as String;
  }

  set password(String value) {
    _json['password'] = value;
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [MerchantLogin] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _MerchantLoginTypeFactory extends SchemanticType<MerchantLogin> {
  const _MerchantLoginTypeFactory();

  @override
  MerchantLogin parse(Object? json) {
    return MerchantLogin._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'MerchantLogin',
    definition: $Schema
        .object(
          properties: {
            'email': $Schema.string(
              description: 'Email address',
              pattern: r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
            ),
            'password': $Schema.string(
              description: 'Password',
              pattern: r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,}$',
            ),
          },
          required: ['email', 'password'],
        )
        .value,
    dependencies: [],
  );
}

base class MerchantSettingsUpdate {
  /// Creates a [MerchantSettingsUpdate] from a JSON map.
  factory MerchantSettingsUpdate.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  MerchantSettingsUpdate._(this._json);

  MerchantSettingsUpdate({
    bool? waNotifications,
    bool? lowStockAlerts,
    bool? dailyReports,
  }) {
    _json = {
      'waNotifications': ?waNotifications,
      'lowStockAlerts': ?lowStockAlerts,
      'dailyReports': ?dailyReports,
    };
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [MerchantSettingsUpdate].
  static const SchemanticType<MerchantSettingsUpdate> $schema =
      _MerchantSettingsUpdateTypeFactory();

  bool? get waNotifications {
    return _json['waNotifications'] as bool?;
  }

  set waNotifications(bool? value) {
    if (value == null) {
      _json.remove('waNotifications');
    } else {
      _json['waNotifications'] = value;
    }
  }

  bool? get lowStockAlerts {
    return _json['lowStockAlerts'] as bool?;
  }

  set lowStockAlerts(bool? value) {
    if (value == null) {
      _json.remove('lowStockAlerts');
    } else {
      _json['lowStockAlerts'] = value;
    }
  }

  bool? get dailyReports {
    return _json['dailyReports'] as bool?;
  }

  set dailyReports(bool? value) {
    if (value == null) {
      _json.remove('dailyReports');
    } else {
      _json['dailyReports'] = value;
    }
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [MerchantSettingsUpdate] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _MerchantSettingsUpdateTypeFactory
    extends SchemanticType<MerchantSettingsUpdate> {
  const _MerchantSettingsUpdateTypeFactory();

  @override
  MerchantSettingsUpdate parse(Object? json) {
    return MerchantSettingsUpdate._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'MerchantSettingsUpdate',
    definition: $Schema
        .object(
          properties: {
            'waNotifications': $Schema.boolean(
              description: 'WhatsApp notifications enabled',
            ),
            'lowStockAlerts': $Schema.boolean(
              description: 'Low stock alerts enabled',
            ),
            'dailyReports': $Schema.boolean(
              description: 'Daily reports enabled',
            ),
          },
        )
        .value,
    dependencies: [],
  );
}

base class MerchantUpdate {
  /// Creates a [MerchantUpdate] from a JSON map.
  factory MerchantUpdate.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  MerchantUpdate._(this._json);

  MerchantUpdate({
    String? name,
    String? businessName,
    String? whatsappNumber,
    String? email,
    String? currentPassword,
    String? newPassword,
  }) {
    _json = {
      'name': ?name,
      'businessName': ?businessName,
      'whatsappNumber': ?whatsappNumber,
      'email': ?email,
      'currentPassword': ?currentPassword,
      'newPassword': ?newPassword,
    };
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [MerchantUpdate].
  static const SchemanticType<MerchantUpdate> $schema =
      _MerchantUpdateTypeFactory();

  String? get name {
    return _json['name'] as String?;
  }

  set name(String? value) {
    if (value == null) {
      _json.remove('name');
    } else {
      _json['name'] = value;
    }
  }

  String? get businessName {
    return _json['businessName'] as String?;
  }

  set businessName(String? value) {
    if (value == null) {
      _json.remove('businessName');
    } else {
      _json['businessName'] = value;
    }
  }

  String? get whatsappNumber {
    return _json['whatsappNumber'] as String?;
  }

  set whatsappNumber(String? value) {
    if (value == null) {
      _json.remove('whatsappNumber');
    } else {
      _json['whatsappNumber'] = value;
    }
  }

  String? get email {
    return _json['email'] as String?;
  }

  set email(String? value) {
    if (value == null) {
      _json.remove('email');
    } else {
      _json['email'] = value;
    }
  }

  String? get currentPassword {
    return _json['currentPassword'] as String?;
  }

  set currentPassword(String? value) {
    if (value == null) {
      _json.remove('currentPassword');
    } else {
      _json['currentPassword'] = value;
    }
  }

  String? get newPassword {
    return _json['newPassword'] as String?;
  }

  set newPassword(String? value) {
    if (value == null) {
      _json.remove('newPassword');
    } else {
      _json['newPassword'] = value;
    }
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [MerchantUpdate] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _MerchantUpdateTypeFactory extends SchemanticType<MerchantUpdate> {
  const _MerchantUpdateTypeFactory();

  @override
  MerchantUpdate parse(Object? json) {
    return MerchantUpdate._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'MerchantUpdate',
    definition: $Schema
        .object(
          properties: {
            'name': $Schema.string(description: 'Merchant name'),
            'businessName': $Schema.string(description: 'Business name'),
            'whatsappNumber': $Schema.string(
              description: 'Whatsapp number',
              pattern: r'^[0-9]{10}$',
            ),
            'email': $Schema.string(
              description: 'Email address',
              pattern: r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
            ),
            'currentPassword': $Schema.string(description: 'Current password'),
            'newPassword': $Schema.string(description: 'New password'),
          },
        )
        .value,
    dependencies: [],
  );
}

base class OrderProduct {
  /// Creates a [OrderProduct] from a JSON map.
  factory OrderProduct.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  OrderProduct._(this._json);

  OrderProduct({
    required String productId,
    required int quantity,
    double? discount,
  }) {
    _json = {
      'productId': productId,
      'quantity': quantity,
      'discount': ?discount,
    };
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [OrderProduct].
  static const SchemanticType<OrderProduct> $schema =
      _OrderProductTypeFactory();

  String get productId {
    return _json['productId'] as String;
  }

  set productId(String value) {
    _json['productId'] = value;
  }

  int get quantity {
    return _json['quantity'] as int;
  }

  set quantity(int value) {
    _json['quantity'] = value;
  }

  double? get discount {
    return (_json['discount'] as num?)?.toDouble();
  }

  set discount(double? value) {
    if (value == null) {
      _json.remove('discount');
    } else {
      _json['discount'] = value;
    }
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [OrderProduct] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _OrderProductTypeFactory extends SchemanticType<OrderProduct> {
  const _OrderProductTypeFactory();

  @override
  OrderProduct parse(Object? json) {
    return OrderProduct._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'OrderProduct',
    definition: $Schema
        .object(
          properties: {
            'productId': $Schema.string(
              description: 'Product ID',
              minLength: 1,
            ),
            'quantity': $Schema.integer(description: 'Quantity', minimum: 1),
            'discount': $Schema.number(description: 'Discount', minimum: 0),
          },
          required: ['productId', 'quantity'],
        )
        .value,
    dependencies: [],
  );
}

base class OrderCreate {
  /// Creates a [OrderCreate] from a JSON map.
  factory OrderCreate.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  OrderCreate._(this._json);

  OrderCreate({
    String? source,
    String? type,
    String? paymentMethod,
    double? discountTotal,
    bool? useWallet,
    double? walletDeduction,
    required List<OrderProduct> products,
  }) {
    _json = {
      'source': ?source,
      'type': ?type,
      'paymentMethod': ?paymentMethod,
      'discountTotal': ?discountTotal,
      'useWallet': ?useWallet,
      'walletDeduction': ?walletDeduction,
      'products': products.map((e) => e.toJson()).toList(),
    };
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [OrderCreate].
  static const SchemanticType<OrderCreate> $schema = _OrderCreateTypeFactory();

  String? get source {
    return _json['source'] as String?;
  }

  set source(String? value) {
    if (value == null) {
      _json.remove('source');
    } else {
      _json['source'] = value;
    }
  }

  String? get type {
    return _json['type'] as String?;
  }

  set type(String? value) {
    if (value == null) {
      _json.remove('type');
    } else {
      _json['type'] = value;
    }
  }

  String? get paymentMethod {
    return _json['paymentMethod'] as String?;
  }

  set paymentMethod(String? value) {
    if (value == null) {
      _json.remove('paymentMethod');
    } else {
      _json['paymentMethod'] = value;
    }
  }

  double? get discountTotal {
    return (_json['discountTotal'] as num?)?.toDouble();
  }

  set discountTotal(double? value) {
    if (value == null) {
      _json.remove('discountTotal');
    } else {
      _json['discountTotal'] = value;
    }
  }

  bool? get useWallet {
    return _json['useWallet'] as bool?;
  }

  set useWallet(bool? value) {
    if (value == null) {
      _json.remove('useWallet');
    } else {
      _json['useWallet'] = value;
    }
  }

  double? get walletDeduction {
    return (_json['walletDeduction'] as num?)?.toDouble();
  }

  set walletDeduction(double? value) {
    if (value == null) {
      _json.remove('walletDeduction');
    } else {
      _json['walletDeduction'] = value;
    }
  }

  List<OrderProduct> get products {
    return (_json['products'] as List)
        .map((e) => OrderProduct.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  set products(List<OrderProduct> value) {
    _json['products'] = value.map((e) => e.toJson()).toList();
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [OrderCreate] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _OrderCreateTypeFactory extends SchemanticType<OrderCreate> {
  const _OrderCreateTypeFactory();

  @override
  OrderCreate parse(Object? json) {
    return OrderCreate._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'OrderCreate',
    definition: $Schema
        .object(
          properties: {
            'source': $Schema.string(description: 'Order source'),
            'type': $Schema.string(description: 'Order type'),
            'paymentMethod': $Schema.string(
              description: 'Order payment method',
            ),
            'discountTotal': $Schema.number(
              description: 'Discount total',
              minimum: 0,
            ),
            'useWallet': $Schema.boolean(
              description: 'Whether to apply customer wallet balance',
            ),
            'walletDeduction': $Schema.number(
              description: 'Wallet deduction amount in rupees',
              minimum: 0,
            ),
            'products': $Schema.list(
              description: 'Products list',
              items: $Schema.fromMap({'\$ref': r'#/$defs/OrderProduct'}),
            ),
          },
          required: ['products'],
        )
        .value,
    dependencies: [OrderProduct.$schema],
  );
}

base class OrderUpdate {
  /// Creates a [OrderUpdate] from a JSON map.
  factory OrderUpdate.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  OrderUpdate._(this._json);

  OrderUpdate({String? status, String? paymentStatus, String? paymentMethod}) {
    _json = {
      'status': ?status,
      'paymentStatus': ?paymentStatus,
      'paymentMethod': ?paymentMethod,
    };
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [OrderUpdate].
  static const SchemanticType<OrderUpdate> $schema = _OrderUpdateTypeFactory();

  String? get status {
    return _json['status'] as String?;
  }

  set status(String? value) {
    if (value == null) {
      _json.remove('status');
    } else {
      _json['status'] = value;
    }
  }

  String? get paymentStatus {
    return _json['paymentStatus'] as String?;
  }

  set paymentStatus(String? value) {
    if (value == null) {
      _json.remove('paymentStatus');
    } else {
      _json['paymentStatus'] = value;
    }
  }

  String? get paymentMethod {
    return _json['paymentMethod'] as String?;
  }

  set paymentMethod(String? value) {
    if (value == null) {
      _json.remove('paymentMethod');
    } else {
      _json['paymentMethod'] = value;
    }
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [OrderUpdate] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _OrderUpdateTypeFactory extends SchemanticType<OrderUpdate> {
  const _OrderUpdateTypeFactory();

  @override
  OrderUpdate parse(Object? json) {
    return OrderUpdate._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'OrderUpdate',
    definition: $Schema
        .object(
          properties: {
            'status': $Schema.string(description: 'Order status'),
            'paymentStatus': $Schema.string(description: 'Payment status'),
            'paymentMethod': $Schema.string(description: 'Payment method'),
          },
        )
        .value,
    dependencies: [],
  );
}

base class ProductCreate {
  /// Creates a [ProductCreate] from a JSON map.
  factory ProductCreate.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  ProductCreate._(this._json);

  ProductCreate({
    required String name,
    required String categoryId,
    String? counterId,
    required double basePrice,
    required double sellingPrice,
    String? sku,
    String? barcode,
    String? description,
    String? imageUrl,
    double? taxRate,
  }) {
    _json = {
      'name': name,
      'categoryId': categoryId,
      'counterId': ?counterId,
      'basePrice': basePrice,
      'sellingPrice': sellingPrice,
      'sku': ?sku,
      'barcode': ?barcode,
      'description': ?description,
      'imageUrl': ?imageUrl,
      'taxRate': ?taxRate,
    };
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [ProductCreate].
  static const SchemanticType<ProductCreate> $schema =
      _ProductCreateTypeFactory();

  String get name {
    return _json['name'] as String;
  }

  set name(String value) {
    _json['name'] = value;
  }

  String get categoryId {
    return _json['categoryId'] as String;
  }

  set categoryId(String value) {
    _json['categoryId'] = value;
  }

  String? get counterId {
    return _json['counterId'] as String?;
  }

  set counterId(String? value) {
    if (value == null) {
      _json.remove('counterId');
    } else {
      _json['counterId'] = value;
    }
  }

  double get basePrice {
    return (_json['basePrice'] as num).toDouble();
  }

  set basePrice(double value) {
    _json['basePrice'] = value;
  }

  double get sellingPrice {
    return (_json['sellingPrice'] as num).toDouble();
  }

  set sellingPrice(double value) {
    _json['sellingPrice'] = value;
  }

  String? get sku {
    return _json['sku'] as String?;
  }

  set sku(String? value) {
    if (value == null) {
      _json.remove('sku');
    } else {
      _json['sku'] = value;
    }
  }

  String? get barcode {
    return _json['barcode'] as String?;
  }

  set barcode(String? value) {
    if (value == null) {
      _json.remove('barcode');
    } else {
      _json['barcode'] = value;
    }
  }

  String? get description {
    return _json['description'] as String?;
  }

  set description(String? value) {
    if (value == null) {
      _json.remove('description');
    } else {
      _json['description'] = value;
    }
  }

  String? get imageUrl {
    return _json['imageUrl'] as String?;
  }

  set imageUrl(String? value) {
    if (value == null) {
      _json.remove('imageUrl');
    } else {
      _json['imageUrl'] = value;
    }
  }

  double? get taxRate {
    return (_json['taxRate'] as num?)?.toDouble();
  }

  set taxRate(double? value) {
    if (value == null) {
      _json.remove('taxRate');
    } else {
      _json['taxRate'] = value;
    }
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [ProductCreate] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _ProductCreateTypeFactory extends SchemanticType<ProductCreate> {
  const _ProductCreateTypeFactory();

  @override
  ProductCreate parse(Object? json) {
    return ProductCreate._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'ProductCreate',
    definition: $Schema
        .object(
          properties: {
            'name': $Schema.string(
              description: 'Product name',
              minLength: 1,
              maxLength: 255,
            ),
            'categoryId': $Schema.string(
              description: 'Category ID',
              minLength: 1,
            ),
            'counterId': $Schema.string(
              description: 'Counter ID',
              minLength: 1,
            ),
            'basePrice': $Schema.number(description: 'Base price', minimum: 0),
            'sellingPrice': $Schema.number(
              description: 'Selling price',
              minimum: 0,
            ),
            'sku': $Schema.string(description: 'SKU', maxLength: 100),
            'barcode': $Schema.string(description: 'Barcode', maxLength: 100),
            'description': $Schema.string(
              description: 'Product description',
              maxLength: 255,
            ),
            'imageUrl': $Schema.string(
              description: 'Product image URL',
              maxLength: 255,
            ),
            'taxRate': $Schema.number(description: 'Tax rate', minimum: 0),
          },
          required: ['name', 'categoryId', 'basePrice', 'sellingPrice'],
        )
        .value,
    dependencies: [],
  );
}

base class ProductUpdate {
  /// Creates a [ProductUpdate] from a JSON map.
  factory ProductUpdate.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  ProductUpdate._(this._json);

  ProductUpdate({
    String? name,
    String? categoryId,
    String? counterId,
    double? basePrice,
    double? sellingPrice,
    String? sku,
    String? barcode,
    String? description,
    String? imageUrl,
    double? taxRate,
    bool? isActive,
  }) {
    _json = {
      'name': ?name,
      'categoryId': ?categoryId,
      'counterId': ?counterId,
      'basePrice': ?basePrice,
      'sellingPrice': ?sellingPrice,
      'sku': ?sku,
      'barcode': ?barcode,
      'description': ?description,
      'imageUrl': ?imageUrl,
      'taxRate': ?taxRate,
      'isActive': ?isActive,
    };
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [ProductUpdate].
  static const SchemanticType<ProductUpdate> $schema =
      _ProductUpdateTypeFactory();

  String? get name {
    return _json['name'] as String?;
  }

  set name(String? value) {
    if (value == null) {
      _json.remove('name');
    } else {
      _json['name'] = value;
    }
  }

  String? get categoryId {
    return _json['categoryId'] as String?;
  }

  set categoryId(String? value) {
    if (value == null) {
      _json.remove('categoryId');
    } else {
      _json['categoryId'] = value;
    }
  }

  String? get counterId {
    return _json['counterId'] as String?;
  }

  set counterId(String? value) {
    if (value == null) {
      _json.remove('counterId');
    } else {
      _json['counterId'] = value;
    }
  }

  double? get basePrice {
    return (_json['basePrice'] as num?)?.toDouble();
  }

  set basePrice(double? value) {
    if (value == null) {
      _json.remove('basePrice');
    } else {
      _json['basePrice'] = value;
    }
  }

  double? get sellingPrice {
    return (_json['sellingPrice'] as num?)?.toDouble();
  }

  set sellingPrice(double? value) {
    if (value == null) {
      _json.remove('sellingPrice');
    } else {
      _json['sellingPrice'] = value;
    }
  }

  String? get sku {
    return _json['sku'] as String?;
  }

  set sku(String? value) {
    if (value == null) {
      _json.remove('sku');
    } else {
      _json['sku'] = value;
    }
  }

  String? get barcode {
    return _json['barcode'] as String?;
  }

  set barcode(String? value) {
    if (value == null) {
      _json.remove('barcode');
    } else {
      _json['barcode'] = value;
    }
  }

  String? get description {
    return _json['description'] as String?;
  }

  set description(String? value) {
    if (value == null) {
      _json.remove('description');
    } else {
      _json['description'] = value;
    }
  }

  String? get imageUrl {
    return _json['imageUrl'] as String?;
  }

  set imageUrl(String? value) {
    if (value == null) {
      _json.remove('imageUrl');
    } else {
      _json['imageUrl'] = value;
    }
  }

  double? get taxRate {
    return (_json['taxRate'] as num?)?.toDouble();
  }

  set taxRate(double? value) {
    if (value == null) {
      _json.remove('taxRate');
    } else {
      _json['taxRate'] = value;
    }
  }

  bool? get isActive {
    return _json['isActive'] as bool?;
  }

  set isActive(bool? value) {
    if (value == null) {
      _json.remove('isActive');
    } else {
      _json['isActive'] = value;
    }
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [ProductUpdate] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _ProductUpdateTypeFactory extends SchemanticType<ProductUpdate> {
  const _ProductUpdateTypeFactory();

  @override
  ProductUpdate parse(Object? json) {
    return ProductUpdate._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'ProductUpdate',
    definition: $Schema
        .object(
          properties: {
            'name': $Schema.string(
              description: 'Product name',
              minLength: 1,
              maxLength: 255,
            ),
            'categoryId': $Schema.string(
              description: 'Category ID',
              minLength: 1,
            ),
            'counterId': $Schema.string(
              description: 'Counter ID',
              minLength: 1,
            ),
            'basePrice': $Schema.number(description: 'Base price', minimum: 0),
            'sellingPrice': $Schema.number(
              description: 'Selling price',
              minimum: 0,
            ),
            'sku': $Schema.string(description: 'SKU', maxLength: 100),
            'barcode': $Schema.string(description: 'Barcode', maxLength: 100),
            'description': $Schema.string(
              description: 'Product description',
              maxLength: 255,
            ),
            'imageUrl': $Schema.string(
              description: 'Product image URL',
              maxLength: 255,
            ),
            'taxRate': $Schema.number(description: 'Tax rate', minimum: 0),
            'isActive': $Schema.boolean(description: 'Is active status'),
          },
        )
        .value,
    dependencies: [],
  );
}

base class StockCreate {
  /// Creates a [StockCreate] from a JSON map.
  factory StockCreate.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  StockCreate._(this._json);

  StockCreate({
    required String productId,
    required String storeId,
    int? quantity,
    int? lowStockThreshold,
  }) {
    _json = {
      'productId': productId,
      'storeId': storeId,
      'quantity': ?quantity,
      'lowStockThreshold': ?lowStockThreshold,
    };
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [StockCreate].
  static const SchemanticType<StockCreate> $schema = _StockCreateTypeFactory();

  String get productId {
    return _json['productId'] as String;
  }

  set productId(String value) {
    _json['productId'] = value;
  }

  String get storeId {
    return _json['storeId'] as String;
  }

  set storeId(String value) {
    _json['storeId'] = value;
  }

  int? get quantity {
    return _json['quantity'] as int?;
  }

  set quantity(int? value) {
    if (value == null) {
      _json.remove('quantity');
    } else {
      _json['quantity'] = value;
    }
  }

  int? get lowStockThreshold {
    return _json['lowStockThreshold'] as int?;
  }

  set lowStockThreshold(int? value) {
    if (value == null) {
      _json.remove('lowStockThreshold');
    } else {
      _json['lowStockThreshold'] = value;
    }
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [StockCreate] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _StockCreateTypeFactory extends SchemanticType<StockCreate> {
  const _StockCreateTypeFactory();

  @override
  StockCreate parse(Object? json) {
    return StockCreate._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'StockCreate',
    definition: $Schema
        .object(
          properties: {
            'productId': $Schema.string(
              description: 'Product ID',
              minLength: 1,
            ),
            'storeId': $Schema.string(description: 'Store ID', minLength: 1),
            'quantity': $Schema.integer(
              description: 'Stock quantity',
              minimum: 0,
            ),
            'lowStockThreshold': $Schema.integer(
              description: 'Low stock threshold',
              minimum: 0,
            ),
          },
          required: ['productId', 'storeId'],
        )
        .value,
    dependencies: [],
  );
}

base class StockUpdate {
  /// Creates a [StockUpdate] from a JSON map.
  factory StockUpdate.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  StockUpdate._(this._json);

  StockUpdate({int? quantity, int? lowStockThreshold, bool? stockMonitor}) {
    _json = {
      'quantity': ?quantity,
      'lowStockThreshold': ?lowStockThreshold,
      'stockMonitor': ?stockMonitor,
    };
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [StockUpdate].
  static const SchemanticType<StockUpdate> $schema = _StockUpdateTypeFactory();

  int? get quantity {
    return _json['quantity'] as int?;
  }

  set quantity(int? value) {
    if (value == null) {
      _json.remove('quantity');
    } else {
      _json['quantity'] = value;
    }
  }

  int? get lowStockThreshold {
    return _json['lowStockThreshold'] as int?;
  }

  set lowStockThreshold(int? value) {
    if (value == null) {
      _json.remove('lowStockThreshold');
    } else {
      _json['lowStockThreshold'] = value;
    }
  }

  bool? get stockMonitor {
    return _json['stockMonitor'] as bool?;
  }

  set stockMonitor(bool? value) {
    if (value == null) {
      _json.remove('stockMonitor');
    } else {
      _json['stockMonitor'] = value;
    }
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [StockUpdate] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _StockUpdateTypeFactory extends SchemanticType<StockUpdate> {
  const _StockUpdateTypeFactory();

  @override
  StockUpdate parse(Object? json) {
    return StockUpdate._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'StockUpdate',
    definition: $Schema
        .object(
          properties: {
            'quantity': $Schema.integer(
              description: 'Stock quantity',
              minimum: 0,
            ),
            'lowStockThreshold': $Schema.integer(
              description: 'Low stock threshold',
              minimum: 0,
            ),
            'stockMonitor': $Schema.boolean(description: 'Is stock monitored'),
          },
        )
        .value,
    dependencies: [],
  );
}

base class StoreCreate {
  /// Creates a [StoreCreate] from a JSON map.
  factory StoreCreate.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  StoreCreate._(this._json);

  StoreCreate({
    required String name,
    String? storeType,
    bool? isOnlineEnabled,
    String? slug,
  }) {
    _json = {
      'name': name,
      'storeType': ?storeType,
      'isOnlineEnabled': ?isOnlineEnabled,
      'slug': ?slug,
    };
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [StoreCreate].
  static const SchemanticType<StoreCreate> $schema = _StoreCreateTypeFactory();

  String get name {
    return _json['name'] as String;
  }

  set name(String value) {
    _json['name'] = value;
  }

  String? get storeType {
    return _json['storeType'] as String?;
  }

  set storeType(String? value) {
    if (value == null) {
      _json.remove('storeType');
    } else {
      _json['storeType'] = value;
    }
  }

  bool? get isOnlineEnabled {
    return _json['isOnlineEnabled'] as bool?;
  }

  set isOnlineEnabled(bool? value) {
    if (value == null) {
      _json.remove('isOnlineEnabled');
    } else {
      _json['isOnlineEnabled'] = value;
    }
  }

  String? get slug {
    return _json['slug'] as String?;
  }

  set slug(String? value) {
    if (value == null) {
      _json.remove('slug');
    } else {
      _json['slug'] = value;
    }
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [StoreCreate] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _StoreCreateTypeFactory extends SchemanticType<StoreCreate> {
  const _StoreCreateTypeFactory();

  @override
  StoreCreate parse(Object? json) {
    return StoreCreate._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'StoreCreate',
    definition: $Schema
        .object(
          properties: {
            'name': $Schema.string(description: 'Store name', minLength: 1),
            'storeType': $Schema.string(description: 'Store type'),
            'isOnlineEnabled': $Schema.boolean(
              description: 'Is online ordering enabled',
            ),
            'slug': $Schema.string(
              description: 'Store URL slug',
              maxLength: 255,
              pattern: r'^[a-z0-9]+(?:-[a-z0-9]+)*$',
            ),
          },
          required: ['name'],
        )
        .value,
    dependencies: [],
  );
}

base class StoreUpdate {
  /// Creates a [StoreUpdate] from a JSON map.
  factory StoreUpdate.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  StoreUpdate._(this._json);

  StoreUpdate({
    String? name,
    String? storeType,
    bool? isActive,
    bool? isOnlineEnabled,
    String? slug,
  }) {
    _json = {
      'name': ?name,
      'storeType': ?storeType,
      'isActive': ?isActive,
      'isOnlineEnabled': ?isOnlineEnabled,
      'slug': ?slug,
    };
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [StoreUpdate].
  static const SchemanticType<StoreUpdate> $schema = _StoreUpdateTypeFactory();

  String? get name {
    return _json['name'] as String?;
  }

  set name(String? value) {
    if (value == null) {
      _json.remove('name');
    } else {
      _json['name'] = value;
    }
  }

  String? get storeType {
    return _json['storeType'] as String?;
  }

  set storeType(String? value) {
    if (value == null) {
      _json.remove('storeType');
    } else {
      _json['storeType'] = value;
    }
  }

  bool? get isActive {
    return _json['isActive'] as bool?;
  }

  set isActive(bool? value) {
    if (value == null) {
      _json.remove('isActive');
    } else {
      _json['isActive'] = value;
    }
  }

  bool? get isOnlineEnabled {
    return _json['isOnlineEnabled'] as bool?;
  }

  set isOnlineEnabled(bool? value) {
    if (value == null) {
      _json.remove('isOnlineEnabled');
    } else {
      _json['isOnlineEnabled'] = value;
    }
  }

  String? get slug {
    return _json['slug'] as String?;
  }

  set slug(String? value) {
    if (value == null) {
      _json.remove('slug');
    } else {
      _json['slug'] = value;
    }
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [StoreUpdate] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _StoreUpdateTypeFactory extends SchemanticType<StoreUpdate> {
  const _StoreUpdateTypeFactory();

  @override
  StoreUpdate parse(Object? json) {
    return StoreUpdate._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'StoreUpdate',
    definition: $Schema
        .object(
          properties: {
            'name': $Schema.string(description: 'Store name', minLength: 1),
            'storeType': $Schema.string(description: 'Store type'),
            'isActive': $Schema.boolean(description: 'Is active status'),
            'isOnlineEnabled': $Schema.boolean(
              description: 'Is online ordering enabled',
            ),
            'slug': $Schema.string(
              description: 'Store URL slug',
              maxLength: 255,
              pattern: r'^[a-z0-9]+(?:-[a-z0-9]+)*$',
            ),
          },
        )
        .value,
    dependencies: [],
  );
}

base class StorePhonePeConfigUpdate {
  /// Creates a [StorePhonePeConfigUpdate] from a JSON map.
  factory StorePhonePeConfigUpdate.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  StorePhonePeConfigUpdate._(this._json);

  StorePhonePeConfigUpdate({
    required String clientId,
    required String clientSecret,
    bool? isEnabled,
  }) {
    _json = {
      'clientId': clientId,
      'clientSecret': clientSecret,
      'isEnabled': ?isEnabled,
    };
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [StorePhonePeConfigUpdate].
  static const SchemanticType<StorePhonePeConfigUpdate> $schema =
      _StorePhonePeConfigUpdateTypeFactory();

  String get clientId {
    return _json['clientId'] as String;
  }

  set clientId(String value) {
    _json['clientId'] = value;
  }

  String get clientSecret {
    return _json['clientSecret'] as String;
  }

  set clientSecret(String value) {
    _json['clientSecret'] = value;
  }

  bool? get isEnabled {
    return _json['isEnabled'] as bool?;
  }

  set isEnabled(bool? value) {
    if (value == null) {
      _json.remove('isEnabled');
    } else {
      _json['isEnabled'] = value;
    }
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [StorePhonePeConfigUpdate] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _StorePhonePeConfigUpdateTypeFactory
    extends SchemanticType<StorePhonePeConfigUpdate> {
  const _StorePhonePeConfigUpdateTypeFactory();

  @override
  StorePhonePeConfigUpdate parse(Object? json) {
    return StorePhonePeConfigUpdate._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'StorePhonePeConfigUpdate',
    definition: $Schema
        .object(
          properties: {
            'clientId': $Schema.string(
              description: 'PhonePe Client ID',
              minLength: 1,
            ),
            'clientSecret': $Schema.string(
              description: 'PhonePe Client Secret',
              minLength: 1,
            ),
            'isEnabled': $Schema.boolean(description: 'Is enabled'),
          },
          required: ['clientId', 'clientSecret'],
        )
        .value,
    dependencies: [],
  );
}

base class StoreSubscriptionInitiate {
  /// Creates a [StoreSubscriptionInitiate] from a JSON map.
  factory StoreSubscriptionInitiate.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  StoreSubscriptionInitiate._(this._json);

  StoreSubscriptionInitiate({required String planCode}) {
    _json = {'planCode': planCode};
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [StoreSubscriptionInitiate].
  static const SchemanticType<StoreSubscriptionInitiate> $schema =
      _StoreSubscriptionInitiateTypeFactory();

  String get planCode {
    return _json['planCode'] as String;
  }

  set planCode(String value) {
    _json['planCode'] = value;
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [StoreSubscriptionInitiate] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _StoreSubscriptionInitiateTypeFactory
    extends SchemanticType<StoreSubscriptionInitiate> {
  const _StoreSubscriptionInitiateTypeFactory();

  @override
  StoreSubscriptionInitiate parse(Object? json) {
    return StoreSubscriptionInitiate._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'StoreSubscriptionInitiate',
    definition: $Schema
        .object(
          properties: {
            'planCode': $Schema.string(description: 'Plan code', minLength: 1),
          },
          required: ['planCode'],
        )
        .value,
    dependencies: [],
  );
}

base class StoreSubscriptionVerify {
  /// Creates a [StoreSubscriptionVerify] from a JSON map.
  factory StoreSubscriptionVerify.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  StoreSubscriptionVerify._(this._json);

  StoreSubscriptionVerify({required String merchantTransactionId}) {
    _json = {'merchantTransactionId': merchantTransactionId};
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [StoreSubscriptionVerify].
  static const SchemanticType<StoreSubscriptionVerify> $schema =
      _StoreSubscriptionVerifyTypeFactory();

  String get merchantTransactionId {
    return _json['merchantTransactionId'] as String;
  }

  set merchantTransactionId(String value) {
    _json['merchantTransactionId'] = value;
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [StoreSubscriptionVerify] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _StoreSubscriptionVerifyTypeFactory
    extends SchemanticType<StoreSubscriptionVerify> {
  const _StoreSubscriptionVerifyTypeFactory();

  @override
  StoreSubscriptionVerify parse(Object? json) {
    return StoreSubscriptionVerify._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'StoreSubscriptionVerify',
    definition: $Schema
        .object(
          properties: {
            'merchantTransactionId': $Schema.string(
              description: 'Merchant transaction ID',
              minLength: 1,
            ),
          },
          required: ['merchantTransactionId'],
        )
        .value,
    dependencies: [],
  );
}

base class StoreSubscriptionRenew {
  /// Creates a [StoreSubscriptionRenew] from a JSON map.
  factory StoreSubscriptionRenew.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  StoreSubscriptionRenew._(this._json);

  StoreSubscriptionRenew({
    required String planCode,
    String? paymentMethod,
    String? reference,
  }) {
    _json = {
      'planCode': planCode,
      'paymentMethod': ?paymentMethod,
      'reference': ?reference,
    };
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [StoreSubscriptionRenew].
  static const SchemanticType<StoreSubscriptionRenew> $schema =
      _StoreSubscriptionRenewTypeFactory();

  String get planCode {
    return _json['planCode'] as String;
  }

  set planCode(String value) {
    _json['planCode'] = value;
  }

  String? get paymentMethod {
    return _json['paymentMethod'] as String?;
  }

  set paymentMethod(String? value) {
    if (value == null) {
      _json.remove('paymentMethod');
    } else {
      _json['paymentMethod'] = value;
    }
  }

  String? get reference {
    return _json['reference'] as String?;
  }

  set reference(String? value) {
    if (value == null) {
      _json.remove('reference');
    } else {
      _json['reference'] = value;
    }
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [StoreSubscriptionRenew] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _StoreSubscriptionRenewTypeFactory
    extends SchemanticType<StoreSubscriptionRenew> {
  const _StoreSubscriptionRenewTypeFactory();

  @override
  StoreSubscriptionRenew parse(Object? json) {
    return StoreSubscriptionRenew._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'StoreSubscriptionRenew',
    definition: $Schema
        .object(
          properties: {
            'planCode': $Schema.string(description: 'Plan code', minLength: 1),
            'paymentMethod': $Schema.string(description: 'Payment method'),
            'reference': $Schema.string(description: 'Payment reference'),
          },
          required: ['planCode'],
        )
        .value,
    dependencies: [],
  );
}

base class TerminalCreate {
  /// Creates a [TerminalCreate] from a JSON map.
  factory TerminalCreate.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  TerminalCreate._(this._json);

  TerminalCreate({required String name, required String password}) {
    _json = {'name': name, 'password': password};
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [TerminalCreate].
  static const SchemanticType<TerminalCreate> $schema =
      _TerminalCreateTypeFactory();

  String get name {
    return _json['name'] as String;
  }

  set name(String value) {
    _json['name'] = value;
  }

  String get password {
    return _json['password'] as String;
  }

  set password(String value) {
    _json['password'] = value;
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [TerminalCreate] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _TerminalCreateTypeFactory extends SchemanticType<TerminalCreate> {
  const _TerminalCreateTypeFactory();

  @override
  TerminalCreate parse(Object? json) {
    return TerminalCreate._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'TerminalCreate',
    definition: $Schema
        .object(
          properties: {
            'name': $Schema.string(description: 'Terminal name', minLength: 1),
            'password': $Schema.string(
              description: 'Terminal password',
              minLength: 6,
              pattern: r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,}$',
            ),
          },
          required: ['name', 'password'],
        )
        .value,
    dependencies: [],
  );
}

base class TerminalLogin {
  /// Creates a [TerminalLogin] from a JSON map.
  factory TerminalLogin.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  TerminalLogin._(this._json);

  TerminalLogin({required String code, required String password}) {
    _json = {'code': code, 'password': password};
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [TerminalLogin].
  static const SchemanticType<TerminalLogin> $schema =
      _TerminalLoginTypeFactory();

  String get code {
    return _json['code'] as String;
  }

  set code(String value) {
    _json['code'] = value;
  }

  String get password {
    return _json['password'] as String;
  }

  set password(String value) {
    _json['password'] = value;
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [TerminalLogin] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _TerminalLoginTypeFactory extends SchemanticType<TerminalLogin> {
  const _TerminalLoginTypeFactory();

  @override
  TerminalLogin parse(Object? json) {
    return TerminalLogin._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'TerminalLogin',
    definition: $Schema
        .object(
          properties: {
            'code': $Schema.string(
              description: 'Terminal code',
              minLength: 12,
              maxLength: 12,
            ),
            'password': $Schema.string(
              description: 'Terminal password',
              minLength: 6,
              pattern: r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,}$',
            ),
          },
          required: ['code', 'password'],
        )
        .value,
    dependencies: [],
  );
}

base class TerminalUpdate {
  /// Creates a [TerminalUpdate] from a JSON map.
  factory TerminalUpdate.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  TerminalUpdate._(this._json);

  TerminalUpdate({String? name, String? password, bool? isActive}) {
    _json = {'name': ?name, 'password': ?password, 'isActive': ?isActive};
  }

  late final Map<String, dynamic> _json;

  /// The JSON schema and type descriptor for [TerminalUpdate].
  static const SchemanticType<TerminalUpdate> $schema =
      _TerminalUpdateTypeFactory();

  String? get name {
    return _json['name'] as String?;
  }

  set name(String? value) {
    if (value == null) {
      _json.remove('name');
    } else {
      _json['name'] = value;
    }
  }

  String? get password {
    return _json['password'] as String?;
  }

  set password(String? value) {
    if (value == null) {
      _json.remove('password');
    } else {
      _json['password'] = value;
    }
  }

  bool? get isActive {
    return _json['isActive'] as bool?;
  }

  set isActive(bool? value) {
    if (value == null) {
      _json.remove('isActive');
    } else {
      _json['isActive'] = value;
    }
  }

  @override
  String toString() {
    return _json.toString();
  }

  /// Serializes this [TerminalUpdate] to a JSON map.
  Map<String, dynamic> toJson() {
    return _json;
  }
}

base class _TerminalUpdateTypeFactory extends SchemanticType<TerminalUpdate> {
  const _TerminalUpdateTypeFactory();

  @override
  TerminalUpdate parse(Object? json) {
    return TerminalUpdate._(json as Map<String, dynamic>);
  }

  @override
  JsonSchemaMetadata get schemaMetadata => JsonSchemaMetadata(
    name: 'TerminalUpdate',
    definition: $Schema
        .object(
          properties: {
            'name': $Schema.string(description: 'Terminal name', minLength: 1),
            'password': $Schema.string(
              description: 'Terminal password',
              minLength: 6,
              pattern: r'^(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,}$',
            ),
            'isActive': $Schema.boolean(description: 'Is active status'),
          },
        )
        .value,
    dependencies: [],
  );
}
