import 'package:client_repositories/client_repositories.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/signals/auth_signal.dart';

final countersSignal = futureSignal<List<Counter>>(() async {
  final terminal = authSignal.value.value;
  final storeId = terminal?.storeId;
  if (storeId == null) return [];
  try {
    final result = await CounterRepository.getAll(storeId: storeId, size: 1000);
    return result.items;
  } catch (e) {
    return [];
  }
});

/// Refreshes counters future signal.
Future<void> refreshCountersSignal() async {
  countersSignal.refresh();
}

/// Resets and refreshes counters future signal.
void resetCountersSignal() {
  countersSignal.refresh();
}
