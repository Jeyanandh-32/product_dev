import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:merchant/components/buttons/add_button.dart';
import 'package:merchant/components/cards/store_card.dart';
import 'package:merchant/components/cards/terminal_card.dart';
import 'package:merchant/components/modals/add_store_modal.dart';
import 'package:merchant/components/modals/add_terminal_modal.dart';
import 'package:merchant/components/searchbar.dart';
import 'package:merchant/pages/loading.dart';
import 'package:merchant/providers/stores_provider.dart';
import 'package:merchant/providers/ui_providers.dart';

class Stores extends StatelessComponent {
  const Stores({super.key});

  @override
  Component build(BuildContext context) {
    final activeModal = context.watch(activeModalProvider);
    final storesState = context.watch(storesProvider);
    final selectedStore = context.watch(selectedTabStoreProvider);

    if (storesState.hasValue && storesState.value!.isNotEmpty) {
      if (selectedStore == null ||
          !storesState.value!.any((st) => st.id == selectedStore.id)) {
        Future.microtask(() {
          context.read(selectedTabStoreProvider.notifier).state =
              storesState.value!.first;
        });
      }
    }

    if (storesState.isLoading || !storesState.hasValue) return Loading();

    return div(
      classes:
          'w-full flex-1 min-h-0 p-4 flex flex-col lg:flex-row gap-4 overflow-y-auto lg:overflow-hidden',
      [
        if (activeModal == .addStore) AddStoreModal(),
        if (activeModal == .addTerminal) AddTerminalModal(),

        div(
          classes:
              'h-[500px] md:flex-1 lg:h-full lg:flex-1 min-h-0 bg-white rounded-2xl border border-border-light p-6 flex flex-col flex-shrink-0 lg:flex-shrink',
          [
            div(
              classes:
                  'flex flex-col sm:flex-row lg:flex-col gap-2 justify-between items-start sm:items-center lg:items-start',
              [
                h3(classes: 'text-primary font-semibold text-lg', [
                  .text('Stores'),
                ]),

                div(classes: 'flex gap-2 w-full sm:w-auto', [
                  Searchbar(placeholder: 'Search Store...'),
                  AddButton(
                    name: 'Add Store',
                    onClick: () =>
                        context.read(activeModalProvider.notifier).state =
                            .addStore,
                  ),
                ]),
              ],
            ),

            div(
              classes:
                  'divider before:h-[0.5px] after:h-[0.5px] before:bg-gray-300 after:bg-gray-300',
              [],
            ),

            div(
              classes:
                  'grid grid-cols-1 sm:${storesState.value!.isEmpty ? 'grid-cols-1' : 'grid-cols-2'} lg:flex lg:flex-col sm:gap-x-4 sm:gap-y-2 overflow-y-auto flex-1 pr-2 ${storesState.value!.isEmpty ? '' : 'auto-rows-max'}',
              storesState.value!.isEmpty
                  ? [
                      div(
                        classes:
                            'flex flex-col items-center justify-center h-full text-center text-gray-400 py-10 w-full',
                        [
                          .text('No stores were added.'),
                        ],
                      ),
                    ]
                  : List.generate(
                      storesState.value!.length,
                      (index) {
                        final store = storesState.value![index];
                        return StoreCard(
                          name: store.name,
                          isSelected: store.id == selectedStore?.id,
                          onClick: () {
                            context
                                    .read(selectedTabStoreProvider.notifier)
                                    .state =
                                store;
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
        div(
          classes:
              'h-[500px] md:flex-1 lg:h-full lg:flex-2 min-h-0 p-4 bg-white rounded-2xl border border-border-light flex flex-col flex-shrink-0 lg:flex-shrink',
          [
            div(
              classes:
                  'flex flex-col sm:flex-row gap-2 lg:gap-0 justify-between items-start sm:items-center',
              [
                h3(
                  classes:
                      'text-primary font-semibold text-lg flex items-center',
                  [
                    .text('Terminals'),
                    if (selectedStore != null)
                      span(classes: 'text-gray-300 mx-2 text-sm font-normal', [
                        .text('/'),
                      ]),
                    if (selectedStore != null)
                      span(classes: 'text-sm text-gray-400', [
                        .text(selectedStore.name),
                      ]),
                  ],
                ),

                div(classes: 'flex gap-2 w-full sm:w-auto', [
                  Searchbar(placeholder: 'Search Terminal...'),
                  AddButton(
                    name: 'Add Terminal',
                    onClick: () =>
                        context.read(activeModalProvider.notifier).state =
                            .addTerminal,
                  ),
                ]),
              ],
            ),

            div(
              classes:
                  'divider before:h-[0.5px] after:h-[0.5px] before:bg-gray-300 after:bg-gray-300',
              [],
            ),

            div(
              classes:
                  'grid grid-cols-1 sm:grid-cols-2 gap-x-4 gap-y-2 overflow-y-auto flex-1 pr-2 auto-rows-max',
              [
                TerminalCard(name: 'Master'),
                TerminalCard(name: 'Staff Terminal'),
                TerminalCard(name: 'Terminal - 1'),
                TerminalCard(name: 'Terminal - 2'),
                TerminalCard(name: 'Terminal - 3'),
                TerminalCard(name: 'Terminal - 4'),
                TerminalCard(name: 'Terminal - 5'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
