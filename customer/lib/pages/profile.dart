import 'package:customer/components/profile/logout_action_card.dart';
import 'package:customer/components/profile/profile_forms_section.dart';
import 'package:customer/components/profile/profile_overview_card.dart';
import 'package:customer/components/profile/profile_wallet_modals.dart';
import 'package:customer/components/profile/store_wallet_card.dart';
import 'package:customer/components/signal_component.dart';
import 'package:customer/signals/cart_signal.dart';
import 'package:customer/signals/customer_auth_signal.dart';
import 'package:customer/utils/customer_navigation.dart';
import 'package:customer/utils/customer_wallet_handler.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router, Store;
import 'package:models/models.dart';

/// Customer profile settings screen for managing personal info, contact, PIN, and store wallet.
class CustomerProfilePage extends SignalComponent {
  const CustomerProfilePage({super.key});

  @override
  SignalState<CustomerProfilePage> createState() =>
      _CustomerProfilePageState();
}

class _CustomerProfilePageState extends SignalState<CustomerProfilePage> {
  bool _isTopUpModalOpen = false;
  bool _isTransactionsModalOpen = false;
  double _topUpAmount = 500.0;
  bool _isTopUpLoading = false;
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
      onModalClose: () {
        if (mounted) setState(() => _isTopUpModalOpen = false);
      },
      setLoading: (isLoading) {
        if (mounted) setState(() => _isTopUpLoading = isLoading);
      },
      onCompleted: _loadWalletHistory,
    );
  }

  @override
  Component buildSignal(BuildContext context) {
    final customer = customerAuthSignal.value.value;

    if (customer == null) {
      return div(
        classes:
            'flex flex-col items-center justify-center min-h-[50vh] gap-3 text-center',
        [
          span(classes: 'loading loading-spinner loading-lg text-black', []),
        ],
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
          classes:
              'text-2xl sm:text-3xl font-extrabold text-black tracking-tight',
          [.text('Profile')],
        ),
      ]),

      ProfileOverviewCard(customer: customer),

      StoreWalletCard(
        currentStore: currentCartStoreSignal.value,
        storeId: currentCartStoreIdSignal.value,
        walletBalance: _storeWalletBalance,
        onAddMoney: () => setState(() => _isTopUpModalOpen = true),
        onViewTransactions: () =>
            setState(() => _isTransactionsModalOpen = true),
      ),

      ProfileFormsSection(customer: customer),

      const LogoutActionCard(),

      ProfileWalletModals(
        isTopUpModalOpen: _isTopUpModalOpen,
        isTransactionsModalOpen: _isTransactionsModalOpen,
        topUpAmount: _topUpAmount,
        isTopUpLoading: _isTopUpLoading,
        transactions: _transactions,
        onAmountChanged: (amount) => setState(() => _topUpAmount = amount),
        onCloseTopUp: () => setState(() => _isTopUpModalOpen = false),
        onProceedTopUp: _handleTopUp,
        onCloseTransactions: () =>
            setState(() => _isTransactionsModalOpen = false),
      ),
    ]);
  }
}
