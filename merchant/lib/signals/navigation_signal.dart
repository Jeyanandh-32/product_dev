import 'package:signals/signals.dart';

final navOpenSignal = signal<bool>(false);
final entriesSignal = signal<int>(10);
final showReportsStatsSignal = signal<bool>(false);

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
  bottleReturns,
}

final activeModalSignal = signal<ActiveModal>(.none);

void resetNavigationSignal() {
  navOpenSignal.value = false;
  entriesSignal.value = 10;
  activeModalSignal.value = ActiveModal.none;
  showReportsStatsSignal.value = false;
}
