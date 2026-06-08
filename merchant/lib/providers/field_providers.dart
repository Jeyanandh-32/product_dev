import 'package:jaspr_riverpod/legacy.dart';

final loginEmailProvider = StateProvider.autoDispose<String>(
  (ref) => '',
);

final loginPasswordProvider = StateProvider.autoDispose<String>(
  (ref) => '',
);

final fullNameProvider = StateProvider.autoDispose<String>(
  (ref) => '',
);
final businessNameProvider = StateProvider.autoDispose<String>(
  (ref) => '',
);
final whatsappNumberProvider = StateProvider.autoDispose<String>(
  (ref) => '',
);
final registerEmailProvider = StateProvider.autoDispose<String>(
  (ref) => '',
);
final registerPasswordProvider = StateProvider.autoDispose<String>(
  (ref) => '',
);

final forgotPasswordEmailProvider = StateProvider.autoDispose<String>(
  (ref) => '',
);

final addStoreStoreNameProvider = StateProvider.autoDispose<String>(
  (ref) => '',
);

final addStoreStoreTypeProvider = StateProvider.autoDispose<String?>(
  (ref) => null,
);
