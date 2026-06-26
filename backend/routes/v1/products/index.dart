import 'dart:io';

import 'package:backend/config/database.dart';
import 'package:backend/extensions/product_dto_extension.dart';
import 'package:backend/models/token_payload/token_payload.dart';
import 'package:backend/repositories/product_repository.dart';
import 'package:backend/repositories/stock_repository.dart';
import 'package:backend/utils/request_body.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:validators/validators.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _onGet(context),
    HttpMethod.post => _onPost(context),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onGet(RequestContext context) async {
  final parameters = context.request.uri.queryParameters;
  final storeId = parameters['storeId'];

  if (storeId == null || storeId.isEmpty) {
    return badRequest(message: 'Store ID is required.');
  }
  if (!storeId.isUUID()) {
    return badRequest(message: 'Invalid store id.');
  }

  final limitStr = parameters['limit'];
  final offsetStr = parameters['offset'];

  int? limit;
  if (limitStr != null && limitStr.isNotEmpty) {
    limit = int.tryParse(limitStr);
    if (limit == null || limit <= 0) {
      return badRequest(message: 'limit must be a positive integer.');
    }
  }

  int? offset;
  if (offsetStr != null && offsetStr.isNotEmpty) {
    offset = int.tryParse(offsetStr);
    if (offset == null || offset < 0) {
      return badRequest(message: 'offset must be a non-negative integer.');
    }
  }

  final repo = context.read<ProductRepository>();
  final tokenPayload = context.read<TokenPayload>();
  final merchantId = tokenPayload.sub;

  try {
    final total = await repo.count(
      storeId: storeId,
      merchantId: merchantId,
    );

    final productDtos = await repo.getAll(
      storeId: storeId,
      merchantId: merchantId,
      limit: limit,
      offset: offset,
    );

    final products = productDtos.map((s) => s.toProduct()).toList();

    return success(
      data: {
        'products': products,
        'total': total,
      },
    );
  } catch (e) {
    return error(message: e.toString());
  }
}

Future<Response> _onPost(RequestContext context) async {
  final parameters = context.request.uri.queryParameters;
  final storeId = parameters['storeId'];

  if (storeId == null || storeId.isEmpty) {
    return badRequest(message: 'Store ID is required.');
  }
  if (!storeId.isUUID()) {
    return badRequest(message: 'Invalid store id.');
  }

  final tokenPayload = context.read<TokenPayload>();
  final merchantId = tokenPayload.sub;

  final jsonBody = await context.request.json();
  if (jsonBody is! Map<String, Object?>) return inValidBody();

  final body = jsonBody;

  if (hasNonStringValue(body, 'name') ||
      hasNonStringValue(body, 'categoryId') ||
      hasNonStringValue(body, 'counterId') ||
      hasNonStringValue(body, 'sku') ||
      hasNonStringValue(body, 'barcode') ||
      hasNonStringValue(body, 'description') ||
      hasNonStringValue(body, 'imageUrl')) {
    return inValidBody();
  }

  final basePriceVal = body['basePrice'];
  if (basePriceVal != null && basePriceVal is! int) {
    return badRequest(message: 'basePrice must be an integer.');
  }

  final sellingPriceVal = body['sellingPrice'];
  if (sellingPriceVal != null && sellingPriceVal is! int) {
    return badRequest(message: 'sellingPrice must be an integer.');
  }

  final taxRateVal = body['taxRate'];
  if (taxRateVal != null && taxRateVal is! num) {
    return badRequest(message: 'taxRate must be a number.');
  }

  final name = body['name'] as String?;
  final categoryId = body['categoryId'] as String?;
  final counterId = body['counterId'] as String?;
  final basePrice = basePriceVal as int?;
  final sellingPrice = sellingPriceVal as int?;
  final sku = readOptionalString(body, 'sku');
  final barcode = readOptionalString(body, 'barcode');
  final description = readOptionalString(body, 'description');
  final imageUrl = readOptionalString(body, 'imageUrl');
  final taxRate = (taxRateVal as num?)?.toDouble() ?? 0.0;

  final errorMessage = ProductValidator.create(
    name: name,
    categoryId: categoryId,
    counterId: counterId,
    basePrice: basePrice,
    sellingPrice: sellingPrice,
    sku: sku,
    barcode: barcode,
    description: description,
    imageUrl: imageUrl,
    taxRate: taxRate,
  );

  if (errorMessage != null) {
    return badRequest(message: errorMessage);
  }

  try {
    final completeProduct = await Database.pool.runTx((session) async {
      final txProductRepo = ProductRepository(session: session);
      final txStockRepo = StockRepository(session: session);

      final productDto = await txProductRepo.create(
        merchantId: merchantId,
        storeId: storeId,
        name: name!.trim(),
        categoryId: categoryId!,
        counterId: counterId!,
        basePrice: basePrice!,
        sellingPrice: sellingPrice!,
        sku: sku,
        barcode: barcode,
        description: description,
        imageUrl: imageUrl,
        taxRate: taxRate,
      );

      final stockDto = await txStockRepo.create(
        productId: productDto.id,
        storeId: storeId,
      );

      return productDto.copyWith(stock: stockDto);
    });

    return success(
      statusCode: HttpStatus.created,
      data: {
        'product': completeProduct.toProduct(),
      },
    );
  } catch (e) {
    if (e.toString().contains('unique_merchant_product_sku')) {
      return badRequest(message: 'You already have a product with this SKU.');
    }
    if (e.toString().contains('unique_store_product_name')) {
      return badRequest(
        message: 'You already have a product with this name in this store.',
      );
    }
    return error(message: e.toString());
  }
}
