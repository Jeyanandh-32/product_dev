import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart';

class CounterCard extends StatelessComponent {
  const CounterCard({super.key, required this.name});

  final String name;

  @override
  Component build(BuildContext context) {
    return div(
      classes:
          'flex flex-col gap-4 p-4 border border-border-medium rounded-lg shadow-2xs transition-all duration-200 hover:cursor-pointer hover:border-accent/50',
      [
        div(classes: 'flex justify-between', [
          h2(classes: 'font-semibold text-primary', [.text(name)]),
          button(
            classes: 'hover:cursor-pointer',
            events: {
              'click': (e) {
                e.stopPropagation();
              },
            },
            [
              SquarePen(classes: 'w-5 h-5 text-gray-500'),
            ],
          ),
        ]),

        div(
          classes: 'flex justify-between items-center mt-2',
          [
            div(
              classes:
                  'bg-soft-blue text-soft-blue-content rounded-full px-3 py-1 text-xs font-semibold',
              [
                .text('24 Products'),
              ],
            ),
            div(
              classes:
                  'text-primary hover:text-accent font-semibold text-sm flex items-center gap-0.5 hover:cursor-pointer transition-colors',
              [
                .text('View'),
                ChevronRight(classes: 'w-4 h-4'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
