import 'package:backend/enums/user_role.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'token_payload.g.dart';

@JsonSerializable(includeIfNull: false)
class TokenPayload {
  const TokenPayload({
    required this.sub,
    required this.role,
    this.terminalCode,
  });

  factory TokenPayload.fromJson(Map<String, Object?> json) =>
      _$TokenPayloadFromJson(json);

  Map<String, Object?> toJson() => _$TokenPayloadToJson(this);

  final String sub;
  final UserRole role;
  final String? terminalCode;
}
