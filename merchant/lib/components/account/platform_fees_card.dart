import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Store, Map;
import 'package:merchant/components/account/platform_fee_settlement_history.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/signals/platform_fee_signal.dart';

/// Card displaying merchant platform fee balance, explanation, and remittance button.
class PlatformFeesCard extends SignalComponent {
  const PlatformFeesCard({super.key});

  @override
  SignalState<PlatformFeesCard> createState() => _PlatformFeesCardState();
}

class _PlatformFeesCardState extends SignalState<PlatformFeesCard> {
  @override
  void initState() {
    super.initState();
    PlatformFeeActions.fetchSummary(silent: true);
  }

  @override
  Component buildSignal(BuildContext context) {
    final summaryAsync = platformFeeSummarySignal.value;
    final isPaying = isPayingPlatformFeeSignal.value;
    final summary = summaryAsync.value;

    final unsettledPaise = summary?.unsettledAmountInPaise ?? 0;
    final unsettledRupees = (unsettledPaise / 100.0).toStringAsFixed(2);
    final count = summary?.unsettledOrdersCount ?? 0;
    final settlements = summary?.recentSettlements ?? [];

    return div(
      classes: 'bg-white rounded-xl border border-border-medium p-5 shadow-2xs space-y-4',
      [
        div(
          classes: 'flex items-center justify-between border-b border-border-light pb-3',
          [
            div(classes: 'flex items-center gap-2.5', [
              div(
                classes: 'p-2 bg-neutral text-primary rounded-lg border border-border-medium',
                [Receipt(classes: 'w-4 h-4')],
              ),
              div([
                h3(
                  classes: 'text-sm sm:text-base font-bold text-gray-900',
                  [.text('Platform Fees & Invoices')],
                ),
                p(
                  classes: 'text-xs text-gray-500 font-medium',
                  [
                    .text(
                      'Customer platform fees collected across all your stores',
                    ),
                  ],
                ),
              ]),
            ]),
          ],
        ),
        _buildBalanceSection(unsettledPaise, unsettledRupees, count, isPaying),
        if (settlements.isNotEmpty)
          PlatformFeeSettlementHistory(settlements: settlements),
      ],
    );
  }

  Component _buildBalanceSection(
    int paise,
    String rupees,
    int count,
    bool isPaying,
  ) {
    final hasDue = paise > 0;

    return div(
      classes:
          'p-4 rounded-xl border ${hasDue ? 'bg-amber-50/50 border-amber-200/60' : 'bg-green-50/50 border-green-200/60'} flex flex-col sm:flex-row sm:items-center justify-between gap-4',
      [
        div(classes: 'space-y-1', [
          div(classes: 'flex items-center gap-2', [
            span(
              classes:
                  'text-xs font-semibold uppercase tracking-wider ${hasDue ? 'text-amber-800' : 'text-green-800'}',
              [.text(hasDue ? 'Unsettled Platform Fees' : 'All Settled')],
            ),
            if (!hasDue) Check(classes: 'w-4 h-4 text-green-600'),
          ]),
          div(
            classes:
                'text-2xl sm:text-3xl font-bold tracking-tight ${hasDue ? 'text-amber-950' : 'text-green-950'}',
            [.text('₹$rupees')],
          ),
          p(
            classes: 'text-xs text-gray-500 font-medium',
            [
              .text(
                hasDue
                    ? 'Collected from $count online customer orders on your behalf.'
                    : 'Zero outstanding platform fees pending remittance.',
              ),
            ],
          ),
        ]),
        if (hasDue)
          button(
            type: ButtonType.button,
            disabled: isPaying,
            classes:
                'btn btn-primary px-5 py-2.5 rounded-lg text-xs font-bold transition flex items-center justify-center gap-2 cursor-pointer shadow-xs ${isPaying ? 'opacity-70 cursor-not-allowed' : ''}',
            events: {'click': (_) => PlatformFeeActions.payPlatformFees()},
            [
              if (isPaying)
                span(classes: 'loading loading-spinner loading-xs', [])
              else
                CreditCard(classes: 'w-4 h-4'),
              .text(isPaying ? 'Redirecting...' : 'Pay Platform Fees'),
            ],
          ),
      ],
    );
  }
}
