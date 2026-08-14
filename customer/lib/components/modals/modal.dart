import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router;

class Modal extends StatelessComponent {
  final String title;
  final Component child;
  final String? maxWidthClass;
  final VoidCallback onClose;

  const Modal({
    super.key,
    required this.title,
    required this.child,
    required this.onClose,
    this.maxWidthClass,
  });

  @override
  Component build(BuildContext context) {
    final maxWidth = maxWidthClass ?? 'max-w-md';

    return div(
      classes:
          'fixed inset-0 bg-black/40 z-50 flex items-center justify-center px-4',
      events: {
        'click': (e) => onClose(),
      },
      [
        div(
          classes:
              'bg-white w-full $maxWidth rounded-2xl shadow-lg p-6 flex flex-col gap-4 max-h-[90vh] overflow-y-auto',
          events: {'click': (e) => e.stopPropagation()},
          [
            div(classes: 'flex justify-between items-center', [
              h1(classes: 'text-xl font-semibold text-black', [.text(title)]),
              button(
                onClick: onClose,
                classes:
                    'border border-gray-200 p-1.5 rounded-full transition-all duration-300 hover:bg-gray-50 hover:cursor-pointer hover:text-gray-600 border-0 bg-transparent',
                [
                  X(classes: 'w-5 h-5 text-gray-600'),
                ],
              ),
            ]),

            child,
          ],
        ),
      ],
    );
  }
}
