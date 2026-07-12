import 'dart:io';

import 'package:backend/extensions/product_row_extension.dart';
import 'package:backend/extensions/request_context_extension.dart';
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
    final productRow = await repo.getById(id);
    if (productRow == null) {
      return error(
        message: 'Product not found.',
        statusCode: HttpStatus.notFound,
      );
    }

    return success(
      data: {
        'product': productRow.toProduct(),
      },
    );
  } catch (e) {
    return error(message: e.toString());
  }
}

Future<Response> _onPutOrPatch(RequestContext context, String id) async {
  final repo = context.read<ProductRepository>();

  try {
    final body = await context.validateBody(ProductValidator.update);

    final name = body['name'] as String?;
    final categoryId = body['categoryId'] as String?;
    final counterId = body['counterId'] as String?;
    final isActive = body['isActive'] as bool?;
    final basePrice = body['basePrice'] as int?;
    final sellingPrice = body['sellingPrice'] as int?;
    final sku = readOptionalString(body, 'sku');
    final barcode = readOptionalString(body, 'barcode');
    final description = readOptionalString(body, 'description');
    final imageUrl = readOptionalString(body, 'imageUrl');
    final taxRate = (body['taxRate'] as num?)?.toDouble();

    final updatedRow = await repo.update(
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
      skuPresent: body.containsKey('sku'),
      barcodePresent: body.containsKey('barcode'),
      descriptionPresent: body.containsKey('description'),
      imageUrlPresent: body.containsKey('imageUrl'),
    );

    if (updatedRow == null) {
      return error(
        message: 'Product not found.',
        statusCode: HttpStatus.notFound,
      );
    }

    final completeProductRow = await repo.getById(id);
    if (completeProductRow == null) {
      return error(
        message: 'Product not found.',
        statusCode: HttpStatus.notFound,
      );
    }

    return success(
      data: {
        'product': completeProductRow.toProduct(),
      },
    );
  } on ResponseException catch (e) {
    return e.response;
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
