import 'package:backend/config/database.dart';
import 'package:backend/database/schema.dart';
import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/extensions/store_phonepe_config_row_extension.dart';
import 'package:backend/repositories/customer_repository.dart';
import 'package:backend/services/phonepe_service.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';
import 'package:typed_sql/typed_sql.dart' hide Database;

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
  final db = Database.db;
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

    // Verify any pending PhonePe top-up transactions with PhonePe Status API
    for (final tx in txRows) {
      if (tx.status == 'pending' && tx.reference != null && tx.reference!.startsWith('TOPUP_')) {
        final activeConfigRow = await db.storePhonepeConfigs
            .where((c) => c.storeId.equals(toExpr(storeId)) & c.isEnabled.equals(toExpr(true)))
            .first
            .fetch();

        if (activeConfigRow != null) {
          try {
            final phonePeService = PhonePeService();
            final statusResult = await phonePeService.checkOrderStatus(
              config: activeConfigRow.toStorePhonePeConfig(),
              merchantOrderId: tx.reference!,
            );

            final state = (statusResult['state'] as String?) ??
                (statusResult['data'] is Map
                    ? (statusResult['data'] as Map)['state'] as String?
                    : null);

            final stateUpper = state?.toUpperCase();
            if (stateUpper == 'COMPLETED' || stateUpper == 'SUCCESS') {
              await repo.updateStoreWalletBalance(
                customerId: tokenPayload.sub,
                storeId: storeId,
                amountDeltaPaise: tx.amount,
              );
              await repo.updateWalletTransactionStatus(
                id: tx.id,
                status: 'completed',
              );
            } else if (stateUpper == 'FAILED' || stateUpper == 'CANCELLED') {
              await repo.updateWalletTransactionStatus(
                id: tx.id,
                status: 'failed',
              );
            }
          } catch (_) {}
        }
      }
    }

    final currentBalancePaise = await repo.getStoreWalletBalance(
      customerId: tokenPayload.sub,
      storeId: storeId,
    );

    final updatedTxRows = await repo.getWalletTransactions(
      customerId: tokenPayload.sub,
      storeId: storeId,
    );

    final transactions = updatedTxRows
        .where((t) => t.status == 'completed')
        .map(
          (t) => CustomerWalletTransaction(
            id: t.id,
            customerId: t.customerId,
            amount: t.amount / 100.0,
            type: WalletTransactionType.values.firstWhere(
              (e) => e.name == t.type || e.name == _snakeToCamel(t.type),
              orElse: () => WalletTransactionType.topUp,
            ),
            reference: t.reference,
            status: t.status,
            createdAt: t.createdAt,
          ),
        )
        .toList();

    return success(
      data: {
        'walletBalance': currentBalancePaise / 100.0,
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

    // 1. Create a pending top-up transaction record linked to storeId
    final tx = await repo.createWalletTransaction(
      customerId: tokenPayload.sub,
      storeId: storeId,
      amount: amountPaise,
      type: WalletTransactionType.topUp.name,
      reference: topUpRef,
      status: 'pending',
    );

    // 2. Fetch PhonePe configuration for specified store
    final phonePeConfigRow = await db.storePhonepeConfigs
        .where((c) => c.storeId.equals(toExpr(storeId)) & c.isEnabled.equals(toExpr(true)))
        .first
        .fetch();

    if (phonePeConfigRow == null) {
      return error(message: 'Online payment configuration is not enabled for this store.', statusCode: 400);
    }

    final phonePeConfig = phonePeConfigRow.toStorePhonePeConfig();
    final redirectUrl = '${context.request.uri.scheme}://${context.request.uri.authority}/profile?topupRef=$topUpRef';

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

String _snakeToCamel(String text) {
  final parts = text.split('_');
  if (parts.length <= 1) return text;
  return parts.first +
      parts
          .skip(1)
          .map((p) => p.isEmpty ? '' : p[0].toUpperCase() + p.substring(1))
          .join();
}
