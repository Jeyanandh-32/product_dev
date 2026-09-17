import 'package:api_client/api_client.dart';
import 'package:client_repositories/client_repositories.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:merchant/signals/toast_signal.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

final bottleReturnConfigSignal = signal<BottleReturnConfig?>(null);
final bottleReturnProductsSignal = asyncSignal<List<Map<String, dynamic>>>(
  const AsyncLoading(),
);
final bottleProductSearchSignal = signal<String>('');

Future<void> loadBottleReturnData(String storeId) async {
  untracked(() {
    bottleReturnProductsSignal.value = const AsyncLoading();
  });

  try {
    final cfg = await BottleReturnClientRepository.getConfig(storeId);
    bottleReturnConfigSignal.value = cfg;

    final prods = await BottleReturnProductClientRepository.getProductsForStore(
      storeId,
    );
    bottleReturnProductsSignal.value = AsyncData(prods);
  } catch (e, stack) {
    bottleReturnProductsSignal.value = AsyncError(e, stack);
  }
}

abstract final class BottleReturnActions {
  static Future<void> saveStoreConfig({
    required String storeId,
    required bool isEnabled,
    required int rewardAmount,
    String? successMessage,
  }) async {
    final prev = bottleReturnConfigSignal.value;
    try {
      final res = await dio.put(
        ApiEndpoints.bottleReturnsConfig,
        data: {
          'storeId': storeId,
          'isEnabled': isEnabled,
          'rewardAmountInRupees': rewardAmount,
        },
      );
      final cfgMap = res.data['data']['config'] as Map<String, dynamic>;
      final updated = BottleReturnConfig.fromJson(cfgMap);
      bottleReturnConfigSignal.value = updated;

      final isToggleChange = prev?.isEnabled != isEnabled;
      if (isToggleChange) {
        refreshStoresSignal();
      }

      final message =
          successMessage ??
          (isToggleChange
              ? (isEnabled
                    ? 'Bottle returns enabled for this store.'
                    : 'Bottle returns disabled.')
              : (prev?.rewardAmountInRupees != rewardAmount
                    ? 'Bottle deposit reward updated to ₹$rewardAmount.'
                    : 'Bottle return settings saved.'));

      showToast(message, type: ToastType.success);
    } on ApiException catch (e) {
      showToast(e.message);
    } catch (_) {
      showToast('Failed to update bottle return settings.');
    }
  }

  static Future<void> toggleProduct({
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
      showToast('Failed to update product status.');
    }
  }

  static Future<void> toggleAllProducts({
    required String storeId,
    required bool isReturnable,
  }) async {
    final currentList = bottleReturnProductsSignal.value.value ?? [];
    if (currentList.isEmpty) return;

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

    if (success) {
      showToast(
        isReturnable
            ? 'All products marked as returnable.'
            : 'All products marked as not returnable.',
        type: ToastType.success,
      );
    } else {
      bottleReturnProductsSignal.value = AsyncData(currentList);
      showToast('Failed to update products.');
    }
  }
}
