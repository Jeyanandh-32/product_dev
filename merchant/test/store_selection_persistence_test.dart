import 'package:merchant/signals/stores_signal.dart';
import 'package:models/models.dart';
import 'package:test/test.dart';

void main() {
  final now = DateTime.now();

  final storeA = Store(
    id: 'store-a',
    merchantId: 'm-1',
    name: 'Downtown Store',
    isActive: true,
    createdAt: now,
    updatedAt: now,
  );

  final storeB = Store(
    id: 'store-b',
    merchantId: 'm-1',
    name: 'Uptown Store',
    isActive: true,
    createdAt: now,
    updatedAt: now,
  );

  final storeC = Store(
    id: 'store-c',
    merchantId: 'm-1',
    name: 'Suburban Store',
    isActive: true,
    createdAt: now,
    updatedAt: now,
  );

  setUp(() {
    resetStoresSignal();
    clearLastSelectedStoreId();
  });

  tearDown(() {
    resetStoresSignal();
    clearLastSelectedStoreId();
  });

  group('Store Selection Persistence & Separation Tests', () {
    test('selectActiveStore updates global storeSignal and persists to storage', () {
      selectActiveStore(storeB);

      expect(storeSignal.value?.id, equals(storeB.id));
      expect(selectedTabStoreSignal.value, isNull);
      expect(getLastSelectedStoreId(), equals(storeB.id));
    });

    test('selectTabStore updates selectedTabStoreSignal without mutating global store', () {
      selectActiveStore(storeA);
      expect(storeSignal.value?.id, equals(storeA.id));

      selectTabStore(storeC);
      expect(selectedTabStoreSignal.value?.id, equals(storeC.id));
      expect(storeSignal.value?.id, equals(storeA.id));
      expect(getLastSelectedStoreId(), equals(storeA.id));
    });

    test('resolvePreferredStore prioritizes saved store ID from storage on reload', () {
      saveLastSelectedStoreId(storeC.id);

      final resolved = resolvePreferredStore([storeA, storeB, storeC]);
      expect(resolved.id, equals(storeC.id));
    });

    test('resolvePreferredStore falls back to in-memory storeSignal when storage empty', () {
      storeSignal.value = storeB;

      final resolved = resolvePreferredStore([storeA, storeB, storeC]);
      expect(resolved.id, equals(storeB.id));
    });

    test('resolvePreferredStore falls back to stores.first when saved id missing', () {
      saveLastSelectedStoreId('non-existent-store');

      final resolved = resolvePreferredStore([storeA, storeB, storeC]);
      expect(resolved.id, equals(storeA.id));
    });

    test('clearLastSelectedStoreId removes stored ID', () {
      saveLastSelectedStoreId(storeA.id);
      expect(getLastSelectedStoreId(), equals(storeA.id));

      clearLastSelectedStoreId();
      expect(getLastSelectedStoreId(), isNull);
    });
  });
}
