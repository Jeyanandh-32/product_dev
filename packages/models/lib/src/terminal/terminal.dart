import 'package:freezed_annotation/freezed_annotation.dart';

part 'terminal.freezed.dart';

part 'terminal.g.dart';

/// Represents a physical POS terminal registered to a merchant store.
@freezed
abstract class Terminal with _$Terminal {
  /// Creates a [Terminal] instance.
  const factory Terminal({
    required String code,
    required String merchantId,
    required String storeId,
    required String name,
    required bool isActive,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Terminal;

  /// Creates a [Terminal] from a JSON map.
  factory Terminal.fromJson(Map<String, Object?> json) =>
      _$TerminalFromJson(json);
}
