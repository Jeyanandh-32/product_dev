import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router, Store;
import 'package:jaspr_router/jaspr_router.dart';
import 'package:models/models.dart';

/// Top header banner and online availability status for customer store detail page.
class StoreDetailHeader extends StatelessComponent {
  final Store store;

  const StoreDetailHeader({super.key, required this.store});

  @override
  Component build(BuildContext context) {
    return div(classes: 'flex flex-col gap-4', [
      div(classes: 'flex items-center gap-3', [
        button(
          classes: 'w-9 h-9 rounded-full bg-gray-100 hover:bg-gray-200 text-gray-700 flex items-center justify-center cursor-pointer border-0 transition-all active:scale-95 shrink-0',
          onClick: () => Router.of(context).push('/?all=true'),
          [ArrowLeft(classes: 'w-5 h-5')],
        ),
        div(classes: 'flex flex-col', [
          h1(
            classes: 'text-2xl sm:text-3xl font-extrabold text-black tracking-tight leading-tight',
            [.text(store.name)],
          ),
          if (store.storeType case final type? when type.isNotEmpty)
            span(classes: 'text-xs text-gray-500 font-medium capitalize', [
              .text(type),
            ]),
        ]),
      ]),
      if (!store.isOnlineEnabled || !store.isOperational)
        div(
          classes: 'w-full bg-amber-50 border border-amber-200 text-amber-900 rounded-2xl p-4 flex items-center gap-3 text-sm font-semibold shadow-2xs',
          [
            span(
              classes: 'text-amber-600 text-lg font-bold shrink-0',
              [.text('⚠️')],
            ),
            span([
              .text(
                'Online ordering is currently paused for this store. You can browse the menu, but online checkout is unavailable.',
              ),
            ]),
          ],
        ),
    ]);
  }
}
