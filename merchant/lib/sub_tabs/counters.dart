import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:merchant/components/buttons/add_button.dart';
import 'package:merchant/components/cards/counter_card.dart';
import 'package:merchant/components/centered_message.dart';
import 'package:merchant/components/fields/searchbar.dart';
import 'package:merchant/components/loading.dart';
import 'package:merchant/components/modals/add_edit_counter_modal.dart';
import 'package:merchant/providers/counters_provider.dart';
import 'package:merchant/providers/ui_providers.dart';

class Counters extends StatelessComponent {
  const Counters({super.key});

  @override
  Component build(BuildContext context) {
    final store = context.watch(storeProvider);
    final counters = context.watch(countersProvider);
    final activeModal = context.watch(activeModalProvider);
    final editingCounter = context.watch(editingCounterProvider);

    return div(
      classes:
          'flex flex-col flex-1 min-h-0 m-4 bg-white rounded-2xl border border-border-medium shadow-xs',
      [
        if (activeModal == ActiveModal.addCounter) const AddEditCounterModal(),
        if (activeModal == ActiveModal.editCounter)
          AddEditCounterModal(counter: editingCounter),

        div(
          classes:
              'w-full border-b border-border-medium flex items-center justify-between p-4 gap-2',
          [
            Searchbar(
              placeholder: 'Search Counters...',
              classes: 'flex-1 sm:flex-none sm:w-64',
            ),
            AddButton(
              name: 'Add Counter',
              onClick: () {
                context.read(editingCounterProvider.notifier).state = null;
                context.read(activeModalProvider.notifier).state =
                    ActiveModal.addCounter;
              },
            ),
          ],
        ),

        if (counters.isLoading)
          Loading(text: 'Loading counters...', fullScreen: false)
        else if (store == null)
          CenteredMessage(message: 'Create Store to add counters.')
        else if (counters.hasValue &&
            counters.value != null &&
            counters.value!.isEmpty)
          CenteredMessage(message: 'No Counters were added.')
        else
          div(
            classes:
                'flex-1 min-h-0 grid grid-cols-1 sm:grid-cols-2 lg:grid-cols-4 m-4 pr-2 gap-4 overflow-y-auto auto-rows-max',
            [
              for (final counter in counters.value!)
                CounterCard(
                  counter: counter,
                  onEdit: () {
                    context.read(editingCounterProvider.notifier).state =
                        counter;
                    context.read(activeModalProvider.notifier).state =
                        ActiveModal.editCounter;
                  },
                ),
            ],
          ),
      ],
    );
  }
}
