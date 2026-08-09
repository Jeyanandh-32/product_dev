import 'package:client_repositories/client_repositories.dart';
import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide Store;
import 'package:merchant/components/fields/form_field.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/signals/auth_signal.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:merchant/signals/toast_signal.dart';
import 'package:signals/signals.dart';
import 'package:validators/validators.dart';
import 'package:web/web.dart' hide Lock;

class Account extends SignalComponent {
  const Account({super.key});

  @override
  SignalState<Account> createState() => _AccountState();
}

class _AccountState extends SignalState<Account> {
  late String _name;
  late String _businessName;
  late String _whatsappNumber;
  late String _email;

  String _currentPassword = '';
  String _newPassword = '';
  String _confirmPassword = '';

  bool _waNotifications = true;
  bool _lowStockAlerts = true;
  bool _dailyReports = true;

  @override
  void initState() {
    super.initState();
    _initMerchantFields();
    _fetchNotificationSettings();
  }

  void _initMerchantFields() {
    final merchant = authSignal.value.value;
    _name = merchant?.name ?? 'Merchant Owner';
    _businessName = merchant?.businessName ?? 'Retail & POS Enterprise';
    _whatsappNumber = merchant?.whatsappNumber ?? '+91 98765 43210';
    _email = merchant?.email ?? 'merchant@store.com';
  }

  Future<void> _fetchNotificationSettings() async {
    final settings = await MerchantSettingsRepository.getSettings();
    if (settings != null) {
      setState(() {
        _waNotifications = settings.waNotifications;
        _lowStockAlerts = settings.lowStockAlerts;
        _dailyReports = settings.dailyReports;
      });
    }
  }

  Future<void> _updateNotificationSettings({
    bool? waNotifications,
    bool? lowStockAlerts,
    bool? dailyReports,
  }) async {
    try {
      final updatedSettings = await MerchantSettingsRepository.updateSettings(
        waNotifications: waNotifications,
        lowStockAlerts: lowStockAlerts,
        dailyReports: dailyReports,
      );
      setState(() {
        _waNotifications = updatedSettings.waNotifications;
        _lowStockAlerts = updatedSettings.lowStockAlerts;
        _dailyReports = updatedSettings.dailyReports;
      });
      showToast('Notification preferences saved.', type: ToastType.success);
    } catch (err) {
      showToast(
        err is ApiException ? err.message : 'Failed to update preferences.',
      );
    }
  }

  String _getInitials(String name) {
    if (name.trim().isEmpty) return 'M';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }

  Future<void> _onSaveProfile(Event e) async {
    e.preventDefault();
    (document.activeElement as HTMLElement?)?.blur();
    try {
      final updatedMerchant = await MerchantRepository.updateMerchant(
        name: _name,
        businessName: _businessName,
        whatsappNumber: _whatsappNumber,
        email: _email,
      );
      authSignal.value = AsyncData(updatedMerchant);
      (e.target as HTMLFormElement?)?.reset();
      showToast(
        'Profile information updated successfully.',
        type: ToastType.success,
      );
    } catch (err) {
      showToast(
        err is ApiException ? err.message : 'Failed to update profile.',
      );
    }
  }

  Future<void> _onUpdatePassword(Event e) async {
    e.preventDefault();
    (document.activeElement as HTMLElement?)?.blur();
    if (_currentPassword.isEmpty) {
      showToast('Please enter your current password.');
      return;
    }
    if (_newPassword.isEmpty) {
      showToast('Please enter a new password.');
      return;
    }
    if (!RegExp(ValidationPatterns.password).hasMatch(_newPassword)) {
      showToast(
        'Password must be 6+ characters with a number, lowercase & uppercase.',
      );
      return;
    }
    if (_newPassword != _confirmPassword) {
      showToast('New passwords do not match.');
      return;
    }
    try {
      final updatedMerchant = await MerchantRepository.updateMerchant(
        currentPassword: _currentPassword,
        newPassword: _newPassword,
      );
      authSignal.value = AsyncData(updatedMerchant);
      (e.target as HTMLFormElement?)?.reset();
      showToast(
        'Security password updated successfully.',
        type: ToastType.success,
      );
      setState(() {
        _currentPassword = '';
        _newPassword = '';
        _confirmPassword = '';
      });
    } catch (err) {
      showToast(
        err is ApiException ? err.message : 'Failed to update password.',
      );
    }
  }

