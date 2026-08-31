import 'package:merchant/components/cards/store_card.dart';
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

    test('AddEditStoreModal holds provisioned and unprovisioned store instances', () {
      final modalUnprovisioned = AddEditStoreModal(store: unprovisionedStore);
      expect(modalUnprovisioned.store?.isBottleReturnEnabled, isFalse);

      final modalProvisioned = AddEditStoreModal(store: provisionedStore);
      expect(modalProvisioned.store?.isBottleReturnEnabled, isTrue);
    });
  });
}
