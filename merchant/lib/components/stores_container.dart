import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:merchant/components/buttons/add_button.dart';
import 'package:merchant/components/cards/store_card.dart';
import 'package:merchant/components/searchbar.dart';
import 'package:merchant/providers/stores_provider.dart';
import 'package:merchant/providers/terminals_provider.dart';
import 'package:merchant/providers/ui_providers.dart';

class StoresContainer extends StatelessComponent {
  const StoresContainer({super.key});

  @override
  Component build(BuildContext context) {
    final storesState = context.watch(storesProvider);
    final selectedStore = context.watch(selectedTabStoreProvider);
    final terminalsState = context.watch(terminalsProvider);

    final showStoresGrid =
        !storesState.isLoading &&
        storesState.hasValue &&
        storesState.value!.isNotEmpty;

    return div(
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
                onClick: () {
                  context.read(editingStoreProvider.notifier).state = null;
                  context.read(activeModalProvider.notifier).state =
                      ActiveModal.addStore;
                },
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
              'grid grid-cols-1 ${showStoresGrid ? 'sm:grid-cols-2' : 'sm:grid-cols-1'} lg:flex lg:flex-col sm:gap-x-4 sm:gap-y-2 overflow-y-auto flex-1 pr-2 ${showStoresGrid ? 'auto-rows-max' : ''}',
          [
            if (storesState.isLoading)
              div(
                classes:
                    'flex flex-col items-center justify-center h-full text-center text-gray-400 py-10 w-full',
                [
                  .text('Loading stores...'),
                ],
              )
            else if (storesState.hasValue && storesState.value!.isNotEmpty)
              for (final store in storesState.value!)
                StoreCard(
                  count:
                      terminalsState.value
                          ?.where((t) => t.storeId == store.id)
                          .length ??
                      0,
                  store: store,
                  isSelected: store.id == selectedStore?.id,
                  onClick: () {
                    context.read(selectedTabStoreProvider.notifier).state =
                        store;
                  },
                  onEdit: () {
                    context.read(editingStoreProvider.notifier).state = store;
                    context.read(activeModalProvider.notifier).state =
                        ActiveModal.editStore;
                  },
                )
            else
              div(
                classes:
                    'flex flex-col items-center justify-center h-full text-center text-gray-400 py-10 w-full',
                [
                  .text('No stores were added.'),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
