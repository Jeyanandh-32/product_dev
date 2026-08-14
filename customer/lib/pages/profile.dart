import 'package:client_repositories/client_repositories.dart';
import 'package:customer/components/modals/modal.dart';
import 'package:customer/components/signal_component.dart';
import 'package:customer/signals/cart_signal.dart';
import 'package:customer/signals/customer_auth_signal.dart';
import 'package:customer/signals/toast_signal.dart';
import 'package:customer/utils/phonepe_interop.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router, Store;
import 'package:jaspr_router/jaspr_router.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';
import 'package:web/web.dart' as web;

class CustomerProfilePage extends SignalComponent {
  const CustomerProfilePage({super.key});

  @override
  SignalState<CustomerProfilePage> createState() => _CustomerProfilePageState();
}

class _CustomerProfilePageState extends SignalState<CustomerProfilePage> {
  // Form State
  String _name = '';
  String _mobileNumber = '';
  String _mobilePin = '';
  String _currentPin = '';
  String _newPin = '';
  String _confirmPin = '';

  bool _isEditingName = false;
  bool _isEditingMobile = false;
  bool _isEditingPin = false;

  bool _isSavingName = false;
  bool _isSavingMobile = false;
  bool _isSavingPin = false;

  String? _nameError;
  String? _mobileError;
  String? _pinError;

  // Wallet State
  bool _isTopUpModalOpen = false;
  bool _isTransactionsModalOpen = false;
  double _topUpAmount = 500.0;
  bool _isTopUpLoading = false;
  double _storeWalletBalance = 0.0;
  List<CustomerWalletTransaction> _transactions = [];

  @override
  void initState() {
    super.initState();
    final customer = customerAuthSignal.value.value;
    if (customer != null) {
      _name = customer.name;
      _mobileNumber = customer.mobileNumber;
    }
    _loadWalletHistory();
  }

  Future<void> _loadWalletHistory() async {
    final storeId = currentCartStoreIdSignal.value;
    if (storeId == null) return;
    try {
      final res = await CustomerWalletRepository.getWalletInfo(storeId: storeId);
      if (mounted) {
        setState(() {
          _transactions = res.transactions;
          _storeWalletBalance = res.balance;
        });

        // Sync customer wallet balance directly into customerAuthSignal
        final currentCustomer = customerAuthSignal.value.value;
        if (currentCustomer != null && currentCustomer.walletBalance != res.balance) {
          customerAuthSignal.value = AsyncData(
            currentCustomer.copyWith(walletBalance: res.balance),
          );
        }
      }
    } catch (_) {}
  }

  Future<void> _handleTopUp() async {
    final storeId = currentCartStoreIdSignal.value;
    if (_topUpAmount <= 0 || storeId == null) return;
    setState(() => _isTopUpLoading = true);
    try {
      final res = await CustomerWalletRepository.topUp(_topUpAmount, storeId: storeId);

      if (res.tokenUrl != null && res.merchantOrderId != null) {
        setState(() => _isTopUpModalOpen = false);

        openPhonePeCheckoutModal(
          tokenUrl: res.tokenUrl!,
          merchantOrderId: res.merchantOrderId!,
          onComplete: (status) async {
            setState(() => _isTopUpLoading = false);
            final initialBalance = _storeWalletBalance;
            await _loadWalletHistory();
            final updatedBalance = _storeWalletBalance;

            if (status == 'CONCLUDED' && updatedBalance > initialBalance) {
              showCustomerToast('Wallet topped up successfully!', type: ToastType.success);
            } else if (status == 'CONCLUDED') {
              showCustomerToast('Top-up payment processing or failed.', type: ToastType.warning);
            } else {
              showCustomerToast('Top-up payment was cancelled.', type: ToastType.warning);
            }
          },
        );
        return;
      }

      if (res.balance != null) {
        setState(() => _storeWalletBalance = res.balance!);
        final currentCustomer = customerAuthSignal.value.value;
        if (currentCustomer != null) {
          customerAuthSignal.value = AsyncData(
            currentCustomer.copyWith(walletBalance: res.balance!),
          );
        }
      }

      setState(() {
        _isTopUpLoading = false;
        _isTopUpModalOpen = false;
      });
      showCustomerToast('Wallet topped up successfully!', type: ToastType.success);
      _loadWalletHistory();
    } catch (e) {
      setState(() => _isTopUpLoading = false);
      showCustomerToast(e.toString(), type: ToastType.error);
    }
  }

