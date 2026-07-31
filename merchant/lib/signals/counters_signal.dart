import 'package:client_repositories/client_repositories.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:merchant/signals/toast_signal.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

final countersPageSignal = signal<int>(1);
final countersTotalSignal = signal<int>(0);
final countersTotalPagesSignal = signal<int>(1);
final editingCounterSignal = signal<Counter?>(null);

final countersSignal = asyncSignal<List<Counter>>(const AsyncLoading());

Future<void> refreshCountersSignal() async {
  final selectedStore = storeSignal.value;
  if (selectedStore == null) {
    countersSignal.value = const AsyncData([]);
    return;
  }

  final size = entriesSignal.value;
  final page = countersPageSignal.value;

  try {
    final result = await CounterRepository.getAll(
      storeId: selectedStore.id,
      page: page,
      size: size,
    );

    countersTotalSignal.value = result.totalItems;
    countersTotalPagesSignal.value = result.totalPages;
    countersSignal.value = AsyncData(result.items);
  } catch (e, stack) {
    countersSignal.value = AsyncError(e, stack);
  }
}

class CountersActions {
  const CountersActions._();

  static Future<void> create({
    required String name,
    String? description,
    String? imageUrl,
  }) async {
    final selectedStore = storeSignal.value;
    if (selectedStore == null) return;

    final currentCounters = countersSignal.value.value ?? [];
    countersSignal.value = const AsyncLoading();

    try {
      final counter = await CounterRepository.create(
        storeId: selectedStore.id,
        name: name,
        description: description,
        imageUrl: imageUrl,
      );

      countersSignal.value = AsyncData([...currentCounters, counter]);
    } catch (e) {
      final message = e is ApiException ? e.message : 'Something went wrong.';
      showToast(message);

      countersSignal.value = AsyncData(currentCounters);
    }
  }

  static Future<void> updateCounter({
    required String id,
    String? name,
    bool? isActive,
    String? description,
    String? imageUrl,
  }) async {
    final currentCounters = countersSignal.value.value ?? [];
    countersSignal.value = const AsyncLoading();

    try {
      final updatedCounter = await CounterRepository.update(
        id: id,
        name: name,
        isActive: isActive,
        description: description,
        imageUrl: imageUrl,
      );

      countersSignal.value = AsyncData(
        currentCounters.map((s) => s.id == id ? updatedCounter : s).toList(),
      );
    } catch (e) {
      final message = e is ApiException ? e.message : 'Something went wrong.';
      showToast(message);

      countersSignal.value = AsyncData(currentCounters);
    }
  }
}
