import 'package:merchant/components/modals/add_edit_store_modal.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  final now = DateTime.now();

  group('AddEditStoreModal Tests', () {
    test(
      'AddEditStoreModal instantiates for adding a new store (store is null)',
      () {
        const modal = AddEditStoreModal();
        expect(modal.store, isNull);
      },
    );

    test('AddEditStoreModal instantiates for editing an existing store', () {
      final store = Store(
        id: 'store-1',
        merchantId: 'm-1',
        name: 'Downtown Bakery',
        storeType: 'bakery',
        isOnlineEnabled: true,
        slug: 'downtown-bakery',
        isActive: true,
        createdAt: now,
        updatedAt: now,
      );

      final modal = AddEditStoreModal(store: store);
      expect(modal.store, equals(store));
      expect(modal.store?.isOnlineEnabled, isTrue);
      expect(modal.store?.slug, 'downtown-bakery');
    });
  });
}
