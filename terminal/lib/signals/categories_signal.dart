import 'package:client_repositories/client_repositories.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/signals/auth_signal.dart';

final categoriesSignal = futureSignal<List<Category>>(() async {
  final terminal = authSignal.value.value;
  final storeId = terminal?.storeId;
  if (storeId == null) return [];
  try {
    final result = await CategoryRepository.getAll(
      storeId: storeId,
      size: 1000,
    );
    return result.items;
  } catch (e) {
    return [];
  }
});
