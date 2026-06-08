import 'package:jaspr_riverpod/legacy.dart';

final indexProvider = StateProvider.autoDispose<int>(
  (ref) => 0,
);

final storeProvider = StateProvider.autoDispose<String>(
  (ref) => 'STORE - 1',
);

final navOpenProvider = StateProvider.autoDispose<bool>(
  (ref) => false,
);

final headerTitleProvider = StateProvider.autoDispose<String>(
  (ref) => 'Dashboard',
);

enum ActiveModal {
  none,
  addStore,
  addTerminal,
  editStore,
}

final activeModalProvider = StateProvider.autoDispose<ActiveModal>(
  (ref) => .none,
);
