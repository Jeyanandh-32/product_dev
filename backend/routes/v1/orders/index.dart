import 'package:backend/extensions/request_context_extension.dart';
import 'package:backend/repositories/subscription_repository.dart';
import 'package:backend/services/order_query_helper.dart';
import 'package:backend/services/order_service.dart';
import 'package:backend/utils/responses.dart';
import 'package:dart_frog/dart_frog.dart';
import 'package:models/models.dart';
import 'package:validators/validators.dart';

Future<Response> onRequest(RequestContext context) async {
  return switch (context.request.method) {
    .get => OrderQueryHelper.fetchPaginatedOrders(context),
    .post => _onPost(context),
    _ => methodNotAllowed(),
  };
}

Future<Response> _onPost(RequestContext context) async {
  final storeIdError = context.validateStoreId();
  if (storeIdError != null) return storeIdError;

  try {
    final subRepo = context.read<SubscriptionRepository>();
    final isOperational = await subRepo.isStoreOperational(context.storeId);
    if (!isOperational) {
      return badRequest(
        message: 'Store subscription is expired. Ordering is disabled.',
      );
    }

    final body = await context.validateBody(OrderValidator.create);
    final input = OrderCreate.fromJson(body);
    final tokenPayload = context.tokenPayload;
    final orderService = context.read<OrderService>();

    final productsList = input.products
        .map(
          (p) => {
            'productId': p.productId,
            'quantity': p.quantity,
            'discount': p.discount,
          },
        )
        .toList();

    final source = OrderSource.values.firstWhere(
      (e) => e.name == input.source,
      orElse: () => .terminal,
    );
    final type = OrderType.values.firstWhere(
      (e) => e.name == input.type,
      orElse: () => .dineIn,
    );
    final paymentMethod = PaymentMethod.values.firstWhere(
      (e) => e.name == input.paymentMethod,
      orElse: () => .cash,
    );

    final completeOrder = await orderService.checkout(
      merchantId: tokenPayload.sub,
      storeId: context.storeId,
      productsInput: productsList,
      source: source,
      type: type,
      paymentMethod: paymentMethod,
      discountTotalInput: input.discountTotal ?? 0.0,
      terminalCode: tokenPayload.terminalCode,
    );

    return success(data: {'order': completeOrder});
  } on ResponseException catch (e) {
    return e.response;
  } catch (e) {
    return error(message: e.toString());
  }
}
