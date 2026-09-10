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

  String get _statusBadgeClass {
    if (terminal.isActive) {
      return 'bg-soft-green text-soft-green-content rounded-full px-3 py-1 text-xs font-semibold hover:cursor-pointer transition-all duration-300';
    }
    return 'bg-soft-red text-soft-red-content rounded-full px-3 py-1 text-xs font-semibold hover:cursor-pointer transition-all duration-300';
  }

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'flex flex-col gap-4 p-5 border border-border-medium rounded-2xl shadow-2xs transition-all duration-200 hover:cursor-pointer hover:border-slate-400 bg-white',
      [
        div(classes: 'flex justify-between items-center', [
          h2(classes: 'font-semibold text-slate-900', [.text(terminal.name)]),
          button(
            classes: 'hover:cursor-pointer',
            events: {
              'click': (e) {
                e.stopPropagation();
                onEdit?.call();
              },
            },
            [
              SquarePen(classes: 'w-4 h-4 text-slate-400 hover:text-slate-600'),
            ],
          ),
        ]),

        div(
          classes: 'flex gap-2 mt-2',
          [
            div(
              classes: 'bg-soft-purple text-soft-purple-content rounded-full px-3 py-1 text-xs font-semibold',
              [
                .text(terminal.code),
              ],
            ),
            div(
              classes: _statusBadgeClass,
              [
                .text(terminal.isActive ? 'ACTIVE' : 'INACTIVE'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
