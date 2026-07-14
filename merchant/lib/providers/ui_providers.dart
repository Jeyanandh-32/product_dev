import 'package:jaspr_riverpod/legacy.dart';
import 'package:models/models.dart';

final indexProvider = StateProvider.autoDispose<int>(
  (ref) => 0,
);

final subIndexProvider = StateProvider.autoDispose<int>(
  (ref) => 0,
);

final storeProvider = StateProvider.autoDispose<Store?>(
  (ref) => null,
);

final selectedTabStoreProvider = StateProvider.autoDispose<Store?>(
  (ref) => null,
);

final navOpenProvider = StateProvider.autoDispose<bool>(
  (ref) => false,
);

final headerTitleProvider = StateProvider.autoDispose<String>(
  (ref) => 'Dashboard',
);

final headerSubTitleProvider = StateProvider.autoDispose<String?>(
  (ref) => null,
);

final entriesProvider = StateProvider.autoDispose<int>((ref) => 10);

final productsPageProvider = StateProvider.autoDispose<int>((ref) => 1);
final productsTotalProvider = StateProvider.autoDispose<int>((ref) => 0);
final productsTotalPagesProvider = StateProvider.autoDispose<int>((ref) => 1);

final categoriesPageProvider = StateProvider.autoDispose<int>((ref) => 1);
final categoriesTotalProvider = StateProvider.autoDispose<int>((ref) => 0);
final categoriesTotalPagesProvider = StateProvider.autoDispose<int>((ref) => 1);

final countersPageProvider = StateProvider.autoDispose<int>((ref) => 1);
final countersTotalProvider = StateProvider.autoDispose<int>((ref) => 0);
final countersTotalPagesProvider = StateProvider.autoDispose<int>((ref) => 1);

enum ActiveModal {
  none,
  addStore,
  addTerminal,
  addCounter,
  addCategory,
  addProduct,
  editStore,
  editTerminal,
  editCounter,
  editCategory,
  editProduct,
  updateStock,
}

final activeModalProvider = StateProvider.autoDispose<ActiveModal>(
  (ref) => .none,
);

final editingStoreProvider = StateProvider.autoDispose<Store?>(
  (ref) => null,
);

final editingTerminalProvider = StateProvider.autoDispose<Terminal?>(
  (ref) => null,
);

final editingCounterProvider = StateProvider.autoDispose<Counter?>(
  (ref) => null,
);

final editingCategoryProvider = StateProvider.autoDispose<Category?>(
  (ref) => null,
);

final editingProductProvider = StateProvider.autoDispose<Product?>(
  (ref) => null,
);
