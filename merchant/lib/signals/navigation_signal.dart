import 'package:signals/signals.dart';

final navOpenSignal = signal<bool>(false);
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
  orderDetails,
}

final activeModalSignal = signal<ActiveModal>(.none);