  @override
  Component buildSignal(BuildContext context) {
    final merchant = authSignal.value.value;
    final stores = storesSignal.value.value ?? [];
    final activeStoreCount = stores.where((st) => st.isActive).length;

    final displayName = merchant?.name ?? _name;
    final displayBusiness = merchant?.businessName ?? _businessName;
    final displayEmail = merchant?.email ?? _email;
    final displayWhatsapp = merchant?.whatsappNumber ?? _whatsappNumber;
    final initials = _getInitials(displayName);

    return div(
      classes:
          'flex-1 h-full overflow-y-auto bg-neutral/30 p-4 sm:p-5 space-y-4',
      [
        // Top Profile Banner
        div(
          classes:
              'w-full rounded-xl bg-white p-4.5 border border-border-medium shadow-2xs',
          [
            div(
              classes:
                  'flex flex-col md:flex-row items-start md:items-center justify-between gap-4',
              [
                // Avatar & Main Details
                div(classes: 'flex items-center gap-4', [
                  div(
                    classes:
                        'relative w-14 h-14 rounded-lg bg-primary text-primary-content text-lg font-bold flex items-center justify-center border border-border-medium shrink-0',
                    [
                      .text(initials),
                      div(
                        classes:
                            'absolute -bottom-1 -right-1 p-0.5 bg-emerald-500 rounded-full text-white shadow-2xs border border-white',
                        attributes: {'title': 'Verified Account'},
                        [
                          BadgeCheck(classes: 'w-3.5 h-3.5'),
                        ],
                      ),
                    ],
                  ),

                  div(classes: 'space-y-0.5 min-w-0', [
                    div(classes: 'flex items-center gap-2 flex-wrap', [
                      h2(
                        classes:
                            'text-base sm:text-lg font-bold tracking-tight truncate text-primary',
                        [.text(displayName)],
                      ),
                      span(
                        classes:
                            'px-2 py-0.5 rounded text-[11px] font-bold uppercase tracking-wider bg-emerald-50 text-emerald-700 border border-emerald-200',
                        [.text('Active Account')],
                      ),
                    ]),

                    p(
                      classes:
                          'text-xs sm:text-sm font-semibold text-gray-500 flex items-center gap-1.5 truncate',
                      [
                        Building2(
                          classes: 'w-3.5 h-3.5 text-gray-400 shrink-0',
                        ),
                        .text(displayBusiness),
                      ],
                    ),

                    div(
                      classes:
                          'flex items-center gap-3.5 text-xs sm:text-sm text-gray-500 pt-0.5 flex-wrap font-medium',
                      [
                        span(classes: 'flex items-center gap-1', [
                          Mail(classes: 'w-3.5 h-3.5 text-gray-400'),
                          .text(displayEmail),
                        ]),
                        span(classes: 'flex items-center gap-1', [
                          Phone(classes: 'w-3.5 h-3.5 text-emerald-600'),
                          .text(displayWhatsapp),
                        ]),
                      ],
                    ),
                  ]),
                ]),

                // Metrics Badges
                div(
                  classes:
                      'flex items-center gap-3 w-full md:w-auto justify-between md:justify-end border-t md:border-t-0 border-border-light pt-3 md:pt-0',
                  [
                    div(
                      classes:
                          'px-4 py-2 rounded-lg bg-neutral/40 border border-border-light text-center',
                      [
                        p(
                          classes: 'text-xs text-gray-500 font-semibold',
                          [.text('Active Stores')],
                        ),
                        p(
                          classes: 'text-base font-bold text-primary',
                          [.text('$activeStoreCount')],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),

        // Main Grid Layout
        div(classes: 'grid grid-cols-1 lg:grid-cols-3 gap-4', [
          // Left Column (2 Cols): Personal Details & Security
          div(classes: 'lg:col-span-2 space-y-4', [
            // Card 1: Merchant Information
            div(
              classes:
                  'bg-white rounded-xl border border-border-medium p-5 shadow-2xs space-y-4',
              [
                div(
                  classes:
                      'flex items-center justify-between border-b border-border-light pb-3',
                  [
                    div(classes: 'flex items-center gap-2.5', [
                      div(
                        classes:
                            'p-2 bg-neutral text-primary rounded-lg border border-border-medium',
                        [
                          User(classes: 'w-4 h-4'),
                        ],
                      ),
                      div([
                        h3(
                          classes:
                              'text-sm sm:text-base font-bold text-gray-900',
                          [.text('Merchant Information')],
                        ),
                        p(
                          classes: 'text-xs text-gray-500 font-medium',
                          [.text('Update account owner & business details')],
                        ),
                      ]),
                    ]),
                  ],
                ),

                form(
                  events: {'submit': (e) => _onSaveProfile(e)},
                  classes: 'space-y-3.5',
                  [
                    div(
                      classes: 'grid grid-cols-1 sm:grid-cols-2 gap-3.5',
                      [
                        FormField(
                          id: 'account_name',
                          labelText: 'Full Name',
                          type: .text,
                          icon: User(classes: 'w-4.5 h-4.5'),
                          onChange: (val) => _name = val as String,
                          attributes: {
                            'placeholder': 'Merchant Owner',
                            'required': '',
                            'value': _name,
                          },
                        ),
                        FormField(
                          id: 'account_businessName',
                          labelText: 'Business / Trading Name',
                          type: .text,
                          icon: Building2(classes: 'w-4.5 h-4.5'),
                          onChange: (val) => _businessName = val as String,
                          attributes: {
                            'placeholder': 'Retail & POS Enterprise',
                            'required': '',
                            'value': _businessName,
                          },
                        ),
                      ],
                    ),

                    div(
                      classes: 'grid grid-cols-1 sm:grid-cols-2 gap-3.5',
                      [
                        FormField(
                          id: 'account_email',
                          labelText: 'Email Address',
                          type: .email,
                          icon: Mail(classes: 'w-4.5 h-4.5'),
                          onChange: (val) => _email = val as String,
                          attributes: {
                            'placeholder': 'merchant@store.com',
                            'required': '',
                            'value': _email,
                          },
                        ),
                        FormField(
                          id: 'account_whatsapp',
                          labelText: 'WhatsApp Number',
                          type: .tel,
                          icon: Phone(classes: 'w-4.5 h-4.5'),
                          onChange: (val) => _whatsappNumber = val as String,
                          attributes: {
                            'placeholder': '9876543210',
                            'required': '',
                            'pattern': ValidationPatterns.whatsapp,
                            'value': _whatsappNumber,
                          },
                          hintText: '10 digit mobile number.',
                        ),
                      ],
                    ),

                    div(classes: 'flex justify-end pt-1', [
                      button(
                        type: .submit,
                        classes:
                            'px-4 py-2.5 bg-primary text-primary-content hover:bg-opacity-90 active:scale-95 font-bold text-xs sm:text-sm rounded-lg shadow-2xs transition-all flex items-center gap-1.5 hover:cursor-pointer',
                        [
                          Save(classes: 'w-4 h-4'),
                          .text('Save Profile Changes'),
                        ],
                      ),
                    ]),
                  ],
                ),
              ],
            ),

            // Card 2: Security & Credentials
            div(
              classes:
                  'bg-white rounded-xl border border-border-medium p-5 shadow-2xs space-y-4',
              [
                div(
                  classes:
                      'flex items-center justify-between border-b border-border-light pb-3',
                  [
                    div(classes: 'flex items-center gap-2.5', [
                      div(
                        classes:
                            'p-2 bg-neutral text-primary rounded-lg border border-border-medium',
                        [
                          ShieldCheck(classes: 'w-4 h-4'),
                        ],
                      ),
                      div([
                        h3(
                          classes:
                              'text-sm sm:text-base font-bold text-gray-900',
                          [.text('Security & Credentials')],
                        ),
                        p(
                          classes: 'text-xs text-gray-500 font-medium',
                          [.text('Manage password & account security')],
                        ),
                      ]),
                    ]),
                  ],
                ),

                form(
                  events: {'submit': (e) => _onUpdatePassword(e)},
                  classes: 'space-y-3.5',
                  [
                    FormField(
                      id: 'account_currentPassword',
                      labelText: 'Current Password',
                      type: .password,
                      icon: Lock(classes: 'w-4.5 h-4.5'),
                      onChange: (val) => setState(
                        () => _currentPassword = val as String,
                      ),
                      attributes: {
                        'placeholder': '••••••••',
                        'value': _currentPassword,
                      },
                    ),

                    div(
                      classes: 'grid grid-cols-1 sm:grid-cols-2 gap-3.5',
                      [
                        FormField(
                          id: 'account_newPassword',
                          labelText: 'New Password',
                          type: .password,
                          icon: KeyRound(classes: 'w-4.5 h-4.5'),
                          onChange: (val) =>
                              setState(() => _newPassword = val as String),
                          attributes: {
                            'placeholder': '*********',
                            'value': _newPassword,
                          },
                          hintText:
                              'Must be 6+ characters with a number, lowercase, and uppercase.',
                        ),
                        FormField(
                          id: 'account_confirmPassword',
                          labelText: 'Confirm New Password',
                          type: .password,
                          icon: KeyRound(classes: 'w-4.5 h-4.5'),
                          onChange: (val) => setState(
                            () => _confirmPassword = val as String,
                          ),
                          attributes: {
                            'placeholder': '*********',
                            'value': _confirmPassword,
                          },
                          hintText: 'Re-enter same password.',
                        ),
                      ],
                    ),

                    div(classes: 'flex justify-end pt-1', [
                      button(
                        type: .submit,
                        classes:
                            'px-4 py-2.5 bg-primary text-primary-content hover:bg-opacity-90 active:scale-95 font-bold text-xs sm:text-sm rounded-lg shadow-2xs transition-all flex items-center gap-1.5 hover:cursor-pointer',
                        [
                          KeyRound(classes: 'w-4 h-4'),
                          .text('Update Password'),
                        ],
                      ),
                    ]),
                  ],
                ),
              ],
            ),
          ]),

          // Right Column (1 Col): Per-Store Subscriptions & Preferences
          div(classes: 'space-y-4', [
            // Card 3: Store Subscriptions
            div(
              classes:
                  'bg-white rounded-xl border border-border-medium p-5 shadow-2xs space-y-4',
              [
                div(
                  classes:
                      'flex items-center justify-between border-b border-border-light pb-3',
                  [
                    div(classes: 'flex items-center gap-2.5', [
                      div(
                        classes:
                            'p-2 bg-neutral text-primary rounded-lg border border-border-medium',
                        [
                          CreditCard(classes: 'w-4 h-4'),
                        ],
                      ),
                      div([
                        h3(
                          classes:
                              'text-sm sm:text-base font-bold text-gray-900',
                          [.text('Store Subscriptions')],
                        ),
                        p(
                          classes: 'text-xs text-gray-500 font-medium',
                          [.text('Subscriptions managed per store')],
                        ),
                      ]),
                    ]),
                  ],
                ),

                if (stores.isEmpty)
                  p(
                    classes:
                        'text-xs sm:text-sm text-gray-400 font-medium text-center py-3',
                    [.text('No stores created yet.')],
                  )
                else
                  div(classes: 'space-y-3', [
                    for (final st in stores)
                      div(
                        classes:
                            'p-3.5 rounded-lg border border-border-medium bg-neutral/20 space-y-2.5',
                        [
                          div(
                            classes:
                                'flex items-center justify-between gap-2 flex-wrap',
                            [
                              h4(
                                classes:
                                    'text-xs sm:text-sm font-bold text-gray-900 truncate',
                                [.text(st.name)],
                              ),
                              span(
                                classes: st.isActive
                                    ? 'px-2 py-0.5 rounded text-[10px] font-bold uppercase tracking-wider bg-emerald-50 text-emerald-700 border border-emerald-200'
                                    : 'px-2 py-0.5 rounded text-[10px] font-bold uppercase tracking-wider bg-neutral text-gray-500 border border-border-medium',
                                [
                                  .text(
                                    st.isActive
                                        ? 'Active Store'
                                        : 'Inactive Store',
                                  ),
                                ],
                              ),
                            ],
                          ),

                          div(
                            classes:
                                'flex items-center justify-between text-xs font-semibold text-gray-600 pt-0.5',
                            [
                              span(
                                classes:
                                    'flex items-center gap-1 text-emerald-700 font-bold',
                                [
                                  CircleCheck(classes: 'w-3.5 h-3.5'),
                                  .text('Subscription Active'),
                                ],
                              ),
                              span(classes: 'text-gray-500 font-medium', [
                                .text('Renews Aug 2027'),
                              ]),
                            ],
                          ),

                          button(
                            type: .button,
                            classes:
                                'w-full py-2 px-3 bg-white hover:bg-neutral active:scale-98 text-gray-900 font-semibold text-xs sm:text-sm rounded-lg border border-border-medium transition-all flex items-center justify-center gap-1.5 hover:cursor-pointer',
                            events: {
                              'click': (e) => showToast(
                                'Subscription for "${st.name}" is active.',
                              ),
                            },
                            [
                              Sparkles(classes: 'w-3.5 h-3.5 text-primary'),
                              .text('Manage Subscription'),
                            ],
                          ),
                        ],
                      ),
                  ]),
              ],
            ),

            // Card 4: Notification Preferences
            div(
              classes:
                  'bg-white rounded-xl border border-border-medium p-5 shadow-2xs space-y-4',
              [
                div(
                  classes:
                      'flex items-center justify-between border-b border-border-light pb-3',
                  [
                    div(classes: 'flex items-center gap-2.5', [
                      div(
                        classes:
                            'p-2 bg-neutral text-primary rounded-lg border border-border-medium',
                        [
                          Bell(classes: 'w-4 h-4'),
                        ],
                      ),
                      div([
                        h3(
                          classes:
                              'text-sm sm:text-base font-bold text-gray-900',
                          [.text('Notification Settings')],
                        ),
                        p(
                          classes: 'text-xs text-gray-500 font-medium',
                          [.text('Configure alerts & summaries')],
                        ),
                      ]),
                    ]),
                  ],
                ),

                div(
                  classes:
                      'space-y-3 text-xs sm:text-sm font-medium text-gray-700',
                  [
                    // Toggle 1
                    div(classes: 'flex items-center justify-between gap-3', [
                      div([
                        p(
                          classes: 'font-bold text-gray-900 text-xs sm:text-sm',
                          [.text('WhatsApp Alerts')],
                        ),
                        p(
                          classes: 'text-xs text-gray-500',
                          [.text('Instant order receipts')],
                        ),
                      ]),
                      input(
                        type: InputType.checkbox,
                        classes: 'toggle toggle-primary hover:cursor-pointer',
                        checked: _waNotifications,
                        events: {
                          'change': (e) {
                            final target = e.target as HTMLInputElement;
                            setState(() {
                              _waNotifications = target.checked;
                            });
                            _updateNotificationSettings(
                              waNotifications: target.checked,
                            );
                          },
                        },
                      ),
                    ]),

                    // Toggle 2
                    div(classes: 'flex items-center justify-between gap-3', [
                      div([
                        p(
                          classes: 'font-bold text-gray-900 text-xs sm:text-sm',
                          [.text('Low Stock Alerts')],
                        ),
                        p(
                          classes: 'text-xs text-gray-500',
                          [.text('Whatsapp when inventory is low')],
                        ),
                      ]),
                      input(
                        type: InputType.checkbox,
                        classes: 'toggle toggle-primary hover:cursor-pointer',
                        checked: _lowStockAlerts,
                        events: {
                          'change': (e) {
                            final target = e.target as HTMLInputElement;
                            setState(() {
                              _lowStockAlerts = target.checked;
                            });
                            _updateNotificationSettings(
                              lowStockAlerts: target.checked,
                            );
                          },
                        },
                      ),
                    ]),

                    // Toggle 3
                    div(classes: 'flex items-center justify-between gap-3', [
                      div([
                        p(
                          classes: 'font-bold text-gray-900 text-xs sm:text-sm',
                          [.text('Daily Settlement')],
                        ),
                        p(
                          classes: 'text-xs text-gray-500',
                          [.text('End-of-day report')],
                        ),
                      ]),
                      input(
                        type: InputType.checkbox,
                        classes: 'toggle toggle-primary hover:cursor-pointer',
                        checked: _dailyReports,
                        events: {
                          'change': (e) {
                            final target = e.target as HTMLInputElement;
                            setState(() {
                              _dailyReports = target.checked;
                            });
                            _updateNotificationSettings(
                              dailyReports: target.checked,
                            );
                          },
                        },
                      ),
                    ]),
                  ],
                ),
              ],
            ),
          ]),
        ]),
      ],
    );
  }
}
