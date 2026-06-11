import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart';
import 'package:models/models.dart';

class CounterCard extends StatelessComponent {
  const CounterCard({
    super.key,
    required this.counter,
    this.onEdit,
  });

  final Counter counter;
  final VoidCallback? onEdit;

  @override
  Component build(BuildContext context) {
    return div(
      classes:
          'flex flex-col gap-4 p-4 border border-border-medium rounded-lg shadow-2xs transition-all duration-200 hover:cursor-pointer hover:border-accent/50',
      [
        div(classes: 'flex justify-between items-center', [
          h2(classes: 'font-semibold text-primary', [.text(counter.name)]),
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
          classes: 'flex justify-start gap-2 items-center mt-2',
          [
            div(
              classes:
                  '${counter.isActive ? 'bg-soft-green text-soft-green-content' : 'bg-soft-red text-soft-red-content'} rounded-full px-3 py-1 text-xs font-semibold hover:cursor-pointer transition-all duration-300',
              [
                .text(counter.isActive ? 'ACTIVE' : 'INACTIVE'),
              ],
            ),
            div(
              classes:
                  'bg-soft-blue text-soft-blue-content rounded-full px-3 py-1 text-xs font-semibold',
              [
                .text('24 Products'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
