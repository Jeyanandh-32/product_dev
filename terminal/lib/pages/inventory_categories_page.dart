import 'package:flutter/widgets.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:terminal/components/components.dart';
import 'package:mix/mix.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/signals/categories_signal.dart';

/// Read-only inventory categories overview page using Forui.
class InventoryCategoriesPage extends SignalWidget {
  const InventoryCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = categoriesSignal.value.value ?? [];

    return FScaffold(
      childPad: false,
      header: FHeader.nested(
        title: const Text('Inventory Categories'),
        prefixes: const [
          TerminalBackButton(),
        ],
      ),
      child: categories.isEmpty
          ? Center(
              child: StyledText(
                'No categories defined',
                style: TextStyler().fontSize(14).color(const Color(0xFF6B7280)),
              ),
            )
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: categories.length,
              separatorBuilder: (context, index) => const Gap(8),
              itemBuilder: (context, index) {
                final category = categories[index];
                return Box(
                  style: BoxStyler()
                      .paddingAll(14)
                      .color(const Color(0xFFFFFFFF))
                      .borderRadiusAll(const Radius.circular(12))
                      .borderAll(color: const Color(0xFFE5E7EB)),
                  child: StyledText(
                    category.name,
                    style: TextStyler()
                        .fontSize(14)
                        .fontWeight(.w700)
                        .color(const Color(0xFF000000)),
                  ),
                );
              },
            ),
    );
  }
}
