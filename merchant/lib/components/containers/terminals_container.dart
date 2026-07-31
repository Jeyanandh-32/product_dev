import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:merchant/components/buttons/add_button.dart';
import 'package:merchant/components/cards/terminal_card.dart';
import 'package:merchant/components/centered_message.dart';
import 'package:merchant/components/fields/searchbar.dart';
import 'package:merchant/components/loading.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/providers/terminals_provider.dart';
import 'package:merchant/providers/ui_providers.dart';

class TerminalsContainer extends SignalComponent {
  const TerminalsContainer({super.key});

  @override
  SignalState<TerminalsContainer> createState() => _TerminalsContainerState();
}

class _TerminalsContainerState extends SignalState<TerminalsContainer> {
  @override
  void initState() {
    super.initState();
    refreshTerminalsSignal();
  }

  @override
  Component buildSignal(BuildContext context) {
    final selectedStore = selectedTabStoreSignal.value;
    final terminalsState = terminalsSignal.value;

    final terminalsList =
        terminalsState.value
            ?.where((t) => t.storeId == selectedStore?.id)
            .toList() ??
        [];

    return div(
      classes:
          'h-[500px] md:flex-1 lg:h-full lg:flex-2 min-h-0 p-4 bg-white rounded-2xl border border-border-medium flex flex-col flex-shrink-0 lg:flex-shrink',
      [
        div(
          classes:
              'flex flex-col sm:flex-row gap-2 lg:gap-0 justify-between items-start sm:items-center',
          [
            h3(
              classes: 'text-primary font-semibold text-lg flex items-center',
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
              Searchbar(
                placeholder: 'Search Terminal...',
              ),
              AddButton(
                name: 'Add Terminal',
                onClick: () {
                  editingTerminalSignal.value = null;
                  activeModalSignal.value = ActiveModal.addTerminal;
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

        if (selectedStore == null)
          CenteredMessage(message: 'Select a store to view terminals.')
        else if (terminalsState.isLoading)
          Loading(text: 'Loading terminals...', fullScreen: false)
        else if (terminalsState.hasError)
          CenteredMessage(
            message: terminalsState.error is ApiException
                ? (terminalsState.error as ApiException).message
                : 'Failed to load terminals. Please try again.',
          )
        else if (terminalsList.isEmpty)
          CenteredMessage(message: 'No terminals found.')
        else
          div(
            classes:
                'grid grid-cols-1 sm:grid-cols-2 gap-4 overflow-y-auto flex-1 pr-2 auto-rows-max',
            [
              for (final terminal in terminalsList)
                TerminalCard(
                  terminal: terminal,
                  onEdit: () {
                    editingTerminalSignal.value = terminal;
                    activeModalSignal.value = ActiveModal.editTerminal;
                  },
                ),
            ],
          ),
      ],
    );
  }
}
