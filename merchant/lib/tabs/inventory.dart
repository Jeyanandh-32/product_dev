import 'package:jaspr/client.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:merchant/providers/ui_providers.dart';
import 'package:merchant/sub_tabs/categories.dart';
import 'package:merchant/sub_tabs/counters.dart';
import 'package:merchant/sub_tabs/products.dart';

class Inventory extends StatelessComponent {
  const Inventory({this.subIndex, super.key});

  final int? subIndex;

  @override
  Component build(BuildContext context) {
    final int activeSubIndex = subIndex ?? context.watch(subIndexProvider);
    final tabs = [Products(), Categories(), Counters()];

    return tabs[activeSubIndex];
  }
}
