import 'dart:async';

import 'package:client_repositories/client_repositories.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:merchant/providers/ui_providers.dart';
import 'package:models/models.dart';

final ordersProvider =
    AsyncNotifierProvider.autoDispose<OrdersProvider, List<Order>>(
      () => OrdersProvider(),
    );

class OrdersProvider extends AsyncNotifier<List<Order>> {
  @override
  FutureOr<List<Order>> build() async {
    final selectedStore = ref.watch(storeProvider);
    if (selectedStore == null) return [];

    final size = ref.watch(entriesProvider);
    final page = ref.watch(ordersPageProvider);

    final result = await OrderRepository.getAll(
      storeId: selectedStore.id,
      page: page,
      size: size,
    );

    ref.read(ordersTotalProvider.notifier).state = result.totalItems;
    ref.read(ordersTotalPagesProvider.notifier).state = result.totalPages;

    return result.items;
  }
}
