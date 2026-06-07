import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/generated_icons/square_pen.dart';

class TerminalCard extends StatelessComponent {
  const TerminalCard({super.key, required this.name});

  final String name;

  @override
  Component build(BuildContext context) {
    return div(
      classes:
          'p-4 mb-4 border border-border-light rounded-lg flex flex-col gap-4',
      [
        div(classes: 'flex justify-between items-center', [
          h2(classes: 'font-semibold text-primary', [.text(name)]),
          button(classes: 'hover:cursor-pointer', [
            SquarePen(classes: 'w-5 h-5 text-gray-500'),
          ]),
        ]),

        div(classes: 'flex gap-2', [
          div(
            classes:
                'bg-soft-purple flex-1 grow text-soft-purple-content rounded-lg text-[14px] font-semibold flex justify-center items-center h-10',
            [
              .text('CJHUHAZD57K'),
            ],
          ),

          div(
            classes:
                'bg-soft-green flex-1 grow text-soft-green-content rounded-lg text-[14px] font-semibold flex justify-center items-center h-10',
            [
              .text('ACTIVE'),
            ],
          ),
        ]),
      ],
    );
  }
}
