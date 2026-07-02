import 'package:backend/database/schema.dart';
import 'package:models/models.dart';

extension TerminalRowExtension on TerminalRow {
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
