import 'package:backend/extensions/merchant_row_extension.dart';
import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/services/auth/password_service.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:validators/validators.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    .get => _onGet(context),
    .patch => _onPatch(context),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onGet(RequestContext context) async {
  final repo = context.merchantRepo;
  final tokenPayload = context.tokenPayload;

  try {
    final merchantRow = await repo.getById(tokenPayload.sub);
    if (merchantRow == null) {
      return badRequest(message: 'Merchant not exists.');
    }

    return success(data: {'merchant': merchantRow.toMerchant()});
  } on Exception catch (e) {
    return error(message: e.toString());
  }
}

Future<Response> _onPatch(RequestContext context) async {
  final repo = context.merchantRepo;
  final tokenPayload = context.tokenPayload;

  try {
    final body = await context.validateBody(MerchantValidator.update);
    final input = MerchantUpdate.fromJson(body);
    final name = input.name;
    final businessName = input.businessName;
    final whatsappNumber = input.whatsappNumber;
    final email = input.email;
    final currentPassword = input.currentPassword;
    final newPassword = input.newPassword;

    final merchant = await repo.getById(tokenPayload.sub);
    if (merchant == null) {
      return badRequest(message: 'Merchant does not exist.');
    }

    String? newPasswordHash;
    if (newPassword != null && newPassword.isNotEmpty) {
      if (currentPassword == null || currentPassword.isEmpty) {
        return badRequest(message: 'Current password is required.');
      }
      final isValid = await PasswordService.verify(
        currentPassword,
        merchant.passwordHash,
      );
      if (!isValid) {
        return badRequest(message: 'Current password is incorrect.');
      }
      if (!RegExp(ValidationPatterns.password).hasMatch(newPassword)) {
        return badRequest(
          message: 'New password must be 6+ characters with a number, lowercase, and uppercase.',
        );
      }
      newPasswordHash = await PasswordService.hash(newPassword);
    }

    final updated = await repo.update(
      id: merchant.id,
      name: name,
      businessName: businessName,
      whatsappNumber: whatsappNumber,
      email: email,
      passwordHash: newPasswordHash,
    );

    if (updated == null) {
      return badRequest(message: 'Failed to update merchant profile.');
    }

    return success(data: {'merchant': updated.toMerchant()});
  } on ResponseException catch (e) {
    return e.response;
  } on Exception catch (e) {
    return error(message: e.toString());
  }
}
