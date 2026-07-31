import 'package:models/models.dart';
import 'package:signals/signals.dart';

final indexSignal = signal<int>(0);
final subIndexSignal = signal<int>(0);
final storeSignal = signal<Store?>(null);
final selectedTabStoreSignal = signal<Store?>(null);
final navOpenSignal = signal<bool>(false);
final headerTitleSignal = signal<String>('Dashboard');
final headerSubTitleSignal = signal<String?>(null);

final entriesSignal = signal<int>(10);

final productsPageSignal = signal<int>(1);
final productsTotalSignal = signal<int>(0);
final productsTotalPagesSignal = signal<int>(1);

final categoriesPageSignal = signal<int>(1);
final categoriesTotalSignal = signal<int>(0);
final categoriesTotalPagesSignal = signal<int>(1);

final countersPageSignal = signal<int>(1);
final countersTotalSignal = signal<int>(0);
final countersTotalPagesSignal = signal<int>(1);

final ordersPageSignal = signal<int>(1);
final ordersTotalSignal = signal<int>(0);
final ordersTotalPagesSignal = signal<int>(1);

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

final activeModalSignal = signal<ActiveModal>(ActiveModal.none);

final editingStoreSignal = signal<Store?>(null);
final editingTerminalSignal = signal<Terminal?>(null);
final editingCounterSignal = signal<Counter?>(null);
final editingCategorySignal = signal<Category?>(null);
final editingProductSignal = signal<Product?>(null);
