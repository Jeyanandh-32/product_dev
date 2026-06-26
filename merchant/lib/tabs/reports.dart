import 'package:jaspr/client.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:merchant/providers/ui_providers.dart';
import 'package:merchant/sub_tabs/credits.dart';
import 'package:merchant/sub_tabs/orders.dart';
import 'package:merchant/sub_tabs/payments.dart';
import 'package:merchant/sub_tabs/profit_loss.dart';
import 'package:merchant/sub_tabs/stock_summary.dart';

class Reports extends StatelessComponent {
  const Reports({super.key});

  @override
  Component build(BuildContext context) {
    final subIndex = context.watch(subIndexProvider);

    final tabs = [
      Orders(),
      Payments(),
      Credits(),
      ProfitLoss(),
      StockSummary(),
    ];

    return tabs[subIndex];
  }
}
