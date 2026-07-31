// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'schemas.dart';

// **************************************************************************
// SchemaGenerator
// **************************************************************************

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
              pattern: r'(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,}',
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
              pattern: r'(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,}',
            ),
          },
          required: ['email', 'password'],
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
    required String counterId,
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
      'counterId': counterId,
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

  String get counterId {
    return _json['counterId'] as String;
  }

  set counterId(String value) {
    _json['counterId'] = value;
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
          required: [
            'name',
            'categoryId',
            'counterId',
            'basePrice',
            'sellingPrice',
          ],
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

base class OrderProduct {
  /// Creates a [OrderProduct] from a JSON map.
  factory OrderProduct.fromJson(Map<String, dynamic> json) =>
      $schema.parse(json);

  OrderProduct._(this._json);

  OrderProduct({required String productId, required int quantity}) {
    _json = {'productId': productId, 'quantity': quantity};
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
    required List<OrderProduct> products,
  }) {
    _json = {
      'source': ?source,
      'type': ?type,
      'paymentMethod': ?paymentMethod,
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

  List<OrderProduct> get products {
    return (_json['products'] as List)
        .map((e) => OrderProduct.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  set products(List<OrderProduct> value) {
    _json['products'] = value.toList();
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

  StoreCreate({required String name, String? storeType}) {
    _json = {'name': name, 'storeType': ?storeType};
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

  StoreUpdate({String? name, String? storeType, bool? isActive}) {
    _json = {'name': ?name, 'storeType': ?storeType, 'isActive': ?isActive};
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
          },
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
              pattern: r'(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,}',
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
              pattern: r'(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,}',
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
              pattern: r'(?=.*\d)(?=.*[a-z])(?=.*[A-Z]).{6,}',
            ),
            'isActive': $Schema.boolean(description: 'Is active status'),
          },
        )
        .value,
    dependencies: [],
  );
}
