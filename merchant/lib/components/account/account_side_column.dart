import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/account/notification_settings_card.dart';
import 'package:merchant/components/account/store_subscriptions_card.dart';
import 'package:merchant/signals/toast_signal.dart';
import 'package:models/models.dart';

/// Side column component for account subscriptions and notification settings.
class AccountSideColumn extends StatelessComponent {
  const AccountSideColumn({
    super.key,
    required this.stores,
    required this.waNotifications,
    required this.lowStockAlerts,
    required this.dailyReports,
    required this.onNotificationSettingChanged,
  });

  final List<Store> stores;
  final bool waNotifications;
  final bool lowStockAlerts;
  final bool dailyReports;
  final void Function({bool? waNotifications, bool? lowStockAlerts, bool? dailyReports})
      onNotificationSettingChanged;

  @override
  Component build(BuildContext context) {
    return div(classes: 'space-y-4', [
      StoreSubscriptionsCard(
        stores: stores,
        onManageSubscription: (st) =>
            showToast('Subscription for "${st.name}" is active.'),
      ),
      NotificationSettingsCard(
        waNotifications: waNotifications,
        lowStockAlerts: lowStockAlerts,
        dailyReports: dailyReports,
        onWaNotificationsChanged: (val) =>
            onNotificationSettingChanged(waNotifications: val),
        onLowStockAlertsChanged: (val) =>
            onNotificationSettingChanged(lowStockAlerts: val),
        onDailyReportsChanged: (val) =>
            onNotificationSettingChanged(dailyReports: val),
      ),
    ]);
  }
}
