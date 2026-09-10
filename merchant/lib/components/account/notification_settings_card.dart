import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart';

/// Notification settings card for merchant alert preferences (blocked until future release).
class NotificationSettingsCard extends StatelessComponent {
  final bool waNotifications;
  final bool lowStockAlerts;
  final bool dailyReports;
  final ValueChanged<bool>? onWaNotificationsChanged;
  final ValueChanged<bool>? onLowStockAlertsChanged;
  final ValueChanged<bool>? onDailyReportsChanged;

  const NotificationSettingsCard({
    super.key,
    required this.waNotifications,
    required this.lowStockAlerts,
    required this.dailyReports,
    this.onWaNotificationsChanged,
    this.onLowStockAlertsChanged,
    this.onDailyReportsChanged,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'bg-white rounded-2xl border border-border-medium p-5 shadow-2xs space-y-4',
      [
        div(
          classes: 'flex items-center justify-between border-b border-border-light pb-3 gap-2 flex-wrap',
          [
            div(classes: 'flex items-center gap-2.5', [
              div(
                classes: 'p-2 bg-neutral text-primary rounded-lg border border-border-medium',
                [Bell(classes: 'w-4 h-4')],
              ),
              div([
                h3(
                  classes: 'text-sm sm:text-base font-bold text-slate-900',
                  [.text('Notification Settings')],
                ),
                p(
                  classes: 'text-xs text-slate-500 font-medium',
                  [.text('Configure alerts & summaries')],
                ),
              ]),
            ]),
            span(
              classes: 'px-2.5 py-0.5 rounded-full text-[10px] font-bold uppercase tracking-wider bg-amber-50 text-amber-700 border border-amber-200',
              [.text('Coming Soon')],
            ),
          ],
        ),

        div(
          classes: 'p-2.5 rounded-xl bg-neutral/40 border border-border-light text-xs text-slate-500 flex items-center gap-2',
          [
            Clock(classes: 'w-3.5 h-3.5 text-amber-600 shrink-0'),
            span([
              .text(
                'WhatsApp notifications and automated reports will be available in a future release.',
              ),
            ]),
          ],
        ),

        div(
          classes: 'space-y-3 text-xs sm:text-sm font-medium text-slate-700 opacity-60 pointer-events-none select-none',
          [
            _buildToggleRow(
              title: 'WhatsApp Alerts',
              desc: 'Instant order receipts',
              checked: waNotifications,
            ),
            _buildToggleRow(
              title: 'Low Stock Alerts',
              desc: 'WhatsApp when inventory is low',
              checked: lowStockAlerts,
            ),
            _buildToggleRow(
              title: 'Daily Settlement',
              desc: 'End-of-day report',
              checked: dailyReports,
            ),
          ],
        ),
      ],
    );
  }

  Component _buildToggleRow({
    required String title,
    required String desc,
    required bool checked,
  }) {
    return div(classes: 'flex items-center justify-between gap-3', [
      div([
        p(classes: 'font-bold text-slate-900 text-xs sm:text-sm', [
          .text(title),
        ]),
        p(classes: 'text-xs text-slate-500', [.text(desc)]),
      ]),
      input(
        type: InputType.checkbox,
        classes: 'toggle toggle-primary cursor-not-allowed opacity-50',
        checked: checked,
        disabled: true,
      ),
    ]);
  }
}
