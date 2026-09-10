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
    final settlements = summary?.recentSettlements ?? [];

    return div(
      classes: 'bg-white rounded-2xl border border-border-medium p-5 shadow-2xs space-y-4',
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
                  classes: 'text-sm sm:text-base font-bold text-slate-900',
                  [.text('Platform Fees')],
                ),
                p(
                  classes: 'text-xs text-slate-500 font-medium',
                  [.text('Customer platform fees remittance')],
                ),
              ]),
            ]),
            span(
              classes: 'px-2.5 py-0.5 rounded-full text-[10px] font-bold uppercase tracking-wider bg-blue-50 text-blue-700 border border-blue-200/80',
              [.text('1.99% fee')],
            ),
          ],
        ),
        _buildBalanceSection(unsettledPaise, unsettledRupees, isPaying),
        if (settlements.isNotEmpty)
          PlatformFeeSettlementHistory(settlements: settlements),
      ],
    );
  }

  Component _buildBalanceSection(
    int paise,
    String rupees,
    bool isPaying,
  ) {
    final hasDue = paise > 0;

    return div(
      classes:
          'p-4 rounded-xl border border-border-medium bg-neutral/20 space-y-3',
      [
        div(classes: 'flex items-center justify-between gap-2', [
          if (hasDue)
            span(
              classes: 'inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full text-[10px] font-bold uppercase tracking-wider bg-amber-50 text-amber-700 border border-amber-200/80',
              [
                span(classes: 'w-1.5 h-1.5 rounded-full bg-amber-500', []),
                .text('Payment Due'),
              ],
            )
          else
            span(
              classes: 'inline-flex items-center gap-1.5 px-2.5 py-0.5 rounded-full text-[10px] font-bold uppercase tracking-wider bg-emerald-50 text-emerald-700 border border-emerald-200',
              [
                Check(classes: 'w-3 h-3 text-emerald-600'),
                .text('All Settled'),
              ],
            ),
          span(
            classes: 'text-[11px] text-slate-400 font-medium',
            [.text(hasDue ? 'Auto-calculated' : 'Up to date')],
          ),
        ]),
        div([
          div(
            classes: 'text-3xl font-extrabold text-slate-900 tracking-tight',
            [.text('₹$rupees')],
          ),
          p(
            classes: 'text-xs text-slate-500 font-medium mt-1',
            [
              .text(
                hasDue
                    ? 'Collected across all your stores pending remittance.'
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
                'btn btn-primary w-full h-10 px-4 rounded-xl text-xs font-bold transition-all flex items-center justify-center gap-2 cursor-pointer shadow-xs active:scale-[0.99] ${isPaying ? 'opacity-70 cursor-not-allowed' : ''}',
            events: {'click': (_) => PlatformFeeActions.payPlatformFees()},
            [
              if (isPaying)
                span(classes: 'loading loading-spinner loading-xs', [])
              else
                CreditCard(classes: 'w-3.5 h-3.5 text-slate-300'),
              .text(isPaying ? 'Redirecting...' : 'Pay Platform Fees'),
            ],
          ),
      ],
    );
  }
}
