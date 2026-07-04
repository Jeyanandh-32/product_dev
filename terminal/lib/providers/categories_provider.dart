import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:models/models.dart';
import 'package:terminal/providers/auth_provider.dart';
import 'package:terminal/repositories/category_repository.dart';

class CategoriesProvider extends AsyncNotifier<List<Category>> {
  @override
  FutureOr<List<Category>> build() async {
    final terminal = ref.watch(authProvider);
    try {
      return await CategoryRepository.getAll(storeId: terminal.value?.storeId);
    } catch (e) {
      return [];
    }
  }
}

final categoriesProvider =
    AsyncNotifierProvider<CategoriesProvider, List<Category>>(
      () => CategoriesProvider(),
    );
