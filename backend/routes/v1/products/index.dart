import 'dart:io';

import 'package:backend/extensions/product_row_extension.dart';
import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/repositories/product_repository.dart';
import 'package:backend/services/product_service.dart';
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
  final storeIdError = context.validateStoreId();
  if (storeIdError != null) return storeIdError;

  final (pageError, page) = context.parsePage();
  if (pageError != null) return pageError;

  final (sizeError, size) = context.parseSize();
  if (sizeError != null) return sizeError;

  final repo = context.read<ProductRepository>();
  final tokenPayload = context.tokenPayload;

  try {
    final total = await repo.count(
      storeId: context.storeId,
      merchantId: tokenPayload.sub,
    );

    final offset = (page - 1) * size;
    final productRows = await repo.getAll(
      storeId: context.storeId,
      merchantId: tokenPayload.sub,
      limit: size,
      offset: offset,
    );

    final products = productRows.map((r) => r.toProduct()).toList();
    final totalPages = (total / size).ceil();

    return success(
      data: {
        'currentPage': page,
        'pageSize': size,
        'totalItems': total,
        'totalPages': totalPages,
        'products': products,
      },
    );
  } catch (e) {
    return error(message: e.toString());
  }
}

Future<Response> _onPost(RequestContext context) async {
  final storeIdError = context.validateStoreId();
  if (storeIdError != null) return storeIdError;

  try {
    final body = await context.validateBody(ProductValidator.create);
    final productService = context.read<ProductService>();
    final tokenPayload = context.tokenPayload;

    final completeProduct = await productService.create(
      merchantId: tokenPayload.sub,
      storeId: context.storeId,
      body: body,
    );

    return success(
      statusCode: HttpStatus.created,
      data: {
        'product': completeProduct,
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
