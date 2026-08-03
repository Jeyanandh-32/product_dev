import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/generated_icons/x.dart';
import 'package:merchant/signals/navigation_signal.dart';

class Modal extends StatelessComponent {
  final String title;
  final Component child;
  final String? maxWidthClass;

  const Modal({
    super.key,
    required this.title,
    required this.child,
    this.maxWidthClass,
  });

  @override
  Component build(BuildContext context) {
    final maxWidth = maxWidthClass ?? 'max-w-md';

    return div(
      classes:
          'fixed inset-0 bg-black/40 z-50 flex items-center justify-center px-4',
      events: {
        'click': (e) => activeModalSignal.value = ActiveModal.none,
      },
      [
        div(
          classes:
              'bg-white w-full $maxWidth rounded-2xl shadow-lg p-6 flex flex-col gap-4 max-h-[90vh] overflow-y-auto',
          events: {'click': (e) => e.stopPropagation()},
          [
            div(classes: 'flex justify-between items-center', [
              h1(classes: 'text-xl font-semibold', [.text(title)]),
              button(
                onClick: () => activeModalSignal.value = ActiveModal.none,
                classes:
                    'border border-border-light p-1.5 rounded-full transition-all duration-300 hover:bg-gray-50 hover:cursor-pointer hover:text-gray-600',
                [
                  X(classes: 'w-5 h-5'),
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
