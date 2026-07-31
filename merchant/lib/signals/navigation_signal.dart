import 'package:signals/signals.dart';

final indexSignal = signal<int>(0);
final subIndexSignal = signal<int>(0);
final navOpenSignal = signal<bool>(false);
final headerTitleSignal = signal<String>('Dashboard');
final headerSubTitleSignal = signal<String?>(null);

final entriesSignal = signal<int>(10);

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
