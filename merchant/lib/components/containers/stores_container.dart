import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:merchant/components/buttons/add_button.dart';
import 'package:merchant/components/cards/store_card.dart';
import 'package:merchant/components/centered_message.dart';
import 'package:merchant/components/fields/searchbar.dart';
import 'package:merchant/components/loading.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:merchant/signals/terminals_signal.dart';
import 'package:merchant/signals/ui_signals.dart';

class StoresContainer extends SignalComponent {
  const StoresContainer({super.key});

  @override
  SignalState<StoresContainer> createState() => _StoresContainerState();
}

class _StoresContainerState extends SignalState<StoresContainer> {
  @override
  Component buildSignal(BuildContext context) {
    final storesState = storesSignal.value;
    final selectedStore = selectedTabStoreSignal.value;
    final terminalsState = terminalsSignal.value;

    return div(
      classes:
          'h-[500px] md:flex-1 lg:h-full lg:flex-1 min-h-0 bg-white rounded-2xl border border-border-medium p-6 flex flex-col flex-shrink-0 lg:flex-shrink',
      [
        div(
          classes:
              'flex flex-col sm:flex-row lg:flex-col gap-2 justify-between items-start sm:items-center lg:items-start',
          [
            h3(classes: 'text-primary font-semibold text-lg', [
              .text('Stores'),
            ]),

            div(classes: 'flex gap-2 w-full sm:w-auto', [
              Searchbar(
                placeholder: 'Search Store...',
                classes: 'flex-1',
              ),
              AddButton(
                name: 'Add Store',
                onClick: () {
                  editingStoreSignal.value = null;
                  activeModalSignal.value = ActiveModal.addStore;
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

        if (storesState.isLoading)
          Loading(text: 'Loading stores...', fullScreen: false)
        else if (storesState.hasError)
          CenteredMessage(
            message: storesState.error is ApiException
                ? (storesState.error as ApiException).message
                : 'Failed to load stores. Please try again.',
          )
        else if (storesState.hasValue && storesState.value!.isEmpty)
          CenteredMessage(message: 'No stores were added.')
        else
          div(
            classes:
                'grid grid-cols-1 sm:grid-cols-2 lg:flex lg:flex-col gap-4 overflow-y-auto flex-1 pr-2 auto-rows-max',
            [
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
                    selectedTabStoreSignal.value = store;
                  },
                  onEdit: () {
                    editingStoreSignal.value = store;
                    activeModalSignal.value = ActiveModal.editStore;
                  },
                ),
            ],
          ),
      ],
    );
  }
}
