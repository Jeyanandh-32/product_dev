import 'package:jaspr_riverpod/legacy.dart';

final indexProvider = StateProvider<int>(
  (ref) => 0,
);

final storeProvider = StateProvider<String>(
  (ref) => 'STORE - 1',
);

final navOpenProvider = StateProvider<bool>(
  (ref) => false,
);

final headerTitleProvider = StateProvider<String>(
  (ref) => 'Dashboard',
);