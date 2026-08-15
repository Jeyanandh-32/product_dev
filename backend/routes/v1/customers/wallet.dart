import 'package:backend/config/database.dart';
import 'package:backend/database/schema.dart';
import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/extensions/store_phonepe_config_row_extension.dart';
import 'package:backend/repositories/customer_repository.dart';
import 'package:backend/services/phonepe_service.dart';
import 'package:backend/services/wallet_verification_service.dart';
import 'package:backend/utils/responses.dart';
import 'package:change_case/change_case.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' hide Database;

/// Endpoint for customer wallet balance retrieval, PhonePe top-up initiation, and verification.
Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    HttpMethod.get => _onGet(context),
    HttpMethod.post => _onPost(context),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onGet(RequestContext context) async {
  final repo = context.read<CustomerRepository>();
  final tokenPayload = context.tokenPayload;
  final storeId = context.request.uri.queryParameters['storeId'];

  if (storeId == null || storeId.isEmpty) {
    return badRequest(message: 'storeId is required.');
  }

  try {
    final customer = await repo.getById(tokenPayload.sub);
    if (customer == null) {
      return badRequest(message: 'Customer not found.');
    }

    final txRows = await repo.getWalletTransactions(
      customerId: tokenPayload.sub,
      storeId: storeId,
    );

    // Verify pending PhonePe top-up transactions
    final verificationService = WalletVerificationService(
      repo: repo,
      phonePeService: PhonePeService(),
    );
    await verificationService.verifyPendingTopUps(
      txRows: txRows,
      storeId: storeId,
      customerId: tokenPayload.sub,
    );

    final balancePaise = await repo.getStoreWalletBalance(
      customerId: tokenPayload.sub,
      storeId: storeId,
    );
    final updatedTxRows = await repo.getWalletTransactions(
      customerId: tokenPayload.sub,
      storeId: storeId,
    );

    final transactions = updatedTxRows.map((row) {
      final typeStr = row.type.toCamelCase();
      final txType = WalletTransactionType.values.firstWhere(
        (t) => t.name.toLowerCase() == typeStr.toLowerCase(),
        orElse: () => WalletTransactionType.topUp,
      );

      return CustomerWalletTransaction(
        id: row.id,
        customerId: row.customerId,
        amount: row.amount / 100.0,
        type: txType,
        reference: row.reference,
        status: row.status,
        createdAt: row.createdAt,
      );
    }).toList();

    return success(
      data: {
        'balance': balancePaise / 100.0,
        'transactions': transactions.map((t) => t.toJson()).toList(),
      },
    );
  } on Exception catch (e) {
    return error(message: e.toString());
  }
}

Future<Response> _onPost(RequestContext context) async {
  final repo = context.read<CustomerRepository>();
  final tokenPayload = context.tokenPayload;
  final db = Database.db;
  final phonePeService = PhonePeService();

  try {
    final body = await context.request.json() as Map<String, dynamic>;
    final amountDouble = (body['amount'] as num?)?.toDouble();
    final storeId = body['storeId'] as String?;

    if (amountDouble == null || amountDouble <= 0) {
      return badRequest(message: 'Invalid top up amount.');
    }

    if (storeId == null || storeId.isEmpty) {
      return badRequest(message: 'storeId is required for wallet top-up.');
    }

    final amountPaise = (amountDouble * 100).round();
    final topUpRef = 'TOPUP_${DateTime.now().millisecondsSinceEpoch}';

    final tx = await repo.createWalletTransaction(
      customerId: tokenPayload.sub,
      storeId: storeId,
      amount: amountPaise,
      type: WalletTransactionType.topUp.name,
      reference: topUpRef,
      status: 'pending',
    );

    final phonePeConfigRow = await db.storePhonepeConfigs
        .where(
          (c) =>
              c.storeId.equals(toExpr(storeId)) &
              c.isEnabled.equals(toExpr(true)),
        )
        .first
        .fetch();

    if (phonePeConfigRow == null) {
      return badRequest(
        message: 'Online payment configuration is not enabled for this store.',
      );
    }

    final phonePeConfig = phonePeConfigRow.toStorePhonePeConfig();
    final redirectUrl =
        '${context.request.uri.scheme}://${context.request.uri.authority}/profile?topupRef=$topUpRef';

    final paymentSession = await phonePeService.initiatePayment(
      config: phonePeConfig,
      merchantOrderId: topUpRef,
      amountInPaisa: amountPaise,
      redirectUrl: redirectUrl,
      customerId: tokenPayload.sub,
    );

    return success(
      data: {
        'tokenUrl': paymentSession.tokenUrl,
        'merchantOrderId': topUpRef,
        'phonePeOrderId': paymentSession.orderId,
        'isPendingPayment': true,
        'transaction': CustomerWalletTransaction(
          id: tx.id,
          customerId: tx.customerId,
          amount: tx.amount / 100.0,
          type: WalletTransactionType.topUp,
          reference: tx.reference,
          status: tx.status,
          createdAt: tx.createdAt,
        ).toJson(),
      },
    );
  } on Exception catch (e) {
    return error(message: e.toString());
  }
}
