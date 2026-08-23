import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/generated_icons/recycle.dart';
import 'package:jaspr_lucide/generated_icons/square_pen.dart';
import 'package:models/models.dart';

class StoreCard extends StatelessComponent {
  const StoreCard({
    super.key,
    required this.store,
    this.isSelected = false,
    this.onClick,
    this.onEdit,
    this.onBottleReturns,
    required this.count,
  });

  final Store store;
  final int count;
  final bool isSelected;
  final VoidCallback? onClick;
  final VoidCallback? onEdit;
  final VoidCallback? onBottleReturns;

  String get _containerClass {
    if (isSelected) {
      return 'flex flex-col gap-4 p-4 border border-accent border-2 rounded-xl shadow-xs transition-all duration-200 hover:cursor-pointer hover:border-accent/80 bg-white';
    }
    return 'flex flex-col gap-4 p-4 border border-border-medium rounded-xl shadow-2xs transition-all duration-200 hover:cursor-pointer hover:border-accent/40 bg-white';
  }

  String get _statusBadgeClass {
    if (store.isActive) {
      return 'bg-soft-green text-soft-green-content rounded-full px-2.5 py-0.5 text-xs font-semibold';
    }
    return 'bg-soft-red text-soft-red-content rounded-full px-2.5 py-0.5 text-xs font-semibold';
  }

  @override
  Component build(BuildContext context) {
    return div(
      classes: _containerClass,
      events: {
        if (onClick != null) 'click': (e) => onClick!(),
      },
      [
        div(classes: 'flex justify-between items-center', [
          h2(classes: 'font-semibold text-primary text-base truncate mr-2', [
            .text(store.name),
          ]),
          div(classes: 'flex items-center gap-1.5', [
            if (store.isBottleReturnEnabled && onBottleReturns != null)
              button(
                classes: 'flex items-center gap-1 text-xs font-medium text-emerald-700 bg-emerald-50 hover:bg-emerald-100 border border-emerald-200/80 px-2.5 py-1 rounded-lg hover:cursor-pointer transition-all duration-200 shadow-2xs',
                events: {
                  'click': (e) {
                    e.stopPropagation();
                    onBottleReturns?.call();
                  },
                },
                [
                  Recycle(classes: 'w-3.5 h-3.5 text-emerald-600'),
                  .text('Bottle Returns'),
                ],
              ),
            button(
              classes: 'p-1.5 rounded-lg text-gray-400 hover:text-primary hover:bg-neutral/60 hover:cursor-pointer transition-all duration-200',
              events: {
                'click': (e) {
                  e.stopPropagation();
                  onEdit?.call();
                },
              },
              [
                SquarePen(classes: 'w-4 h-4'),
              ],
            ),
          ]),
        ]),

        div(
          classes: 'flex flex-wrap gap-2 items-center',
          [
            div(
              classes: 'bg-soft-blue text-soft-blue-content rounded-full px-2.5 py-0.5 text-xs font-semibold',
              [
                .text('$count Terminals'),
              ],
            ),
            div(
              classes: _statusBadgeClass,
              [
                .text(store.isActive ? 'ACTIVE' : 'INACTIVE'),
              ],
            ),
            if (store.isOnlineEnabled) ...[
              div(
                classes: 'bg-soft-purple text-soft-purple-content rounded-full px-2.5 py-0.5 text-xs font-semibold',
                [
                  .text('Online Ordering'),
                ],
              ),
              if (store.slug != null && store.slug!.isNotEmpty)
                div(
                  classes: 'bg-soft-yellow text-soft-yellow-content rounded-full px-2.5 py-0.5 text-xs font-mono font-medium',
                  [
                    .text('/${store.slug!}'),
                  ],
                ),
            ],
          ],
        ),
      ],
    );
  }
}
