import 'package:backend/extensions/category_row_extension.dart';
import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/utils/constraint_errors.dart';
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
    .get => _onGet(context, id),
    .put || .patch => _onPutOrPatch(context, id),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onGet(RequestContext context, String id) async {
  final repo = context.categoryRepo;

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
  final repo = context.categoryRepo;

  try {
    final body = await context.validateBody(CategoryValidator.update);
    final input = CategoryUpdate.fromJson(body);

    final categoryRow = await repo.update(
      id: id,
      name: input.name?.trim(),
      isActive: input.isActive,
      description: input.description,
      descriptionPresent: body.containsKey('description'),
      imageUrl: input.imageUrl,
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
    return tryConstraintError(e) ?? error(message: e.toString());
  }
}
