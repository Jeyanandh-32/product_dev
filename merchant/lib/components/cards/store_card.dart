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
      return 'flex flex-col gap-4 p-5 border border-slate-900 rounded-2xl shadow-xs transition-all duration-200 hover:cursor-pointer bg-white';
    }
    return 'flex flex-col gap-4 p-5 border border-border-medium rounded-2xl shadow-2xs transition-all duration-200 hover:cursor-pointer hover:border-slate-400 bg-white';
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
        if (onClick != null) 'click': (e) => onClick?.call(),
      },
      [
        div(classes: 'flex justify-between items-center gap-2', [
          h2(
            classes: 'font-semibold text-slate-900 text-base truncate min-w-0 flex-1 mr-2',
            [
              .text(store.name),
            ],
          ),
          button(
            classes: 'p-1.5 rounded-lg text-slate-400 hover:text-slate-900 hover:bg-slate-100 hover:cursor-pointer transition-all duration-200 shrink-0',
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

        if (store.isBottleReturnEnabled && onBottleReturns != null)
          div(
            classes: 'pt-3 border-t border-border-medium/60 flex items-center w-full',
            [
              button(
                classes: 'flex items-center justify-center gap-1.5 text-xs font-semibold text-emerald-700 bg-emerald-50 hover:bg-emerald-100 border border-emerald-200/80 px-3 py-2 rounded-xl hover:cursor-pointer transition-all duration-150 shadow-2xs w-full',
                events: {
                  'click': (e) {
                    e.stopPropagation();
                    onBottleReturns?.call();
                  },
                },
                [
                  Recycle(classes: 'w-4 h-4 text-emerald-600'),
                  .text('Bottle Returns'),
                ],
              ),
            ],
          ),
      ],
    );
  }
}
