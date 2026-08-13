import 'package:backend/extensions/merchant_row_extension.dart';
import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/repositories/merchant_repository.dart';
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
  final repo = context.read<MerchantRepository>();
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
  final repo = context.read<MerchantRepository>();
  final tokenPayload = context.tokenPayload;

  try {
    Map<String, dynamic> body;
    try {
      body = (await context.request.json()) as Map<String, dynamic>;
    } catch (_) {
      return invalidBody();
    }
    final name = body['name'] as String?;
    final businessName = body['businessName'] as String?;
    final whatsappNumber = body['whatsappNumber'] as String?;
    final email = body['email'] as String?;
    final currentPassword = body['currentPassword'] as String?;
    final newPassword = body['newPassword'] as String?;

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
          message:
              'New password must be 6+ characters with a number, lowercase, and uppercase.',
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
  } on Exception catch (e) {
    return error(message: e.toString());
  }
}
