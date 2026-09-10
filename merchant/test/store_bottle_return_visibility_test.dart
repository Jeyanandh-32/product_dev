import 'package:merchant/components/cards/bottle_return_product_row.dart';
import 'package:merchant/components/cards/store_card.dart';
import 'package:merchant/components/containers/bottle_return_header.dart';
import 'package:merchant/components/containers/bottle_return_reward_card.dart';
import 'package:merchant/components/modals/add_edit_store_modal.dart';
import 'package:merchant/components/modals/store_bottle_returns_section.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  final now = DateTime.now();

  final unprovisionedStore = Store(
    id: 'store-1',
    merchantId: 'm-1',
    name: 'Normal Branch',
    isActive: true,
    isBottleReturnEnabled: false,
    createdAt: now,
    updatedAt: now,
  );

  final provisionedStore = Store(
    id: 'store-2',
    merchantId: 'm-1',
    name: 'Eco Branch',
    isActive: true,
    isBottleReturnEnabled: true,
    createdAt: now,
    updatedAt: now,
  );

  group('Bottle Return Store Visibility Tests', () {
    test('StoreBottleReturnsSection instantiates with store', () {
      final section = StoreBottleReturnsSection(store: provisionedStore);
      expect(section.store.id, 'store-2');
      expect(section.store.isBottleReturnEnabled, isTrue);
    });

    test('StoreCard reflects bottle return provisioning status', () {
      final cardUnprovisioned = StoreCard(
        store: unprovisionedStore,
        count: 2,
      );
      expect(cardUnprovisioned.store.isBottleReturnEnabled, isFalse);

      final cardProvisioned = StoreCard(
        store: provisionedStore,
        count: 3,
        onBottleReturns: () {},
      );
      expect(cardProvisioned.store.isBottleReturnEnabled, isTrue);
      expect(cardProvisioned.onBottleReturns, isNotNull);
    });

    test(
      'AddEditStoreModal holds provisioned and unprovisioned store instances',
      () {
        final modalUnprovisioned = AddEditStoreModal(store: unprovisionedStore);
        expect(modalUnprovisioned.store?.isBottleReturnEnabled, isFalse);

        final modalProvisioned = AddEditStoreModal(store: provisionedStore);
        expect(modalProvisioned.store?.isBottleReturnEnabled, isTrue);
      },
    );
  });

  group('Bottle Return Modal Component Tests', () {
    test('BottleReturnHeader instantiates and reflects store parameters', () {
      var toggled = false;
      final header = BottleReturnHeader(
        store: provisionedStore,
        isEnabled: true,
        returnableCount: 5,
        onToggleStore: (v) => toggled = v,
      );

      expect(header.store.id, 'store-2');
      expect(header.isEnabled, isTrue);
      expect(header.returnableCount, 5);
      header.onToggleStore(false);
      expect(toggled, isFalse);
    });

    test('BottleReturnRewardCard instantiates with reward amount', () {
      var savedReward = 0;
      final rewardCard = BottleReturnRewardCard(
        rewardAmount: 15,
        onSaveReward: (amt) => savedReward = amt,
      );

      expect(rewardCard.rewardAmount, 15);
      rewardCard.onSaveReward(20);
      expect(savedReward, 20);
    });

    test('BottleReturnProductRow instantiates with product map and dispatches toggle', () {
      var toggledState = false;
      final row = BottleReturnProductRow(
        product: {
          'productId': 'p-1',
          'name': 'Mineral Water Bottle 1L',
          'categoryName': 'Beverages',
          'sellingPrice': 25.0,
          'isReturnable': true,
        },
        onToggle: (val) => toggledState = val,
      );

      expect(row.product['productId'], 'p-1');
      expect(row.product['isReturnable'], isTrue);
      row.onToggle(false);
      expect(toggledState, isFalse);
    });
  });
}
