import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Store;
import 'package:models/models.dart';

class StoreSubscriptionsCard extends StatelessComponent {
  final List<Store> stores;
  final ValueChanged<Store> onManageSubscription;

  const StoreSubscriptionsCard({
    super.key,
    required this.stores,
    required this.onManageSubscription,
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
                            st.isActive ? 'Active Store' : 'Inactive Store',
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
                      'click': (e) => onManageSubscription(st),
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
    );
  }
}
