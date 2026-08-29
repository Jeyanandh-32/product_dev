import 'package:client_repositories/client_repositories.dart';
import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:merchant/components/account/account_banner.dart';
import 'package:merchant/components/account/account_side_column.dart';
import 'package:merchant/components/account/merchant_profile_security_section.dart';
import 'package:merchant/components/modals/subscription/manage_subscription_modal.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/signals/auth_signal.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:merchant/signals/subscription_signal.dart';
import 'package:merchant/utils/merchant_account_handler.dart';
import 'package:web/web.dart' hide Lock;

/// Account settings tab displaying merchant profile, security, and notification settings.
class Account extends SignalComponent {
  const Account({super.key});

  @override
  SignalState<Account> createState() => _AccountState();
}

class _AccountState extends SignalState<Account> {
  String _name = 'Merchant Owner';
  String _businessName = 'Retail & POS Enterprise';
  String _whatsappNumber = '+91 98765 43210';
  String _email = 'merchant@store.com';
  String _currentPassword = '', _newPassword = '', _confirmPassword = '';
  bool _waNotifications = true, _lowStockAlerts = true, _dailyReports = true;

  @override
  void initState() {
    super.initState();
    final merchant = authSignal.value.value;
    if (merchant != null) {
      _name = merchant.name;
      _businessName = merchant.businessName;
      _whatsappNumber = merchant.whatsappNumber;
      _email = merchant.email;
    }
    _fetchNotificationSettings();
    final stores = storesSignal.value.value ?? [];
    if (stores.isNotEmpty) SubscriptionActions.fetchSubscriptionsForStores(stores);
  }

  Future<void> _fetchNotificationSettings() async {
    final s = await MerchantSettingsRepository.getSettings();
    if (s != null) {
      setState(() {
        _waNotifications = s.waNotifications;
        _lowStockAlerts = s.lowStockAlerts;
        _dailyReports = s.dailyReports;
      });
    }
  }

  Future<void> _onSaveProfile(Event e) async {
    e.preventDefault();
    (document.activeElement as HTMLElement?)?.blur();
    await MerchantAccountHandler.saveProfile(
      name: _name, businessName: _businessName, whatsappNumber: _whatsappNumber, email: _email,
    );
  }

  Future<void> _onUpdatePassword(Event e) async {
    e.preventDefault();
    (document.activeElement as HTMLElement?)?.blur();
    final success = await MerchantAccountHandler.updatePassword(
      currentPassword: _currentPassword, newPassword: _newPassword, confirmPassword: _confirmPassword,
    );
    if (success) {
      setState(() {
        _currentPassword = '';
        _newPassword = '';
        _confirmPassword = '';
      });
    }
  }

  Future<void> _onNotificationSettingChanged({
    bool? waNotifications, bool? lowStockAlerts, bool? dailyReports,
  }) async {
    final u = await MerchantAccountHandler.updateNotifications(
      waNotifications: waNotifications, lowStockAlerts: lowStockAlerts, dailyReports: dailyReports,
    );
    if (u != null) {
      setState(() {
        _waNotifications = u.waNotifications;
        _lowStockAlerts = u.lowStockAlerts;
        _dailyReports = u.dailyReports;
      });
    }
  }

  @override
  Component buildSignal(BuildContext context) {
    final merchant = authSignal.value.value;
    final stores = storesSignal.value.value ?? [];
    final activeStoreCount = stores.where((st) => st.isActive).length;

    final unLoaded = stores.where((st) => !subscriptionsSignal.value.containsKey(st.id)).toList();
    if (unLoaded.isNotEmpty) {
      Future.microtask(() => SubscriptionActions.fetchSubscriptionsForStores(unLoaded));
    }

    final displayName = merchant?.name ?? _name;
    final displayBusiness = merchant?.businessName ?? _businessName;
    final displayEmail = merchant?.email ?? _email;
    final displayWhatsapp = merchant?.whatsappNumber ?? _whatsappNumber;
    final initials = MerchantAccountHandler.getInitials(displayName);

    return div(
      classes: 'flex-1 h-full overflow-y-auto bg-neutral/30 p-4 space-y-4',
      [
        AccountBanner(
          displayName: displayName, displayBusiness: displayBusiness, displayEmail: displayEmail,
          displayWhatsapp: displayWhatsapp, initials: initials, activeStoreCount: activeStoreCount,
        ),
        div(classes: 'grid grid-cols-1 lg:grid-cols-3 gap-4', [
          MerchantProfileSecuritySection(
            name: _name, businessName: _businessName, email: _email, whatsappNumber: _whatsappNumber,
            onNameChanged: (v) => _name = v, onBusinessNameChanged: (v) => _businessName = v,
            onEmailChanged: (v) => _email = v, onWhatsappChanged: (v) => _whatsappNumber = v,
            onSaveProfile: _onSaveProfile, currentPassword: _currentPassword, newPassword: _newPassword,
            confirmPassword: _confirmPassword, onCurrentPasswordChanged: (v) => setState(() => _currentPassword = v),
            onNewPasswordChanged: (v) => setState(() => _newPassword = v),
            onConfirmPasswordChanged: (v) => setState(() => _confirmPassword = v),
            onUpdatePassword: _onUpdatePassword,
          ),
          AccountSideColumn(
            stores: stores, waNotifications: _waNotifications, lowStockAlerts: _lowStockAlerts,
            dailyReports: _dailyReports, onNotificationSettingChanged: _onNotificationSettingChanged,
          ),
        ]),
        if (activeSubscriptionModalStoreSignal.value != null)
          ManageSubscriptionModal(store: activeSubscriptionModalStoreSignal.value!),
      ],
    );
  }
}
