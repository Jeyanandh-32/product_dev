import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/generated_icons/square_pen.dart';
import 'package:models/models.dart';

class TerminalCard extends StatelessComponent {
  const TerminalCard({
    super.key,
    required this.terminal,
    this.onEdit,
  });

  final Terminal terminal;
  final VoidCallback? onEdit;

  @override
  Component build(BuildContext context) {
    return div(
      classes:
          'p-4 mb-4 border border-border-light rounded-lg flex flex-col gap-4',
      [
        div(classes: 'flex justify-between items-center', [
          h2(classes: 'font-semibold text-primary', [.text(terminal.name)]),
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

        div(classes: 'flex gap-2', [
          div(
            classes:
                'bg-soft-purple grow text-soft-purple-content rounded-lg text-[14px] font-semibold flex justify-center items-center h-10',
            [
              .text(terminal.code),
            ],
          ),

          div(
            classes:
                'grow ${terminal.isActive ? 'bg-soft-green text-soft-green-content' : 'bg-soft-red text-soft-red-content'} rounded-lg text-[14px] font-semibold flex justify-center items-center h-10 hover:cursor-pointer transition-all duration-300',
            [
              .text(terminal.isActive ? 'ACTIVE' : 'INACTIVE'),
            ],
          ),
        ]),
      ],
    );
  }
}
