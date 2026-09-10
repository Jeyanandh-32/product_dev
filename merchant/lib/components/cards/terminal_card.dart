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
      return 'bg-soft-green text-soft-green-content rounded-full px-2.5 py-0.5 text-xs font-semibold';
    }
    return 'bg-soft-red text-soft-red-content rounded-full px-2.5 py-0.5 text-xs font-semibold';
  }

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'flex flex-col gap-4 p-5 border border-border-medium rounded-2xl shadow-2xs transition-all duration-200 hover:cursor-pointer hover:border-slate-400 bg-white',
      [
        div(classes: 'flex justify-between items-center gap-2', [
          h2(
            classes: 'font-semibold text-slate-900 text-base truncate min-w-0 flex-1 mr-2',
            [
              .text(terminal.name),
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
              classes: 'bg-soft-purple text-soft-purple-content rounded-full px-2.5 py-0.5 text-xs font-semibold',
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
