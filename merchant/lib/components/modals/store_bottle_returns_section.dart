import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/generated_icons/recycle.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:models/models.dart';

class StoreBottleReturnsSection extends StatelessComponent {
  const StoreBottleReturnsSection({super.key, required this.store});

  final Store store;

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'flex items-center justify-between py-2 border-t border-border-medium/60 mb-2 gap-2.5',
      [
        div(classes: 'flex flex-col min-w-0 flex-1 pr-1', [
          p(classes: 'text-sm font-semibold text-primary truncate', [
            .text('Bottle Returns'),
          ]),
          p(classes: 'text-xs text-gray-500 truncate sm:whitespace-normal', [
            .text('Manage returnable bottles and deposit reward'),
          ]),
        ]),
        button(
          type: ButtonType.button,
          classes: 'flex items-center gap-1 text-xs font-semibold text-emerald-700 bg-emerald-50 hover:bg-emerald-100 border border-emerald-200/80 px-2.5 sm:px-3 py-1.5 rounded-lg hover:cursor-pointer transition-colors shadow-2xs shrink-0',
          onClick: () {
            selectTabStore(store);
            activeModalSignal.value = ActiveModal.bottleReturns;
          },
          [
            Recycle(classes: 'w-3.5 h-3.5 text-emerald-600'),
            .text('Configure'),
          ],
        ),
      ],
    );
  }
}
