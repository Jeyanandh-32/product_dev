import 'package:freezed_annotation/freezed_annotation.dart';

import '../merchant/merchant.dart';
import '../store/store.dart';
import '../subscription/store_subscription.dart';
import 'terminal.dart';

part 'terminal_account.freezed.dart';
part 'terminal_account.g.dart';

/// Aggregated account, store, and merchant metadata for an authenticated terminal device.
@freezed
abstract class TerminalAccount with _$TerminalAccount {
  const factory TerminalAccount({
    required Terminal terminal,
    Store? store,
    Merchant? merchant,
    StoreSubscription? subscription,
  }) = _TerminalAccount;

  factory TerminalAccount.fromJson(Map<String, Object?> json) =>
      _$TerminalAccountFromJson(json);
}
