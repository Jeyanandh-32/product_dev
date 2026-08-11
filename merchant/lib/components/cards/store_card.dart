import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/generated_icons/square_pen.dart';
import 'package:models/models.dart';

class StoreCard extends StatelessComponent {
  const StoreCard({
    super.key,
    required this.store,
    this.isSelected = false,
    this.onClick,
    this.onEdit,
    required this.count,
  });

  final Store store;
  final int count;
  final bool isSelected;
  final VoidCallback? onClick;
  final VoidCallback? onEdit;

  String get _containerClass {
    if (isSelected) {
      return 'flex flex-col gap-4 p-4 border border-accent border-2 rounded-lg shadow-2xs transition-all duration-200 hover:cursor-pointer hover:border-accent/50';
    }
    return 'flex flex-col gap-4 p-4 border border-border-medium rounded-lg shadow-2xs transition-all duration-200 hover:cursor-pointer hover:border-accent/50';
  }

  String get _statusBadgeClass {
    if (store.isActive) {
      return 'bg-soft-green text-soft-green-content rounded-full px-3 py-1 text-xs font-semibold';
    }
    return 'bg-soft-red text-soft-red-content rounded-full px-3 py-1 text-xs font-semibold';
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
          h2(classes: 'font-semibold text-primary', [.text(store.name)]),
          button(
            classes: 'hover:cursor-pointer',
            events: {
              'click': (e) {
                e.stopPropagation();
                onEdit?.call();
              },
            },
            [
              SquarePen(classes: 'w-5 h-5 text-gray-500'),
            ],
          ),
        ]),

        div(
          classes: 'flex flex-wrap gap-2 mt-1 items-center',
          [
            div(
              classes:
                  'bg-soft-blue text-soft-blue-content rounded-full px-3 py-1 text-xs font-semibold',
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
                classes:
                    'bg-soft-purple text-soft-purple-content rounded-full px-3 py-1 text-xs font-semibold',
                [
                  .text('Online ordering'),
                ],
              ),
              if (store.slug != null && store.slug!.isNotEmpty)
                div(
                  classes:
                      'bg-soft-yellow text-soft-yellow-content rounded-full px-3 py-1 text-xs font-mono font-medium',
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
