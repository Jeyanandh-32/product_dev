import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/generated_icons/recycle.dart';

class BottleReturnDisabledView extends StatelessComponent {
  const BottleReturnDisabledView({super.key});

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'flex flex-col items-center justify-center text-center py-10 px-4 bg-neutral/20 border border-dashed border-border-medium rounded-xl gap-3',
      [
        div(
          classes: 'w-12 h-12 rounded-full bg-neutral/80 flex items-center justify-center text-gray-400',
          [Recycle(classes: 'w-6 h-6')],
        ),
        div(classes: 'flex flex-col gap-1 max-w-sm', [
          p(classes: 'text-sm font-semibold text-primary', [
            .text('Bottle return deposit is disabled'),
          ]),
          p(classes: 'text-xs text-gray-400 leading-relaxed', [
            .text(
              'Toggle the switch above to activate bottle deposit tokens and choose returnable products.',
            ),
          ]),
        ]),
      ],
    );
  }
}
