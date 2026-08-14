import 'package:customer/components/signal_component.dart';
import 'package:customer/signals/customer_auth_signal.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router;
import 'package:jaspr_router/jaspr_router.dart';
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

  @override
  void initState() {
    super.initState();
    final customer = customerAuthSignal.value.value;
    if (customer != null) {
      _name = customer.name;
      _mobileNumber = customer.mobileNumber;
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
          onClick: () => Router.of(context).push('/'),
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
            div(classes: 'flex items-center justify-between', [
              div(classes: 'flex flex-col gap-1', [
                span(classes: 'text-xs font-bold text-gray-400 uppercase tracking-wider', [
                  .text('Security PIN Status'),
                ]),
                span(classes: 'text-sm font-extrabold text-black font-mono tracking-widest', [
                  .text('••••••'),
                ]),
              ]),
              span(classes: 'text-xs text-gray-500 font-medium', [
                .text('Protected'),
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
