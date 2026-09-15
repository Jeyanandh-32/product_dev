import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List;
import 'package:models/models.dart';

/// Renders a list of recent platform fee settlement records.
class PlatformFeeSettlementHistory extends StatelessComponent {
  const PlatformFeeSettlementHistory({
    super.key,
    required this.settlements,
  });

  final List<PlatformFeeSettlement> settlements;

  String _formatDate(DateTime? dt) => AppDateFormatter.formatDate(dt);

  @override
  Component build(BuildContext context) {
    return div(classes: 'pt-1 space-y-2.5', [
      div(classes: 'flex items-center justify-between', [
        h4(
          classes:
              'text-[11px] font-bold text-slate-700 uppercase tracking-wider',
          [.text('Recent Settlements')],
        ),
        span(
          classes: 'text-[10px] text-slate-400 font-medium',
          [.text('Past remittances')],
        ),
      ]),
      div(
        classes: 'overflow-hidden rounded-xl border border-border-medium bg-neutral/10 divide-y divide-border-light text-xs',
        [
          for (final s in settlements.take(5)) _buildSettlementRow(s),
        ],
      ),
    ]);
  }

  Component _buildSettlementRow(PlatformFeeSettlement s) {
    final dateStr = _formatDate(s.settledAt ?? s.createdAt);
    final isCompleted = s.status.toLowerCase() == 'completed';
    final badgeStyle = isCompleted
        ? 'bg-emerald-50 text-emerald-700 border-emerald-200'
        : 'bg-slate-100 text-slate-600 border-slate-200';

    return div(
      classes: 'flex items-center justify-between p-2.5',
      [
        div(classes: 'flex items-center gap-2.5', [
          div(
            classes: 'w-6 h-6 rounded-lg bg-emerald-50 border border-emerald-200/60 flex items-center justify-center shrink-0',
            [Check(classes: 'w-3.5 h-3.5 text-emerald-600')],
          ),
          div([
            p(
              classes: 'font-bold text-slate-900 text-xs',
              [.text('₹${(s.amountInPaise / 100.0).toStringAsFixed(2)}')],
            ),
            p(
              classes: 'text-slate-400 text-[10px]',
              [
                .text(
                  '${s.ordersCount} orders${dateStr.isNotEmpty ? ' · $dateStr' : ''}',
                ),
              ],
            ),
          ]),
        ]),
        span(
          classes:
              'px-2 py-0.5 rounded-full text-[10px] font-bold uppercase tracking-wider border $badgeStyle',
          [.text(isCompleted ? 'Completed' : s.status.toUpperCase())],
        ),
      ],
    );
  }
}
