import 'package:client_repositories/client_repositories.dart';
import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:merchant/components/account/account_banner.dart';
import 'package:merchant/components/account/merchant_info_card.dart';
import 'package:merchant/components/account/notification_settings_card.dart';
import 'package:merchant/components/account/security_credentials_card.dart';
import 'package:merchant/components/account/store_subscriptions_card.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/signals/auth_signal.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:merchant/signals/toast_signal.dart';
import 'package:merchant/utils/merchant_account_handler.dart';
import 'package:web/web.dart' hide Lock;

/// Account settings tab displaying merchant profile, security, and notification settings.
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
    await MerchantAccountHandler.saveProfile(
      name: _name,
      businessName: _businessName,
      whatsappNumber: _whatsappNumber,
      email: _email,
    );
  }

  Future<void> _onUpdatePassword(Event e) async {
    e.preventDefault();
    (document.activeElement as HTMLElement?)?.blur();
    final success = await MerchantAccountHandler.updatePassword(
      currentPassword: _currentPassword,
      newPassword: _newPassword,
      confirmPassword: _confirmPassword,
    );
    if (success) {
      setState(() {
        _currentPassword = '';
        _newPassword = '';
        _confirmPassword = '';
      });
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
      classes: 'flex-1 h-full overflow-y-auto bg-neutral/30 p-4 space-y-4',
      [
        AccountBanner(
          displayName: displayName,
          displayBusiness: displayBusiness,
          displayEmail: displayEmail,
          displayWhatsapp: displayWhatsapp,
          initials: initials,
          activeStoreCount: activeStoreCount,
        ),

        div(classes: 'grid grid-cols-1 lg:grid-cols-3 gap-4', [
          div(classes: 'lg:col-span-2 space-y-4', [
            MerchantInfoCard(
              name: _name,
              businessName: _businessName,
              email: _email,
              whatsappNumber: _whatsappNumber,
              onNameChanged: (val) => _name = val,
              onBusinessNameChanged: (val) => _businessName = val,
              onEmailChanged: (val) => _email = val,
              onWhatsappChanged: (val) => _whatsappNumber = val,
              onSave: _onSaveProfile,
            ),
            SecurityCredentialsCard(
              currentPassword: _currentPassword,
              newPassword: _newPassword,
              confirmPassword: _confirmPassword,
              onCurrentPasswordChanged: (val) =>
                  setState(() => _currentPassword = val),
              onNewPasswordChanged: (val) => setState(() => _newPassword = val),
              onConfirmPasswordChanged: (val) =>
                  setState(() => _confirmPassword = val),
              onUpdatePassword: _onUpdatePassword,
            ),
          ]),

          div(classes: 'space-y-4', [
            StoreSubscriptionsCard(
              stores: stores,
              onManageSubscription: (st) =>
                  showToast('Subscription for "${st.name}" is active.'),
            ),
            NotificationSettingsCard(
              waNotifications: _waNotifications,
              lowStockAlerts: _lowStockAlerts,
              dailyReports: _dailyReports,
              onWaNotificationsChanged: (val) {
                setState(() => _waNotifications = val);
                _updateNotificationSettings(waNotifications: val);
              },
              onLowStockAlertsChanged: (val) {
                setState(() => _lowStockAlerts = val);
                _updateNotificationSettings(lowStockAlerts: val);
              },
              onDailyReportsChanged: (val) {
                setState(() => _dailyReports = val);
                _updateNotificationSettings(dailyReports: val);
              },
            ),
          ]),
        ]),
      ],
    );
  }
}
