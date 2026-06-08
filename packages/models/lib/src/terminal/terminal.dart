import 'package:freezed_annotation/freezed_annotation.dart';

part 'terminal.freezed.dart';

part 'terminal.g.dart';

@freezed
abstract class Terminal with _$Terminal {
  const factory Terminal({
    required String code,
    required String merchantId,
    required String storeId,
    required String name,
    required bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Terminal;

  factory Terminal.fromJson(Map<String, Object?> json) => _$TerminalFromJson(json);
}
