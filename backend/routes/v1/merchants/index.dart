import 'package:backend/extensions/merchant_dto_extension.dart';
import 'package:backend/models/token_payload/token_payload.dart';
import 'package:backend/repositories/merchant_repository.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    .get => _onGet(context),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onGet(RequestContext context) async {
  final repo = context.read<MerchantRepository>();
  final tokenPayload = context.read<TokenPayload>();

  try {
    final merchantDto = await repo.getById(tokenPayload.sub);
    if (merchantDto == null) {
      return badRequest(message: 'Merchant not exists.');
    }

    final merchant = merchantDto.toMerchant();

    return success(data: {'merchant': merchant});
  } on Exception catch (e) {
    return error(message: e.toString());
  }
}
