import 'package:backend/extensions/merchant_dto_extension.dart';
import 'package:backend/models/token_payload.dart';
import 'package:backend/repositories/merchant_repository.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:postgres/postgres.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    .get => _onGet(context),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onGet(RequestContext context) async {
  final conn = context.read<Connection>();
  final repo = MerchantRepository(conn: conn);
  final tokenPayload = context.read<TokenPayload>();

  try {
    final merchantDto = await repo.getById(tokenPayload.sub);
    print(tokenPayload.sub);
    if (merchantDto == null) {
      return badRequest(message: 'Merchant not exists.');
    }

    final merchant = merchantDto.toMerchant();

    return succes(data: {'merchant': merchant});
  } on Exception catch (e) {
    return error(message: e.toString());
  }
}
