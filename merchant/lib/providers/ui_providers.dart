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

enum ActiveModal {
  none,
  addStore,
  addTerminal,
  editStore,
  editTerminal,
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
