import 'package:backend/models/terminal/terminal_dto.dart';
import 'package:models/models.dart';

extension TerminalDtoExtension on TerminalDto {
  Terminal toTerminal() => Terminal(
    code: code,
    merchantId: merchantId,
    storeId: storeId,
    name: name,
    isActive: isActive,
    createdAt: createdAt,
    updatedAt: updatedAt,
  );
}
