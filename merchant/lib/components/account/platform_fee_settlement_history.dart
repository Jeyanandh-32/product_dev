import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:models/models.dart';

/// Renders a list of recent platform fee settlement records.
class PlatformFeeSettlementHistory extends StatelessComponent {
  const PlatformFeeSettlementHistory({
    super.key,
    required this.settlements,
  });

  final List<PlatformFeeSettlement> settlements;

  @override
  Component build(BuildContext context) {
    return div(classes: 'pt-2 space-y-2', [
      h4(
        classes: 'text-xs font-bold text-gray-700 uppercase tracking-wider',
        [.text('Recent Settlements')],
      ),
      div(classes: 'space-y-1.5', [
        for (final s in settlements.take(5))
          div(
            classes: 'flex items-center justify-between p-2.5 rounded-lg border border-border-light bg-neutral/20 text-xs',
            [
              div([
                p(
                  classes: 'font-semibold text-gray-900',
                  [.text('₹${(s.amountInPaise / 100.0).toStringAsFixed(2)}')],
                ),
                p(
                  classes: 'text-gray-400 text-[11px]',
                  [.text('${s.ordersCount} orders settled')],
                ),
              ]),
              span(
                classes:
                    'px-2 py-0.5 rounded-full font-medium text-[11px] ${s.status == 'completed' ? 'bg-green-100 text-green-700' : 'bg-gray-100 text-gray-600'}',
                [.text(s.status.toUpperCase())],
              ),
            ],
          ),
      ]),
    ]);
  }
}
