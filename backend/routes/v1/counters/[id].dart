import 'package:backend/extensions/counter_dto_extension.dart';
import 'package:backend/repositories/counter_repository.dart';
import 'package:backend/utils/request_body.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:validators/validators.dart';

Future<Response> onRequest(
  RequestContext context,
  String id,
) async {
  if (!id.isUUID()) {
    return badRequest(message: 'Invalid counter id.');
  }

  return switch (context.request.method) {
    .get => _onGet(context, id),
    .put || .patch => _onPutOrPatch(context, id),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onGet(RequestContext context, String id) async {
  final repo = context.read<CounterRepository>();

  try {
    final counterDto = await repo.getById(id);

    return success(
      data: {
        'counter': counterDto?.toCounter(),
      },
    );
  } catch (e) {
    return error(message: e.toString());
  }
}

Future<Response> _onPutOrPatch(RequestContext context, String id) async {
  final repo = context.read<CounterRepository>();

  final jsonBody = await context.request.json();

  if (jsonBody is! Map<String, Object?>) return inValidBody();

  final body = jsonBody;

  final name = body['name'] as String?;
  final isActive = body['isActive'] as bool?;
  final description = readOptionalString(body, 'description');
  final imageUrl = readOptionalString(body, 'imageUrl');

  final namePresent = body.containsKey('name');
  final isActivePresent = body.containsKey('isActive');
  final descriptionPresent = body.containsKey('description');
  final imageUrlPresent = body.containsKey('imageUrl');

  final errorMessage = CounterValidator.update(
    name: name,
    isActive: isActive,
    description: description,
    imageUrl: imageUrl,
    namePresent: namePresent,
    isActivePresent: isActivePresent,
    descriptionPresent: descriptionPresent,
    imageUrlPresent: imageUrlPresent,
  );

  if (errorMessage != null) {
    return badRequest(message: errorMessage);
  }

  try {
    final counterDto = await repo.update(
      id: id,
      name: name?.trim(),
      isActive: isActive,
      description: description,
      descriptionPresent: descriptionPresent,
      imageUrl: imageUrl,
      imageUrlPresent: imageUrlPresent,
    );

    return success(
      data: {
        'counter': counterDto?.toCounter(),
      },
    );
  } catch (e) {
    if (e.toString().contains('unique_store_counter_name')) {
      return badRequest(
        message: 'You already have a counter with this name in this store.',
      );
    }
    return error(message: e.toString());
  }
}
