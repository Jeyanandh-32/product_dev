import 'package:customer/components/profile/logout_action_card.dart';
import 'package:customer/components/profile/profile_forms_section.dart';
import 'package:customer/components/profile/profile_overview_card.dart';
import 'package:customer/components/profile/store_wallet_card.dart';
import 'package:customer/components/profile/top_up_modal.dart';
import 'package:customer/components/profile/wallet_transactions_modal.dart';
import 'package:customer/components/signal_component.dart';
import 'package:customer/signals/cart_signal.dart';
import 'package:customer/signals/customer_auth_signal.dart';
import 'package:customer/utils/customer_navigation.dart';
import 'package:customer/utils/customer_wallet_handler.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router, Store;
import 'package:models/models.dart';

/// Customer profile settings screen for managing personal info, PIN, wallet & rewards.
class CustomerProfilePage extends SignalComponent {
  const CustomerProfilePage({super.key});

  @override
  SignalState<CustomerProfilePage> createState() => _CustomerProfilePageState();
}

class _CustomerProfilePageState extends SignalState<CustomerProfilePage> {
  bool _isTransactionsModalOpen = false;
  bool _isTopUpModalOpen = false;
  bool _isTopUpLoading = false;
  double _topUpAmount = 100.0;
  double _storeWalletBalance = 0.0;
  List<CustomerWalletTransaction> _transactions = [];

  @override
  void initState() {
    super.initState();
    _loadWalletHistory();
  }

  Future<void> _loadWalletHistory() async {
    final result = await CustomerWalletHandler.loadWalletHistory();
    if (mounted) {
      setState(() {
        _transactions = result.transactions;
        _storeWalletBalance = result.balance;
      });
    }
  }

  Future<void> _handleTopUp() async {
    await CustomerWalletHandler.initiateTopUp(
      amount: _topUpAmount,
      onModalClose: () => setState(() => _isTopUpModalOpen = false),
      setLoading: (loading) => setState(() => _isTopUpLoading = loading),
      onCompleted: _loadWalletHistory,
    );
  }

  @override
  Component buildSignal(BuildContext context) {
    final customer = customerAuthSignal.value.value;

    if (customer == null) {
      return div(
        classes: 'flex flex-col items-center justify-center min-h-[50vh] gap-3 text-center',
        [span(classes: 'loading loading-spinner loading-lg text-black', [])],
      );
    }

    return div(classes: 'flex flex-col gap-6 max-w-2xl w-full mx-auto pb-12', [
      div(classes: 'flex items-center gap-3', [
        button(
          classes:
              'w-9 h-9 rounded-full bg-gray-100 hover:bg-gray-200 text-gray-700 flex items-center justify-center cursor-pointer border-0 transition-all active:scale-95 shrink-0',
          onClick: () => navigateToRecentStoreOrAll(context),
          [ArrowLeft(classes: 'w-5 h-5')],
        ),
        h1(
          classes: 'text-2xl sm:text-3xl font-extrabold text-black tracking-tight',
          [.text('Profile')],
        ),
      ]),

      ProfileOverviewCard(customer: customer),

      StoreWalletCard(
        currentStore: currentCartStoreSignal.value,
        storeId: currentCartStoreIdSignal.value,
        walletBalance: _storeWalletBalance,
        onAddMoney: () => setState(() => _isTopUpModalOpen = true),
        onViewTransactions: () => setState(() => _isTransactionsModalOpen = true),
      ),

      ProfileFormsSection(customer: customer),
      const LogoutActionCard(),

      if (_isTopUpModalOpen)
        TopUpModal(
          topUpAmount: _topUpAmount,
          isLoading: _isTopUpLoading,
          onAmountChanged: (amt) => setState(() => _topUpAmount = amt),
          onConfirm: _handleTopUp,
          onClose: () => setState(() => _isTopUpModalOpen = false),
        ),

      if (_isTransactionsModalOpen)
        WalletTransactionsModal(
          transactions: _transactions,
          onClose: () => setState(() => _isTransactionsModalOpen = false),
        ),
    ]);
  }
}
