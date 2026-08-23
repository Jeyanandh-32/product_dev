import 'package:client_repositories/client_repositories.dart';
import 'package:signals_flutter/signals_flutter.dart';

/// Reactive async signal holding the list of store products with returnable bottle status.
final bottleReturnProductsSignal = asyncSignal<List<Map<String, dynamic>>>(
  const AsyncLoading(),
);

/// Helper actions for managing returnable products in Terminal POS.
class BottleReturnProductActions {
  const BottleReturnProductActions._();

  /// Loads the store catalog with returnable status flags.
  static Future<void> loadProducts(String storeId) async {
    bottleReturnProductsSignal.value = const AsyncLoading();
    try {
      final prods =
          await BottleReturnProductClientRepository.getProductsForStore(
            storeId,
          );
      bottleReturnProductsSignal.value = AsyncData(prods);
    } catch (e, st) {
      bottleReturnProductsSignal.value = AsyncError(e, st);
    }
  }

  /// Toggles returnable status for a single product with optimistic UI updates.
  static Future<bool> toggleProduct({
    required String storeId,
    required String productId,
    required bool isReturnable,
  }) async {
    final currentList = bottleReturnProductsSignal.value.value ?? [];
    bottleReturnProductsSignal.value = AsyncData(
      currentList.map((p) {
        if (p['productId'] == productId) {
          return {...p, 'isReturnable': isReturnable};
        }
        return p;
      }).toList(),
    );

    final success =
        await BottleReturnProductClientRepository.setProductReturnable(
          storeId: storeId,
          productId: productId,
          isReturnable: isReturnable,
        );

    if (!success) {
      bottleReturnProductsSignal.value = AsyncData(currentList);
    }
    return success;
  }

  /// Toggles returnable status for all store products in bulk.
  static Future<bool> toggleAllProducts({
    required String storeId,
    required bool isReturnable,
  }) async {
    final currentList = bottleReturnProductsSignal.value.value ?? [];
    if (currentList.isEmpty) return false;

    bottleReturnProductsSignal.value = AsyncData(
      currentList.map((p) => {...p, 'isReturnable': isReturnable}).toList(),
    );

    final productIds = currentList
        .map((p) => p['productId'] as String)
        .toList();

    final success =
        await BottleReturnProductClientRepository.bulkSetProductsReturnable(
          storeId: storeId,
          productIds: productIds,
          isReturnable: isReturnable,
        );

    if (!success) {
      bottleReturnProductsSignal.value = AsyncData(currentList);
    }
    return success;
  }
}
