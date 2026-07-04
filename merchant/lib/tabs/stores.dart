import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:merchant/components/modals/add_edit_store_modal.dart';
import 'package:merchant/components/modals/add_edit_terminal_modal.dart';
import 'package:merchant/components/containers/stores_container.dart';
import 'package:merchant/components/containers/terminals_container.dart';
import 'package:merchant/providers/stores_provider.dart';
import 'package:merchant/providers/ui_providers.dart';

class Stores extends StatelessComponent {
  const Stores({super.key});

  @override
  Component build(BuildContext context) {
    final activeModal = context.watch(activeModalProvider);
    final storesState = context.watch(storesProvider);
    final selectedStore = context.watch(selectedTabStoreProvider);
    final editingStore = context.watch(editingStoreProvider);
    final editingTerminal = context.watch(editingTerminalProvider);

    if (storesState.hasValue && storesState.value!.isNotEmpty) {
      if (selectedStore == null ||
          !storesState.value!.any((st) => st.id == selectedStore.id)) {
        Future.microtask(() {
          context.read(selectedTabStoreProvider.notifier).state =
              storesState.value!.first;
        });
      }
    }

    return div(
      classes:
          'w-full flex-1 min-h-0 p-4 flex flex-col lg:flex-row gap-4 overflow-y-auto lg:overflow-hidden',
      [
        if (activeModal == ActiveModal.addStore) AddEditStoreModal(),
        if (activeModal == ActiveModal.editStore)
          AddEditStoreModal(store: editingStore),
        if (activeModal == ActiveModal.addTerminal) AddEditTerminalModal(),
        if (activeModal == ActiveModal.editTerminal)
          AddEditTerminalModal(terminal: editingTerminal),

        const StoresContainer(),
        const TerminalsContainer(),
      ],
    );
  }
}
