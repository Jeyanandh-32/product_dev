import 'dart:io';

import 'package:backend/extensions/product_row_extension.dart';
import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/repositories/product_repository.dart';
import 'package:backend/utils/constraint_errors.dart';
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
    .get => _onGet(context, id),
    .put || .patch => _onPutOrPatch(context, id),
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
    final input = ProductUpdate.fromJson(body);
    final basePrice = input.basePrice;
    final sellingPrice = input.sellingPrice;

    final updatedRow = await repo.update(
      id: id,
      name: input.name?.trim(),
      categoryId: input.categoryId,
      counterId: input.counterId,
      isActive: input.isActive,
      basePrice: basePrice != null ? (basePrice * 100).round() : null,
      sellingPrice: sellingPrice != null ? (sellingPrice * 100).round() : null,
      taxRate: input.taxRate,
      sku: input.sku?.trim().toUpperCase(),
      barcode: input.barcode?.trim().toUpperCase(),
      description: input.description,
      imageUrl: input.imageUrl,
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
    return tryConstraintError(e) ?? error(message: e.toString());
  }
}
