import 'package:jaspr/client.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/providers/ui_providers.dart';
import 'package:merchant/sub_tabs/credits.dart';
import 'package:merchant/sub_tabs/orders.dart';
import 'package:merchant/sub_tabs/payments.dart';
import 'package:merchant/sub_tabs/profit_loss.dart';
import 'package:merchant/sub_tabs/stock_summary.dart';

class Reports extends SignalComponent {
  const Reports({super.key});

  @override
  SignalState<Reports> createState() => _ReportsState();
}

class _ReportsState extends SignalState<Reports> {
  @override
  Component buildSignal(BuildContext context) {
    final subIndex = subIndexSignal.value;

    final tabs = [
      const Orders(),
      const Payments(),
      const Credits(),
      const ProfitLoss(),
      const StockSummary(),
    ];

    return tabs[subIndex];
  }
}
