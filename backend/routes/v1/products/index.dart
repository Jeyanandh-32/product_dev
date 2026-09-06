import 'dart:io';

import 'package:backend/enums/user_role.dart';
import 'package:backend/extensions/product_row_extension.dart';
import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/utils/constraint_errors.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:validators/validators.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    .get => _onGet(context),
    .post => _onPost(context),
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

  final repo = context.productRepo;
  final tokenPayload = context.optionalTokenPayload;

  try {
    final searchQuery = context.request.uri.queryParameters['search'];
    final isCustomerOrPublic =
        tokenPayload == null || tokenPayload.role == UserRole.customer;
    final activeParam = context.request.uri.queryParameters['isActive']
        ?.toLowerCase();
    final isActive = switch (activeParam) {
      'true' => true,
      'false' => isCustomerOrPublic,
      'all' => isCustomerOrPublic ? true : null,
      _ => isCustomerOrPublic ? true : null,
    };

    final merchantId = isCustomerOrPublic ? null : tokenPayload.sub;
    final offset = (page - 1) * size;

    final totalFuture = repo.count(
      storeId: context.storeId,
      merchantId: merchantId,
      searchQuery: searchQuery,
      isActive: isActive,
    );
    final productRowsFuture = repo.getAll(
      storeId: context.storeId,
      merchantId: merchantId,
      searchQuery: searchQuery,
      isActive: isActive,
      limit: size,
      offset: offset,
    );

    final (total, productRows) = await (totalFuture, productRowsFuture).wait;

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
    final input = ProductCreate.fromJson(body);
    final productService = context.productService;
    final tokenPayload = context.tokenPayload;

    final completeProduct = await productService.create(
      merchantId: tokenPayload.sub,
      storeId: context.storeId,
      body: {
        'name': input.name,
        'categoryId': input.categoryId,
        'counterId': input.counterId,
        'basePrice': input.basePrice,
        'sellingPrice': input.sellingPrice,
        'sku': input.sku,
        'barcode': input.barcode,
        'description': input.description,
        'imageUrl': input.imageUrl,
        'taxRate': input.taxRate,
      },
    );

    return success(
      statusCode: HttpStatus.created,
      data: {'product': completeProduct},
    );
  } on ResponseException catch (e) {
    return e.response;
  } catch (e) {
    return tryConstraintError(e) ?? error(message: e.toString());
  }
}
