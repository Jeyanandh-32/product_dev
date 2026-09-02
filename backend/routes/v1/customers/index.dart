import 'package:backend/extensions/customer_row_extension.dart';
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
  final repo = context.customerRepo;
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

Future<Response> _onPatch(RequestContext context) async {
  final repo = context.customerRepo;
  final tokenPayload = context.tokenPayload;

  try {
    final body = await context.validateBody(CustomerValidator.update);
    final input = CustomerUpdate.fromJson(body);
    final name = input.name;
    final mobileNumber = input.mobileNumber;
    final pin = input.pin;
    final currentPin = input.currentPin;

    final customerRow = await repo.getById(tokenPayload.sub);
    if (customerRow == null) {
      return badRequest(message: 'Customer does not exist.');
    }

    // Mobile Number Change Validation & Uniqueness Check
    String? newMobile;
    if (mobileNumber != null && mobileNumber.trim().isNotEmpty) {
      newMobile = mobileNumber.trim();
      if (newMobile != customerRow.mobileNumber) {
        if (currentPin == null || currentPin.trim().isEmpty) {
          return badRequest(
            message: 'Security PIN is required to change mobile number.',
          );
        }
        final isCurrentValid = await PasswordService.verify(
          currentPin.trim(),
          customerRow.pinHash,
        );
        if (!isCurrentValid) {
          return badRequest(message: 'Incorrect security PIN.');
        }

        final existing = await repo.getByMobileNumber(newMobile);
        if (existing != null && existing.id != customerRow.id) {
          return badRequest(message: 'Mobile number is already registered.');
        }
      }
    }

    String? pinHash;
    if (pin != null && pin.trim().isNotEmpty) {
      if (currentPin == null || currentPin.trim().isEmpty) {
        return badRequest(message: 'Current PIN is required to set a new PIN.');
      }
      final isCurrentValid = await PasswordService.verify(
        currentPin.trim(),
        customerRow.pinHash,
      );
      if (!isCurrentValid) {
        return badRequest(message: 'Current PIN is incorrect.');
      }
      pinHash = await PasswordService.hash(pin.trim());
    }

    final updated = await repo.update(
      id: tokenPayload.sub,
      name: name?.trim(),
      mobileNumber: newMobile,
      pinHash: pinHash,
    );

    if (updated == null) {
      return badRequest(message: 'Failed to update customer profile.');
    }

    return success(data: {'customer': updated.toCustomer()});
  } on ResponseException catch (e) {
    return e.response;
  } on Exception catch (e) {
    return error(message: e.toString());
  }
}
