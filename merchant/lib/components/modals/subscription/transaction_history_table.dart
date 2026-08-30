import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List;
import 'package:models/models.dart';

/// Table displaying past billing transactions for a store.
class TransactionHistoryTable extends StatelessComponent {
  const TransactionHistoryTable({
    super.key,
    required this.transactions,
  });

  final List<SubscriptionTransaction> transactions;

  @override
  Component build(BuildContext context) {
    if (transactions.isEmpty) {
      return div(
        classes: 'text-center py-4 text-xs text-gray-400 font-medium',
        [.text('No transaction history yet.')],
      );
    }

    return div(classes: 'space-y-2', [
      h4(
        classes: 'text-xs font-bold uppercase tracking-wider text-gray-500',
        [.text('Payment History')],
      ),
      div(
        classes: 'overflow-hidden rounded-lg border border-border-medium bg-white text-xs',
        [
          for (final tx in transactions)
            div(
              classes: 'flex items-center justify-between p-2.5 border-b border-border-light last:border-b-0',
              [
                div(classes: 'flex items-center gap-2.5', [
                  CircleCheck(
                    classes: 'w-4 h-4 text-emerald-600 shrink-0',
                  ),
                  div(classes: 'flex flex-col', [
                    div(classes: 'flex items-center gap-1.5', [
                      span(classes: 'font-bold text-gray-800 text-xs', [
                        .text(
                          '₹${(tx.amountInPaise / 100).toStringAsFixed(0)}',
                        ),
                      ]),
                      span(classes: 'text-[11px] text-gray-500 capitalize', [
                        .text('• ${tx.planCode.name}'),
                      ]),
                    ]),
                    span(classes: 'text-[10px] text-gray-400', [
                      .text(
                        tx.createdAt != null
                            ? '${tx.createdAt?.day.toString().padLeft(2, '0')}/${tx.createdAt?.month.toString().padLeft(2, '0')}/${tx.createdAt?.year}'
                            : '',
                      ),
                    ]),
                  ]),
                ]),
                span(
                  classes: 'text-[10px] font-bold uppercase px-1.5 py-0.5 rounded bg-emerald-50 text-emerald-700',
                  [.text(tx.status.name)],
                ),
              ],
            ),
        ],
      ),
    ]);
  }
}