  Future<void> _handleSaveName() async {
    final nameTrimmed = _name.trim();
    if (nameTrimmed.isEmpty) {
      setState(() => _nameError = 'Name cannot be empty.');
      return;
    }

    setState(() {
      _nameError = null;
      _isSavingName = true;
    });

    final success = await updateCustomerProfile(name: nameTrimmed);

    if (mounted) {
      setState(() {
        _isSavingName = false;
        if (success) {
          _isEditingName = false;
        }
      });
    }
  }

  Future<void> _handleSaveMobile() async {
    final mobileTrimmed = _mobileNumber.trim();
    final phoneRegex = RegExp(r'^\+?[0-9]{10,15}$');
    if (!phoneRegex.hasMatch(mobileTrimmed)) {
      setState(() => _mobileError = 'Enter a valid 10-digit mobile number.');
      return;
    }

    if (_mobilePin.isEmpty) {
      setState(() => _mobileError = 'Security PIN is required to change mobile number.');
      return;
    }

    setState(() {
      _mobileError = null;
      _isSavingMobile = true;
    });

    final success = await updateCustomerProfile(
      mobileNumber: mobileTrimmed,
      currentPin: _mobilePin,
    );

    if (mounted) {
      setState(() {
        _isSavingMobile = false;
        if (success) {
          _isEditingMobile = false;
          _mobilePin = '';
        }
      });
    }
  }

  Future<void> _handleSavePin() async {
    if (_currentPin.isEmpty) {
      setState(() => _pinError = 'Current PIN is required.');
      return;
    }

    final pinRegex = RegExp(r'^\d{6}$');
    if (!pinRegex.hasMatch(_newPin)) {
      setState(() => _pinError = 'New PIN must be exactly 6 digits.');
      return;
    }

    if (_newPin != _confirmPin) {
      setState(() => _pinError = 'New PIN and confirm PIN do not match.');
      return;
    }

    setState(() {
      _pinError = null;
      _isSavingPin = true;
    });

    final success = await updateCustomerProfile(
      currentPin: _currentPin,
      pin: _newPin,
    );

    if (mounted) {
      setState(() {
        _isSavingPin = false;
        if (success) {
          _isEditingPin = false;
          _currentPin = '';
          _newPin = '';
          _confirmPin = '';
        }
      });
    }
  }

