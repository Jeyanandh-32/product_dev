import 'package:backend/extensions/customer_row_extension.dart';
import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/repositories/customer_repository.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _onGet(context),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onGet(RequestContext context) async {
  final repo = context.read<CustomerRepository>();
  final tokenPayload = context.tokenPayload;

  try {
    final customerRow = await repo.getById(tokenPayload.sub);
    if (customerRow == null) {
      return badRequest(message: 'Customer does not exist.');
    }

    return success(data: {'customer': customerRow.toCustomer()});
  } on Exception catch (e) {
    return error(message: e.toString());
  }
}
