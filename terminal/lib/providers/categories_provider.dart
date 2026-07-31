import 'dart:async';

import 'package:client_repositories/client_repositories.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'package:terminal/providers/auth_provider.dart';

class CategoriesProvider extends AsyncNotifier<List<Category>> {
  @override
  FutureOr<List<Category>> build() async {
    final terminal = ref.watch(authProvider);
    final storeId = terminal.value?.storeId;
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
  }
}

final categoriesProvider =
    AsyncNotifierProvider<CategoriesProvider, List<Category>>(
      () => CategoriesProvider(),
    );
