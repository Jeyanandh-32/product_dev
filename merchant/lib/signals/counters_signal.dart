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
final counterSearchSignal = signal<String>('');
final editingCounterSignal = signal<Counter?>(null);

final countersSignal = asyncSignal<List<Counter>>(const AsyncLoading());

void resetCountersSignal() {
  countersPageSignal.value = 1;
  countersTotalSignal.value = 0;
  countersTotalPagesSignal.value = 1;
  counterSearchSignal.value = '';
  editingCounterSignal.value = null;
  countersSignal.value = const AsyncData([]);
}

Future<void> refreshCountersSignal() async {
  final selectedStore = storeSignal.value;
  if (selectedStore == null) {
    untracked(() {
      countersSignal.value = const AsyncData([]);
    });
    return;
  }

  untracked(() {
    countersSignal.value = const AsyncLoading();
  });

  final size = entriesSignal.value;
  final page = countersPageSignal.value;

  try {
    final search = counterSearchSignal.value.trim();

    final result = await CounterRepository.getAll(
      storeId: selectedStore.id,
      page: page,
      size: size,
      search: search.isNotEmpty ? search : null,
    );

    countersTotalSignal.value = result.totalItems;
    countersTotalPagesSignal.value = result.totalPages;
    countersSignal.value = AsyncData(result.items);
  } catch (e, stack) {
    countersSignal.value = AsyncError(e, stack);
  }
}

abstract final class CountersActions {
  static Future<void> create({
    required String name,
    String? description,
    String? imageUrl,
  }) async {
    final selectedStore = storeSignal.value;
    if (selectedStore == null) return;

    final currentCounters = countersSignal.value.value ?? [];
    untracked(() {
      countersSignal.value = const AsyncLoading();
    });

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
    untracked(() {
      countersSignal.value = const AsyncLoading();
    });

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
