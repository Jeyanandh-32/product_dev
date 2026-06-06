import 'package:jaspr_riverpod/legacy.dart';

final loginEmailProvider = StateProvider<String>(
  (ref) => '',
);

final loginPasswordProvider = StateProvider<String>(
  (ref) => '',
);

final fullNameProvider = StateProvider(
  (ref) => '',
);
final businessNameProvider = StateProvider(
  (ref) => '',
);
final whatsappNumberProvider = StateProvider(
  (ref) => '',
);
final registerEmailProvider = StateProvider(
  (ref) => '',
);
final registerPasswordProvider = StateProvider(
  (ref) => '',
);

final forgotPasswordEmailProvider = StateProvider(
  (ref) => '',
);
