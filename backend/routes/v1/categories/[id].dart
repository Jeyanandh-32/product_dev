import 'package:backend/extensions/category_row_extension.dart';
import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/repositories/category_repository.dart';
import 'package:backend/utils/request_body.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:validators/validators.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  if (!id.isUUID()) {
    return badRequest(message: 'Invalid category id.');
  }

  return switch (context.request.method) {
    HttpMethod.get => _onGet(context, id),
    HttpMethod.put || HttpMethod.patch => _onPutOrPatch(context, id),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onGet(RequestContext context, String id) async {
  final repo = context.read<CategoryRepository>();

  try {
    final categoryRow = await repo.getById(id);

    return success(
      data: {
        'category': categoryRow?.toCategory(),
      },
    );
  } catch (e) {
    return error(message: e.toString());
  }
}

Future<Response> _onPutOrPatch(RequestContext context, String id) async {
  final repo = context.read<CategoryRepository>();

  try {
    final body = await context.validateBody(CategoryValidator.update);

    final categoryRow = await repo.update(
      id: id,
      name: (body['name'] as String?)?.trim(),
      isActive: body['isActive'] as bool?,
      description: readOptionalString(body, 'description'),
      descriptionPresent: body.containsKey('description'),
      imageUrl: readOptionalString(body, 'imageUrl'),
      imageUrlPresent: body.containsKey('imageUrl'),
    );

    return success(
      data: {
        'category': categoryRow?.toCategory(),
      },
    );
  } on ResponseException catch (e) {
    return e.response;
  } catch (e) {
    if (e.toString().contains('unique_store_category_name')) {
      return badRequest(
        message: 'You already have a category with this name in this store.',
      );
    }
    return error(message: e.toString());
  }
}
