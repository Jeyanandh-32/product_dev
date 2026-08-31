import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/extensions/store_row_extension.dart';
import 'package:backend/repositories/customer_repository.dart';
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
  final repo = context.read<CustomerRepository>();
  final tokenPayload = context.tokenPayload;

  try {
    final stores = await repo.getRecentStores(
      customerId: tokenPayload.sub,
    );

    return success(
      data: {
        'stores': stores.map((s) => s.toStore().toJson()).toList(),
      },
    );
  } catch (e) {
    return error(message: e.toString());
  }
}

Future<Response> _onPost(RequestContext context) async {
  final repo = context.read<CustomerRepository>();
  final tokenPayload = context.tokenPayload;

  try {
    final body = await context.validateBody(
      CustomerValidator.updateRecentStores,
    );
    final input = CustomerRecentStoresUpdate.fromJson(body);
    final storeId = input.storeId;

    if (!storeId.isUUID()) {
      return badRequest(message: 'Invalid store id.');
    }

    await repo.recordStoreVisit(
      customerId: tokenPayload.sub,
      storeId: storeId,
    );

    return success(data: {'recorded': true});
  } on ResponseException catch (e) {
    return e.response;
  } catch (e) {
    return error(message: e.toString());
  }
}
