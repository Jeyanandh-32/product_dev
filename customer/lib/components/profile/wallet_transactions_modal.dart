import 'package:change_case/change_case.dart';
import 'package:customer/components/modals/modal.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router;
import 'package:models/models.dart';

/// Modal dialog displaying history of wallet transactions or earned bottle return rewards.
class WalletTransactionsModal extends StatelessComponent {
  final List<CustomerWalletTransaction> transactions;
  final VoidCallback onClose;
  final bool isBottleReturnStore;

  const WalletTransactionsModal({
    super.key,
    required this.transactions,
    required this.onClose,
    this.isBottleReturnStore = false,
  });

  @override
  Component build(BuildContext context) {
    final title = isBottleReturnStore
        ? 'Reward & Activity History'
        : 'Wallet Transactions';
    final emptyText = isBottleReturnStore
        ? 'No reward activity yet.'
        : 'No wallet transactions yet.';

    return Modal(
      title: title,
      onClose: onClose,
      child: div(
        classes: 'flex flex-col gap-4 max-h-[60vh] overflow-y-auto pr-1',
        [
          if (transactions.isEmpty)
            div(
              classes: 'py-8 flex flex-col items-center justify-center gap-2 text-center text-gray-400',
              [
                History(classes: 'w-8 h-8 text-gray-300'),
                span(
                  classes: 'text-sm font-semibold',
                  [.text(emptyText)],
                ),
              ],
            )
          else
            div(classes: 'flex flex-col divide-y divide-gray-100', [
              for (final tx in transactions) _transactionRow(tx),
            ]),
        ],
      ),
    );
  }

  Component _transactionRow(CustomerWalletTransaction tx) {
    final isTopUp = tx.type == WalletTransactionType.topUp;
    final isRefund = tx.type == WalletTransactionType.refundCredit;
    final isPositive = isTopUp || isRefund;
    final amountRupees = tx.amount.toStringAsFixed(2);
    final dateFormatted = _formatTxDate(tx.createdAt);

    final isBottleReturn = tx.reference?.contains('Bottle Return') == true;
    final title = isBottleReturn
        ? (isRefund ? 'Bottle Return Reward' : 'Reward Redemption')
        : (isTopUp
              ? 'Wallet Top-Up'
              : (isRefund ? 'Refund Credit' : 'Order Payment'));

    final icon = isPositive
        ? Sparkles(classes: 'w-4 h-4 text-emerald-600')
        : ArrowUpRight(classes: 'w-4 h-4 text-gray-600');

    final iconBg = isPositive ? 'bg-emerald-50' : 'bg-gray-100';
    final amountColor = isPositive ? 'text-emerald-700' : 'text-black';
    final amountSign = isPositive ? '+' : '-';

    return div(
      classes: 'py-3.5 flex items-center justify-between gap-3',
      [
        div(classes: 'flex items-center gap-3', [
          div(
            classes:
                'w-9 h-9 rounded-xl flex items-center justify-center shrink-0 $iconBg',
            [icon],
          ),
          div(classes: 'flex flex-col gap-0.5', [
            span(
              classes: 'text-xs font-bold text-black',
              [.text(title)],
            ),
            if (tx.reference case final ref? when ref.isNotEmpty)
              span(
                classes: 'text-[11px] font-medium text-gray-500 font-mono tracking-tight',
                [.text(ref)],
              ),
            span(
              classes: 'text-[10px] text-gray-400 font-medium',
              [.text(dateFormatted)],
            ),
          ]),
        ]),

        div(classes: 'flex flex-col items-end gap-0.5', [
          span(
            classes:
                'text-sm font-extrabold $amountColor font-mono tracking-tight',
            [.text('$amountSign₹$amountRupees')],
          ),
          span(
            classes:
                'text-[10px] font-bold px-2 py-0.5 rounded-full ${tx.status == 'completed' ? 'bg-emerald-50 text-emerald-700' : 'bg-amber-50 text-amber-700'}',
            [.text(tx.status.toTitleCase())],
          ),
        ]),
      ],
    );
  }

  String _formatTxDate(DateTime dt) => AppDateFormatter.formatDate(dt);
}
