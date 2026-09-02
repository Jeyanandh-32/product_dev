import 'package:customer/components/profile/top_up_modal.dart';
import 'package:customer/components/profile/wallet_transactions_modal.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:models/models.dart';

/// Overlay modals container for wallet top-up and transaction history dialogs.
class ProfileWalletModals extends StatelessComponent {
  final bool isTopUpModalOpen;
  final bool isTransactionsModalOpen;
  final double topUpAmount;
  final bool isTopUpLoading;
  final List<CustomerWalletTransaction> transactions;
  final bool isBottleReturnStore;
  final ValueChanged<double> onAmountChanged;
  final VoidCallback onCloseTopUp;
  final VoidCallback onProceedTopUp;
  final VoidCallback onCloseTransactions;

  const ProfileWalletModals({
    super.key,
    required this.isTopUpModalOpen,
    required this.isTransactionsModalOpen,
    required this.topUpAmount,
    required this.isTopUpLoading,
    required this.transactions,
    this.isBottleReturnStore = false,
    required this.onAmountChanged,
    required this.onCloseTopUp,
    required this.onProceedTopUp,
    required this.onCloseTransactions,
  });

  @override
  Component build(BuildContext context) {
    return div([
      if (isTopUpModalOpen)
        TopUpModal(
          topUpAmount: topUpAmount,
          isLoading: isTopUpLoading,
          onAmountChanged: onAmountChanged,
          onClose: onCloseTopUp,
          onConfirm: onProceedTopUp,
        ),
      if (isTransactionsModalOpen)
        WalletTransactionsModal(
          transactions: transactions,
          isBottleReturnStore: isBottleReturnStore,
          onClose: onCloseTransactions,
        ),
    ]);
  }
}
