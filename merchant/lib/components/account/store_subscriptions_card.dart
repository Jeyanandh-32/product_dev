import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Store, Map;
import 'package:models/models.dart';

/// Card listing merchant stores and their respective subscription plan status.
class StoreSubscriptionsCard extends StatelessComponent {
  final List<Store> stores;
  final Map<String, StoreSubscription>? subscriptions;
  final ValueChanged<Store> onManageSubscription;

  const StoreSubscriptionsCard({
    super.key,
    required this.stores,
    this.subscriptions,
    required this.onManageSubscription,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'bg-white rounded-xl border border-border-medium p-5 shadow-2xs space-y-4',
      [
        div(
          classes: 'flex items-center justify-between border-b border-border-light pb-3',
          [
            div(classes: 'flex items-center gap-2.5', [
              div(
                classes: 'p-2 bg-neutral text-primary rounded-lg border border-border-medium',
                [
                  CreditCard(classes: 'w-4 h-4'),
                ],
              ),
              div([
                h3(
                  classes: 'text-sm sm:text-base font-bold text-gray-900',
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
            for (final st in stores) _buildStoreRow(st),
          ]),
      ],
    );
  }

  Component _buildStoreRow(Store st) {
    final sub = subscriptions?[st.id];
    final isOperational = sub != null ? sub.status.isOperational : st.isActive;
    final statusBadge = sub != null
        ? switch (sub.status) {
            SubscriptionStatus.trial => '14-Day Trial',
            SubscriptionStatus.active => 'Active Plan',
            SubscriptionStatus.gracePeriod => 'Grace Period',
            SubscriptionStatus.expired => 'Expired',
            SubscriptionStatus.canceled => 'Canceled',
          }
        : (st.isActive ? 'Active Store' : 'Inactive Store');

    return div(
      classes: 'p-3.5 rounded-lg border border-border-medium bg-neutral/20 space-y-2.5',
      [
        div(
          classes: 'flex items-center justify-between gap-2 flex-wrap',
          [
            h4(
              classes: 'text-xs sm:text-sm font-bold text-gray-900 truncate',
              [.text(st.name)],
            ),
            span(
              classes: isOperational
                  ? 'px-2 py-0.5 rounded text-[10px] font-bold uppercase tracking-wider bg-emerald-50 text-emerald-700 border border-emerald-200'
                  : 'px-2 py-0.5 rounded text-[10px] font-bold uppercase tracking-wider bg-red-50 text-red-600 border border-red-200',
              [.text(statusBadge)],
            ),
          ],
        ),

        div(
          classes: 'flex items-center justify-between text-xs font-semibold text-gray-600 pt-0.5',
          [
            span(
              classes: isOperational
                  ? 'flex items-center gap-1 text-emerald-700 font-bold'
                  : 'flex items-center gap-1 text-red-600 font-bold',
              [
                if (isOperational)
                  CircleCheck(classes: 'w-3.5 h-3.5')
                else
                  CircleAlert(classes: 'w-3.5 h-3.5'),
                .text(
                  isOperational
                      ? 'Subscription Operational'
                      : 'Renewal Required',
                ),
              ],
            ),
            span(classes: 'text-gray-500 font-medium', [
              .text(
                sub != null
                    ? 'Renews ${sub.endsAt.year}-${sub.endsAt.month.toString().padLeft(2, '0')}-${sub.endsAt.day.toString().padLeft(2, '0')}'
                    : 'Renews Annually',
              ),
            ]),
          ],
        ),

        button(
          type: .button,
          events: {
            'click': (e) => onManageSubscription(st),
          },
          [
            Sparkles(classes: 'w-3.5 h-3.5 text-primary'),
            .text('Manage Subscription'),
          ],
        ),
      ],
    );
  }
}
