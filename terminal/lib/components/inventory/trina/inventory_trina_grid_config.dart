import 'package:flutter/widgets.dart';
import 'package:trina_grid/trina_grid.dart';

/// Style configuration for Inventory TrinaGrid matching DaisyUI table styling.
class InventoryTrinaGridConfig {
  const InventoryTrinaGridConfig._();

  static TrinaGridConfiguration build() {
    return const TrinaGridConfiguration(
      style: TrinaGridStyleConfig(
        gridBackgroundColor: Color(0xFFFFFFFF),
        rowHeight: 56,
        columnHeight: 44,
        defaultCellPadding: EdgeInsets.symmetric(horizontal: 16),
        defaultColumnTitlePadding: EdgeInsets.symmetric(horizontal: 16),
        columnTextStyle: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          color: Color(0xFF475569),
        ),
        cellTextStyle: TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w400,
          color: Color(0xFF0F172A),
        ),
        gridBorderColor: Color(0x00000000),
        borderColor: Color(0xFFF1F5F9),
        oddRowColor: Color(0xFFF8FAFC),
        evenRowColor: Color(0xFFFFFFFF),
        activatedColor: Color(0xFFF1F5F9),
        gridBorderRadius: BorderRadius.zero,
        enableColumnBorderVertical: false,
        enableCellBorderVertical: false,
        enableRowColorAnimation: true,
      ),
      columnSize: TrinaGridColumnSizeConfig(
        autoSizeMode: TrinaAutoSizeMode.none,
        resizeMode: TrinaResizeMode.none,
      ),
      scrollbar: TrinaGridScrollbarConfig(
        isAlwaysShown: true,
      ),
    );
  }
}
