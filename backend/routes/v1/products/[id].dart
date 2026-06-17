import 'dart:io';

import 'package:backend/extensions/product_dto_extension.dart';
import 'package:backend/repositories/product_repository.dart';
import 'package:backend/utils/request_body.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:validators/validators.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  if (!id.isUUID()) {
    return badRequest(message: 'Invalid product id.');
  }

  return switch (context.request.method) {
    HttpMethod.get => _onGet(context, id),
    HttpMethod.put || HttpMethod.patch => _onPutOrPatch(context, id),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onGet(RequestContext context, String id) async {
  final repo = context.read<ProductRepository>();

  try {
    final productDto = await repo.getById(id);
    if (productDto == null) {
      return error(message: 'Product not found.', statusCode: HttpStatus.notFound);
    }

    return success(
      data: {
        'product': productDto.toProduct(),
      },
    );
  } catch (e) {
    return error(message: e.toString());
  }
}

Future<Response> _onPutOrPatch(RequestContext context, String id) async {
  final repo = context.read<ProductRepository>();

  final jsonBody = await context.request.json();
  if (jsonBody is! Map<String, Object?>) return inValidBody();

  final body = jsonBody;

  // Validate value types
  if (hasNonStringValue(body, 'name') ||
      hasNonStringValue(body, 'categoryId') ||
      hasNonStringValue(body, 'counterId') ||
      hasNonStringValue(body, 'sku') ||
      hasNonStringValue(body, 'barcode') ||
      hasNonStringValue(body, 'description') ||
      hasNonStringValue(body, 'imageUrl') ||
      hasNonBoolValue(body, 'isActive')) {
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
  final isActive = body['isActive'] as bool?;
  final basePrice = basePriceVal as int?;
  final sellingPrice = sellingPriceVal as int?;
  final sku = readOptionalString(body, 'sku');
  final barcode = readOptionalString(body, 'barcode');
  final description = readOptionalString(body, 'description');
  final imageUrl = readOptionalString(body, 'imageUrl');
  final taxRate = (taxRateVal as num?)?.toDouble();

  final namePresent = body.containsKey('name');
  final categoryIdPresent = body.containsKey('categoryId');
  final counterIdPresent = body.containsKey('counterId');
  final isActivePresent = body.containsKey('isActive');
  final basePricePresent = body.containsKey('basePrice');
  final sellingPricePresent = body.containsKey('sellingPrice');
  final skuPresent = body.containsKey('sku');
  final barcodePresent = body.containsKey('barcode');
  final descriptionPresent = body.containsKey('description');
  final imageUrlPresent = body.containsKey('imageUrl');
  final taxRatePresent = body.containsKey('taxRate');

  final errorMessage = ProductValidator.update(
    name: name,
    sku: sku,
    barcode: barcode,
    description: description,
    imageUrl: imageUrl,
    taxRate: taxRate,
    basePrice: basePrice,
    sellingPrice: sellingPrice,
    isActive: isActive,
    categoryId: categoryId,
    counterId: counterId,
    namePresent: namePresent,
    skuPresent: skuPresent,
    barcodePresent: barcodePresent,
    descriptionPresent: descriptionPresent,
    imageUrlPresent: imageUrlPresent,
    taxRatePresent: taxRatePresent,
    basePricePresent: basePricePresent,
    sellingPricePresent: sellingPricePresent,
    isActivePresent: isActivePresent,
    categoryIdPresent: categoryIdPresent,
    counterIdPresent: counterIdPresent,
  );

  if (errorMessage != null) {
    return badRequest(message: errorMessage);
  }

  try {
    final updatedDto = await repo.update(
      id: id,
      name: name?.trim(),
      categoryId: categoryId,
      counterId: counterId,
      isActive: isActive,
      basePrice: basePrice,
      sellingPrice: sellingPrice,
      taxRate: taxRate,
      sku: sku,
      barcode: barcode,
      description: description,
      imageUrl: imageUrl,
      skuPresent: skuPresent,
      barcodePresent: barcodePresent,
      descriptionPresent: descriptionPresent,
      imageUrlPresent: imageUrlPresent,
    );

    if (updatedDto == null) {
      return error(message: 'Product not found.', statusCode: HttpStatus.notFound);
    }

    // Fetch the product with fully joined stock details after updating
    final completeProduct = await repo.getById(id);

    return success(
      data: {
        'product': completeProduct?.toProduct(),
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
