import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:merchant/components/buttons/add_button.dart';
import 'package:merchant/components/cards/terminal_card.dart';
import 'package:merchant/components/fields/searchbar.dart';
import 'package:merchant/providers/terminals_provider.dart';
import 'package:merchant/providers/ui_providers.dart';

class TerminalsContainer extends StatelessComponent {
  const TerminalsContainer({super.key});

  @override
  Component build(BuildContext context) {
    final selectedStore = context.watch(selectedTabStoreProvider);
    final terminalsState = context.watch(terminalsProvider);

    final terminalsList =
        terminalsState.value
            ?.where((t) => t.storeId == selectedStore?.id)
            .toList() ??
        [];

    final showTerminalsGrid =
        selectedStore != null &&
        !terminalsState.isLoading &&
        terminalsList.isNotEmpty;

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
                  context.read(editingTerminalProvider.notifier).state = null;
                  context.read(activeModalProvider.notifier).state =
                      ActiveModal.addTerminal;
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
              'grid grid-cols-1 ${showTerminalsGrid ? 'sm:grid-cols-2' : 'sm:grid-cols-1'} gap-4 overflow-y-auto flex-1 pr-2 ${showTerminalsGrid ? 'auto-rows-max' : ''}',
          [
            if (selectedStore == null)
              div(
                classes:
                    'flex flex-col items-center justify-center h-full text-center text-gray-400 py-10 w-full',
                [
                  .text('Select a store to view terminals.'),
                ],
              )
            else if (terminalsState.isLoading)
              div(
                classes:
                    'flex flex-col items-center justify-center h-full text-center text-gray-400 py-10 w-full',
                [
                  .text('Loading terminals...'),
                ],
              )
            else if (terminalsList.isNotEmpty)
              for (final terminal in terminalsList)
                TerminalCard(
                  terminal: terminal,
                  onEdit: () {
                    context.read(editingTerminalProvider.notifier).state =
                        terminal;
                    context.read(activeModalProvider.notifier).state =
                        ActiveModal.editTerminal;
                  },
                )
            else
              div(
                classes:
                    'flex flex-col items-center justify-center h-full text-center text-gray-400 py-10 w-full',
                [
                  .text('No terminals found.'),
                ],
              ),
          ],
        ),
      ],
    );
  }
}