  @override
  Component buildSignal(BuildContext context) {
    final customer = customerAuthSignal.value.value;

    if (customer == null) {
      return div(
        classes: 'flex flex-col items-center justify-center min-h-[50vh] gap-3 text-center',
        [
          span(classes: 'loading loading-spinner loading-lg text-black', []),
        ],
      );
    }

    final initialChar = customer.name.isNotEmpty ? customer.name[0].toUpperCase() : 'C';

    return div(classes: 'flex flex-col gap-6 max-w-2xl w-full mx-auto pb-12', [
      // Top Navigation / Header
      div(classes: 'flex items-center gap-3', [
        button(
          classes:
              'w-9 h-9 rounded-full bg-gray-100 hover:bg-gray-200 text-gray-700 flex items-center justify-center cursor-pointer border-0 transition-all active:scale-95 shrink-0',
          onClick: () {
            if (web.window.history.length > 1) {
              web.window.history.back();
            } else if (currentCartStoreSignal.value?.slug != null) {
              Router.of(context).push('/store/${currentCartStoreSignal.value!.slug!}');
            } else {
              Router.of(context).push('/?all=true');
            }
          },
          [
            ArrowLeft(classes: 'w-5 h-5'),
          ],
        ),
        h1(classes: 'text-2xl sm:text-3xl font-extrabold text-black tracking-tight', [
          .text('Profile'),
        ]),
      ]),

      // Profile Overview Card
      div(
        classes:
            'bg-white rounded-3xl border border-gray-200/90 p-6 sm:p-8 shadow-xs flex flex-col sm:flex-row items-center sm:items-start gap-5',
        [
          // Avatar Pill
          div(
            classes:
              'w-20 h-20 rounded-full bg-gray-900 text-white font-black text-2xl flex items-center justify-center shrink-0 shadow-md border-4 border-gray-100',
            [
              .text(initialChar),
            ],
          ),

          div(classes: 'flex flex-col gap-1 text-center sm:text-left flex-1', [
            h2(classes: 'text-2xl font-black text-black tracking-tight', [
              .text(customer.name),
            ]),
            div(classes: 'flex flex-wrap items-center justify-center sm:justify-start gap-2.5 mt-1', [
              div(
                classes:
                    'inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-gray-100 text-gray-700 font-semibold text-xs border border-gray-200/80',
                [
                  Phone(classes: 'w-3.5 h-3.5 text-gray-500'),
                  .text(customer.mobileNumber),
                ],
              ),
              div(
                classes:
                    'inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-emerald-50 text-emerald-700 font-semibold text-xs border border-emerald-200/60',
                [
                  ShieldCheck(classes: 'w-3.5 h-3.5 text-emerald-600'),
                  .text('Verified Customer'),
                ],
              ),
            ]),
          ]),
        ],
      ),

      // Customer Store Wallet Card
      div(
        classes:
            'bg-white rounded-3xl border border-gray-200/90 p-6 sm:p-8 shadow-xs flex flex-col gap-6',
        [
          div(classes: 'flex items-center justify-between border-b border-gray-100 pb-4', [
            div(classes: 'flex items-center gap-2.5', [
              Wallet(classes: 'w-5 h-5 text-gray-700'),
              h3(classes: 'text-base font-extrabold text-black', [
                .text('Store Wallet'),
              ]),
            ]),
            if (currentCartStoreSignal.value != null)
              span(
                classes:
                    'text-xs font-bold px-3 py-1 rounded-full bg-emerald-50 text-emerald-700 border border-emerald-200',
                [.text(currentCartStoreSignal.value!.name)],
              ),
          ]),

          if (currentCartStoreIdSignal.value != null)
            div(
              classes:
                  'flex flex-col sm:flex-row sm:items-center justify-between gap-4 pt-1',
              [
                div(classes: 'flex items-baseline gap-1', [
                  span(classes: 'text-lg font-bold text-emerald-600', [.text('₹')]),
                  span(classes: 'text-2xl sm:text-3xl font-extrabold text-black tracking-tight', [
                    .text(_storeWalletBalance.toStringAsFixed(2)),
                  ]),
                ]),

                div(classes: 'flex items-center gap-2.5', [
                  button(
                    classes:
                        'flex-1 sm:flex-none justify-center flex items-center gap-1.5 px-4 py-2.5 rounded-2xl bg-black hover:bg-gray-800 text-white font-bold text-xs transition-all border-0 cursor-pointer shadow-xs active:scale-95',
                    onClick: () => setState(() => _isTopUpModalOpen = true),
                    [
                      Plus(classes: 'w-4 h-4 text-white'),
                      .text('Add Money'),
                    ],
                  ),
                  button(
                    classes:
                        'flex-1 sm:flex-none justify-center flex items-center gap-1.5 px-4 py-2.5 rounded-2xl bg-gray-100 hover:bg-gray-200 text-gray-700 font-bold text-xs transition-all border-0 cursor-pointer active:scale-95',
                    onClick: () => setState(() => _isTransactionsModalOpen = true),
                    [
                      History(classes: 'w-4 h-4 text-gray-600'),
                      .text('Transactions'),
                    ],
                  ),
                ]),
              ],
            )
          else
            div(
              classes:
                  'flex flex-col items-center justify-center py-6 text-center gap-3',
              [
                div(
                  classes: 'w-12 h-12 rounded-2xl bg-gray-50 flex items-center justify-center text-gray-400',
                  [Building2(classes: 'w-6 h-6')],
                ),
                div(classes: 'flex flex-col gap-1', [
                  p(classes: 'text-sm font-extrabold text-black', [.text('No Store Selected')]),
                  p(classes: 'text-xs text-gray-500 max-w-sm', [
                    .text('Each store maintains an independent wallet. Visit a store menu or scan a table QR to access and top up that store\'s wallet.'),
                  ]),
                ]),
                a(
                  href: '/',
                  classes:
                      'mt-2 inline-flex items-center gap-1.5 px-4 py-2 rounded-xl bg-black text-white font-bold text-xs hover:bg-gray-800 transition-all no-underline',
                  [
                    ShoppingBag(classes: 'w-3.5 h-3.5 text-white'),
                    .text('Explore Stores'),
                  ],
                ),
              ],
            ),
        ],
      ),

      // Top Up Modal
      if (_isTopUpModalOpen)
        Modal(
          title: 'Top Up Wallet',
          onClose: () => setState(() => _isTopUpModalOpen = false),
          child: div(classes: 'flex flex-col gap-6', [
            div(classes: 'flex flex-col gap-4', [
              label(classes: 'text-xs font-bold text-gray-700 uppercase tracking-wider', [
                .text('Select Amount (₹)'),
              ]),
              div(classes: 'grid grid-cols-3 gap-2.5', [
                for (final amt in [100.0, 500.0, 1000.0])
                  button(
                    classes:
                        'py-3 rounded-2xl font-bold text-sm border cursor-pointer transition-all ${amt == _topUpAmount ? 'bg-black text-white border-black shadow-xs' : 'bg-gray-50 text-gray-800 border-gray-200 hover:bg-gray-100'}',
                    onClick: () => setState(() => _topUpAmount = amt),
                    [.text('₹${amt.toInt()}')],
                  ),
              ]),

              div(classes: 'flex flex-col gap-1.5 pt-2', [
                label(classes: 'text-xs font-bold text-gray-700 uppercase tracking-wider', [
                  .text('Custom Amount (₹)'),
                ]),
                input(
                  type: InputType.number,
                  classes:
                      'w-full px-4 py-3 rounded-2xl border border-gray-300 focus:border-black focus:outline-hidden text-base font-bold text-black bg-gray-50/50 font-mono',
                  value: _topUpAmount.toInt().toString(),
                  events: {
                    'input': (e) {
                      final input = e.target as web.HTMLInputElement;
                      final parsed = double.tryParse(input.value);
                      if (parsed != null && parsed > 0) {
                        setState(() => _topUpAmount = parsed);
                      }
                    },
                  },
                ),
              ]),
            ]),

            div(classes: 'flex items-center justify-end gap-2 pt-2 border-t border-gray-100', [
              button(
                classes:
                    'px-4 py-2.5 rounded-xl bg-gray-100 hover:bg-gray-200 text-gray-700 font-bold text-xs transition-all border-0 cursor-pointer',
                onClick: () => setState(() => _isTopUpModalOpen = false),
                [.text('Cancel')],
              ),
              button(
                classes:
                    'px-6 py-2.5 rounded-xl bg-emerald-600 text-white hover:bg-emerald-500 font-bold text-xs transition-all border-0 cursor-pointer shadow-xs flex items-center gap-2',
                onClick: _isTopUpLoading ? null : _handleTopUp,
                [
                  if (_isTopUpLoading)
                    span(classes: 'loading loading-spinner loading-xs text-white', [])
                  else
                    Check(classes: 'w-4 h-4 text-white'),
                  .text(_isTopUpLoading ? 'Processing...' : 'Confirm Top Up'),
                ],
              ),
            ]),
          ]),
        ),

      // Wallet Transactions Modal
      if (_isTransactionsModalOpen)
        Modal(
          title: 'Wallet Transactions History',
          onClose: () => setState(() => _isTransactionsModalOpen = false),
          child: div(classes: 'flex flex-col gap-4 max-h-[60vh] overflow-y-auto pr-1', [
            if (_transactions.isEmpty)
              div(
                classes: 'py-8 flex flex-col items-center justify-center gap-2 text-center text-gray-400',
                [
                  History(classes: 'w-8 h-8 text-gray-300'),
                  span(classes: 'text-sm font-semibold', [.text('No wallet activity yet.')]),
                ],
              )
            else
              div(classes: 'flex flex-col divide-y divide-gray-100', [
                for (final tx in _transactions)
                  () {
                    final isCredit = tx.type == WalletTransactionType.topUp ||
                        tx.type == WalletTransactionType.refundCredit;
                    final title = switch (tx.type) {
                      WalletTransactionType.topUp => 'Wallet Top Up',
                      WalletTransactionType.refundCredit => 'Order Refund',
                      WalletTransactionType.orderDebit => 'Order Payment',
                    };

                    return div(classes: 'flex items-center justify-between py-3 text-xs', [
                      div(classes: 'flex items-center gap-3', [
                        div(
                          classes:
                              'w-8 h-8 rounded-full flex items-center justify-center ${isCredit ? 'bg-emerald-50 text-emerald-600' : 'bg-rose-50 text-rose-600'}',
                          [
                            if (tx.type == WalletTransactionType.topUp)
                              Plus(classes: 'w-4 h-4')
                            else if (tx.type == WalletTransactionType.refundCredit)
                              RotateCcw(classes: 'w-3.5 h-3.5')
                            else
                              ArrowUpRight(classes: 'w-4 h-4'),
                          ],
                        ),
                        div(classes: 'flex flex-col gap-0.5', [
                          span(classes: 'font-bold text-gray-900 text-xs', [
                            .text(title),
                          ]),
                          if (tx.reference != null)
                            span(classes: 'font-mono text-[10px] text-gray-400', [
                              .text(tx.reference!),
                            ]),
                        ]),
                      ]),
                      div(classes: 'flex flex-col items-end gap-0.5', [
                        span(
                          classes:
                              'font-mono font-bold text-xs ${isCredit ? 'text-emerald-600' : 'text-rose-600'}',
                          [
                            .text(
                              '${isCredit ? '+' : '-'}₹${tx.amount.toStringAsFixed(2)}',
                            ),
                          ],
                        ),
                        span(classes: 'text-[10px] text-gray-400 font-semibold', [
                          .text(
                            '${tx.createdAt.day}/${tx.createdAt.month}/${tx.createdAt.year}',
                          ),
                        ]),
                      ]),
                    ]);
                  }(),
              ]),

            div(classes: 'flex justify-end pt-3 border-t border-gray-100', [
              button(
                classes:
                    'px-4 py-2 rounded-xl bg-gray-100 hover:bg-gray-200 text-gray-700 font-bold text-xs transition-all border-0 cursor-pointer',
                onClick: () => setState(() => _isTransactionsModalOpen = false),
                [.text('Close')],
              ),
            ]),
          ]),
        ),

      // Personal Details Edit Card
      div(
        classes:
            'bg-white rounded-3xl border border-gray-200/90 p-6 sm:p-8 shadow-xs flex flex-col gap-6',
        [
          div(classes: 'flex items-center justify-between border-b border-gray-100 pb-4', [
            div(classes: 'flex items-center gap-2.5', [
              User(classes: 'w-5 h-5 text-gray-700'),
              h3(classes: 'text-base font-extrabold text-black', [
                .text('Personal Information'),
              ]),
            ]),
            if (!_isEditingName)
              button(
                classes:
                    'flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-gray-100 hover:bg-black hover:text-white text-gray-700 font-bold text-xs transition-all border-0 cursor-pointer active:scale-95',
                onClick: () => setState(() => _isEditingName = true),
                [
                  Pencil(classes: 'w-3.5 h-3.5'),
                  .text('Edit Name'),
                ],
              ),
          ]),

          // Name Section Body
          if (_isEditingName)
            div(classes: 'flex flex-col gap-4 animate-in fade-in duration-150', [
              div(classes: 'flex flex-col gap-1.5', [
                label(classes: 'text-xs font-bold text-gray-700 uppercase tracking-wider', [
                  .text('Full Name'),
                ]),
                input(
                  type: InputType.text,
                  classes:
                      'w-full px-4 py-3 rounded-2xl border border-gray-300 focus:border-black focus:outline-hidden text-sm font-semibold text-black bg-gray-50/50 transition-all',
                  value: _name,
                  events: {
                    'input': (e) {
                      final input = e.target as web.HTMLInputElement;
                      _name = input.value;
                    },
                  },
                ),
                if (_nameError != null)
                  p(classes: 'text-xs text-red-600 font-semibold mt-0.5', [
                    .text(_nameError!),
                  ]),
              ]),

              div(classes: 'flex items-center justify-end gap-2 pt-2', [
                button(
                  classes:
                      'px-4 py-2 rounded-xl bg-gray-100 hover:bg-gray-200 text-gray-700 font-bold text-xs transition-all border-0 cursor-pointer',
                  onClick: () => setState(() {
                    _isEditingName = false;
                    _name = customer.name;
                    _nameError = null;
                  }),
                  [.text('Cancel')],
                ),
                button(
                  classes:
                      'px-5 py-2 rounded-xl bg-black text-white hover:bg-gray-800 font-bold text-xs transition-all border-0 cursor-pointer shadow-2xs flex items-center gap-1.5',
                  onClick: _isSavingName ? null : _handleSaveName,
                  [
                    if (_isSavingName)
                      span(classes: 'loading loading-spinner loading-xs text-white', [])
                    else
                      Check(classes: 'w-3.5 h-3.5 text-white'),
                    .text(_isSavingName ? 'Saving...' : 'Save Name'),
                  ],
                ),
              ]),
            ])
          else
            div(classes: 'flex flex-col gap-1', [
              span(classes: 'text-xs font-bold text-gray-400 uppercase tracking-wider', [
                .text('Full Name'),
              ]),
              span(classes: 'text-sm font-extrabold text-black', [
                .text(customer.name),
              ]),
            ]),
        ],
      ),

      // Mobile Number Edit Card
      div(
        classes:
            'bg-white rounded-3xl border border-gray-200/90 p-6 sm:p-8 shadow-xs flex flex-col gap-6',
        [
          div(classes: 'flex items-center justify-between border-b border-gray-100 pb-4', [
            div(classes: 'flex items-center gap-2.5', [
              Phone(classes: 'w-5 h-5 text-gray-700'),
              h3(classes: 'text-base font-extrabold text-black', [
                .text('Mobile Number'),
              ]),
            ]),
            if (!_isEditingMobile)
              button(
                classes:
                    'flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-gray-100 hover:bg-black hover:text-white text-gray-700 font-bold text-xs transition-all border-0 cursor-pointer active:scale-95',
                onClick: () => setState(() => _isEditingMobile = true),
                [
                  Pencil(classes: 'w-3.5 h-3.5'),
                  .text('Change Number'),
                ],
              ),
          ]),

          if (_isEditingMobile)
            div(classes: 'flex flex-col gap-4 animate-in fade-in duration-150', [
              div(classes: 'grid grid-cols-1 sm:grid-cols-2 gap-4', [
                div(classes: 'flex flex-col gap-1.5', [
                  label(classes: 'text-xs font-bold text-gray-700 uppercase tracking-wider', [
                    .text('New Mobile Number'),
                  ]),
                  input(
                    type: InputType.tel,
                    classes:
                        'w-full px-4 py-3 rounded-2xl border border-gray-300 focus:border-black focus:outline-hidden text-sm font-semibold text-black bg-gray-50/50 transition-all font-mono',
                    value: _mobileNumber,
                    events: {
                      'input': (e) {
                        final input = e.target as web.HTMLInputElement;
                        _mobileNumber = input.value;
                      },
                    },
                  ),
                ]),

                div(classes: 'flex flex-col gap-1.5', [
                  label(classes: 'text-xs font-bold text-gray-700 uppercase tracking-wider', [
                    .text('Current Security PIN'),
                  ]),
                  input(
                    type: InputType.password,
                    classes:
                        'w-full px-4 py-3 rounded-2xl border border-gray-300 focus:border-black focus:outline-hidden text-sm font-semibold text-black bg-gray-50/50 transition-all font-mono tracking-widest',
                    attributes: {'placeholder': '••••••', 'maxlength': '6'},
                    events: {
                      'input': (e) {
                        final input = e.target as web.HTMLInputElement;
                        _mobilePin = input.value;
                      },
                    },
                  ),
                ]),
              ]),

              if (_mobileError != null)
                p(classes: 'text-xs text-red-600 font-semibold mt-0.5', [
                  .text(_mobileError!),
                ]),

              div(classes: 'flex items-center justify-end gap-2 pt-2', [
                button(
                  classes:
                      'px-4 py-2 rounded-xl bg-gray-100 hover:bg-gray-200 text-gray-700 font-bold text-xs transition-all border-0 cursor-pointer',
                  onClick: () => setState(() {
                    _isEditingMobile = false;
                    _mobileNumber = customer.mobileNumber;
                    _mobilePin = '';
                    _mobileError = null;
                  }),
                  [.text('Cancel')],
                ),
                button(
                  classes:
                      'px-5 py-2 rounded-xl bg-black text-white hover:bg-gray-800 font-bold text-xs transition-all border-0 cursor-pointer shadow-2xs flex items-center gap-1.5',
                  onClick: _isSavingMobile ? null : _handleSaveMobile,
                  [
                    if (_isSavingMobile)
                      span(classes: 'loading loading-spinner loading-xs text-white', [])
                    else
                      Phone(classes: 'w-3.5 h-3.5 text-white'),
                    .text(_isSavingMobile ? 'Updating...' : 'Update Number'),
                  ],
                ),
              ]),
            ])
          else
            div(classes: 'flex items-center justify-between', [
              div(classes: 'flex flex-col gap-1', [
                span(classes: 'text-xs font-bold text-gray-400 uppercase tracking-wider', [
                  .text('Registered Mobile Number'),
                ]),
                span(classes: 'text-sm font-extrabold text-black font-mono', [
                  .text(customer.mobileNumber),
                ]),
              ]),
              div(
                classes:
                    'inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-emerald-50 text-emerald-700 font-semibold text-xs border border-emerald-200/60',
                [
                  ShieldCheck(classes: 'w-3.5 h-3.5 text-emerald-600'),
                  .text('Verified'),
                ],
              ),
            ]),
        ],
      ),

      // Security PIN Edit Card
      div(
        classes:
            'bg-white rounded-3xl border border-gray-200/90 p-6 sm:p-8 shadow-xs flex flex-col gap-6',
        [
          div(classes: 'flex items-center justify-between border-b border-gray-100 pb-4', [
            div(classes: 'flex items-center gap-2.5', [
              Lock(classes: 'w-5 h-5 text-gray-700'),
              h3(classes: 'text-base font-extrabold text-black', [
                .text('Security PIN'),
              ]),
            ]),
            if (!_isEditingPin)
              button(
                classes:
                    'flex items-center gap-1.5 px-3 py-1.5 rounded-xl bg-gray-100 hover:bg-black hover:text-white text-gray-700 font-bold text-xs transition-all border-0 cursor-pointer active:scale-95',
                onClick: () => setState(() => _isEditingPin = true),
                [
                  KeyRound(classes: 'w-3.5 h-3.5'),
                  .text('Change PIN'),
                ],
              ),
          ]),

          if (_isEditingPin)
            div(classes: 'flex flex-col gap-4 animate-in fade-in duration-150', [
              // Current PIN
              div(classes: 'flex flex-col gap-1.5', [
                label(classes: 'text-xs font-bold text-gray-700 uppercase tracking-wider', [
                  .text('Current Security PIN'),
                ]),
                input(
                  type: InputType.password,
                  classes:
                      'w-full px-4 py-3 rounded-2xl border border-gray-300 focus:border-black focus:outline-hidden text-sm font-semibold text-black bg-gray-50/50 transition-all font-mono tracking-widest',
                  attributes: {'placeholder': '••••••', 'maxlength': '6'},
                  events: {
                    'input': (e) {
                      final input = e.target as web.HTMLInputElement;
                      _currentPin = input.value;
                    },
                  },
                ),
              ]),

              // New PIN
              div(classes: 'grid grid-cols-1 sm:grid-cols-2 gap-4', [
                div(classes: 'flex flex-col gap-1.5', [
                  label(classes: 'text-xs font-bold text-gray-700 uppercase tracking-wider', [
                    .text('New 6-Digit PIN'),
                  ]),
                  input(
                    type: InputType.password,
                    classes:
                        'w-full px-4 py-3 rounded-2xl border border-gray-300 focus:border-black focus:outline-hidden text-sm font-semibold text-black bg-gray-50/50 transition-all font-mono tracking-widest',
                    attributes: {'placeholder': '••••••', 'maxlength': '6'},
                    events: {
                      'input': (e) {
                        final input = e.target as web.HTMLInputElement;
                        _newPin = input.value;
                      },
                    },
                  ),
                ]),

                div(classes: 'flex flex-col gap-1.5', [
                  label(classes: 'text-xs font-bold text-gray-700 uppercase tracking-wider', [
                    .text('Confirm New PIN'),
                  ]),
                  input(
                    type: InputType.password,
                    classes:
                        'w-full px-4 py-3 rounded-2xl border border-gray-300 focus:border-black focus:outline-hidden text-sm font-semibold text-black bg-gray-50/50 transition-all font-mono tracking-widest',
                    attributes: {'placeholder': '••••••', 'maxlength': '6'},
                    events: {
                      'input': (e) {
                        final input = e.target as web.HTMLInputElement;
                        _confirmPin = input.value;
                      },
                    },
                  ),
                ]),
              ]),

              if (_pinError != null)
                p(classes: 'text-xs text-red-600 font-semibold mt-0.5', [
                  .text(_pinError!),
                ]),

              div(classes: 'flex items-center justify-end gap-2 pt-2', [
                button(
                  classes:
                      'px-4 py-2 rounded-xl bg-gray-100 hover:bg-gray-200 text-gray-700 font-bold text-xs transition-all border-0 cursor-pointer',
                  onClick: () => setState(() {
                    _isEditingPin = false;
                    _currentPin = '';
                    _newPin = '';
                    _confirmPin = '';
                    _pinError = null;
                  }),
                  [.text('Cancel')],
                ),
                button(
                  classes:
                      'px-5 py-2 rounded-xl bg-black text-white hover:bg-gray-800 font-bold text-xs transition-all border-0 cursor-pointer shadow-2xs flex items-center gap-1.5',
                  onClick: _isSavingPin ? null : _handleSavePin,
                  [
                    if (_isSavingPin)
                      span(classes: 'loading loading-spinner loading-xs text-white', [])
                    else
                      Lock(classes: 'w-3.5 h-3.5 text-white'),
                    .text(_isSavingPin ? 'Updating...' : 'Update PIN'),
                  ],
                ),
              ]),
            ])
          else
            div(classes: 'flex flex-col gap-1', [
              span(classes: 'text-xs font-bold text-gray-400 uppercase tracking-wider', [
                .text('Security PIN Status'),
              ]),
              span(classes: 'text-sm font-extrabold text-black font-mono tracking-widest', [
                .text('••••••'),
              ]),
            ]),
        ],
      ),

      // Logout Account Action Card
      div(
        classes:
            'bg-gray-50 rounded-3xl border border-gray-200/80 p-6 flex items-center justify-between gap-4',
        [
          div(classes: 'flex flex-col gap-0.5', [
            span(classes: 'text-sm font-extrabold text-black', [
              .text('Sign out of your account'),
            ]),
            span(classes: 'text-xs text-gray-500 font-medium', [
              .text('You can sign back in anytime using your mobile number & PIN.'),
            ]),
          ]),
          button(
            classes:
                'px-4 py-2.5 rounded-2xl bg-red-50 hover:bg-red-600 text-red-600 hover:text-white font-bold text-xs transition-all border border-red-200/80 cursor-pointer flex items-center gap-1.5 active:scale-95 shrink-0',
            onClick: logoutCustomer,
            [
              LogOut(classes: 'w-4 h-4'),
              .text('Logout'),
            ],
          ),
        ],
      ),
    ]);
  }
}
