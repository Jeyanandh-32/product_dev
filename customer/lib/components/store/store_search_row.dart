import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/generated_icons/store.dart' as icon;
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router, Store;
import 'package:models/models.dart';

/// Search input and filter controls for discovering stores.
class StoreSearchRow extends StatelessComponent {
  final Store store;
  final VoidCallback onOpen;

  const StoreSearchRow({super.key, required this.store, required this.onOpen});

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'bg-white rounded-2xl p-3.5 sm:p-4 border border-border-medium hover:border-slate-400 transition-all cursor-pointer flex flex-col sm:flex-row sm:items-center justify-between gap-3 sm:gap-4 group shadow-2xs hover:shadow-xs w-full',
      events: {'click': (e) => onOpen()},
      [
        div(
          classes: 'flex items-center gap-3 sm:gap-4 min-w-0 w-full sm:w-auto',
          [
            div(
              classes: 'w-10 h-10 sm:w-12 sm:h-12 rounded-xl bg-slate-100 text-slate-700 flex items-center justify-center font-bold group-hover:bg-[#0B132B] group-hover:text-white transition-colors shrink-0',
              [
                icon.Store(classes: 'w-5 h-5 sm:w-6 sm:h-6'),
              ],
            ),
            div(classes: 'flex flex-col min-w-0 flex-1', [
              h3(
                classes: 'text-sm sm:text-base font-extrabold text-slate-900 group-hover:text-[#0B132B] transition-colors truncate',
                [
                  .text(store.name),
                ],
              ),
              div(
                classes: 'flex items-center gap-2 text-xs text-slate-400 font-medium truncate',
                [
                  if (store.storeType case final type? when type.isNotEmpty)
                    span(classes: 'truncate', [
                      .text(type),
                    ]),
                  if (store.slug != null) ...[
                    span([.text('•')]),
                    span(classes: 'text-slate-600 font-mono truncate', [
                      .text('/${store.slug}'),
                    ]),
                  ],
                ],
              ),
            ]),
          ],
        ),

        div(
          classes: 'w-full sm:w-auto px-5 py-2.5 rounded-xl bg-slate-100 group-hover:bg-[#0B132B] text-slate-800 group-hover:text-white font-bold text-xs sm:text-sm flex items-center justify-center gap-2 transition-all shrink-0 shadow-2xs',
          [
            .text('Open Store Menu'),
            ArrowRight(classes: 'w-4 h-4'),
          ],
        ),
      ],
    );
  }
}
