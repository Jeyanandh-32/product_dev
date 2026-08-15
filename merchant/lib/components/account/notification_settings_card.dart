import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart';
import 'package:web/web.dart' as web;

class NotificationSettingsCard extends StatelessComponent {
  final bool waNotifications;
  final bool lowStockAlerts;
  final bool dailyReports;
  final ValueChanged<bool> onWaNotificationsChanged;
  final ValueChanged<bool> onLowStockAlertsChanged;
  final ValueChanged<bool> onDailyReportsChanged;

  const NotificationSettingsCard({
    super.key,
    required this.waNotifications,
    required this.lowStockAlerts,
    required this.dailyReports,
    required this.onWaNotificationsChanged,
    required this.onLowStockAlertsChanged,
    required this.onDailyReportsChanged,
  });

  @override
  Component build(BuildContext context) {
    return div(
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
                  classes: 'text-sm sm:text-base font-bold text-gray-900',
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
          classes: 'space-y-3 text-xs sm:text-sm font-medium text-gray-700',
          [
            // Toggle 1: WhatsApp Alerts
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
                checked: waNotifications,
                events: {
                  'change': (e) {
                    final target = e.target as web.HTMLInputElement;
                    onWaNotificationsChanged(target.checked);
                  },
                },
              ),
            ]),

            // Toggle 2: Low Stock Alerts
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
                checked: lowStockAlerts,
                events: {
                  'change': (e) {
                    final target = e.target as web.HTMLInputElement;
                    onLowStockAlertsChanged(target.checked);
                  },
                },
              ),
            ]),

            // Toggle 3: Daily Settlement
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
                checked: dailyReports,
                events: {
                  'change': (e) {
                    final target = e.target as web.HTMLInputElement;
                    onDailyReportsChanged(target.checked);
                  },
                },
              ),
            ]),
          ],
        ),
      ],
    );
  }
}
