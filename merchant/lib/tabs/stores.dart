import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:merchant/components/containers/stores_container.dart';
import 'package:merchant/components/containers/terminals_container.dart';
import 'package:merchant/components/modals/add_edit_store_modal.dart';
import 'package:merchant/components/modals/add_edit_terminal_modal.dart';
import 'package:merchant/components/modals/bottle_return_modal.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:merchant/signals/terminals_signal.dart';

/// Main stores management tab rendering store cards, terminal lists, and configuration modals.
class Stores extends SignalComponent {
  const Stores({super.key});

  @override
  SignalState<Stores> createState() => _StoresState();
}

class _StoresState extends SignalState<Stores> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => refreshStoresSignal());
  }

  @override
  Component buildSignal(BuildContext context) {
    final activeModal = activeModalSignal.value;
    final storesState = storesSignal.value;
    final selectedStore = selectedTabStoreSignal.value;
    final editingStore = editingStoreSignal.value;
    final editingTerminal = editingTerminalSignal.value;

    if (storesState.value case final storesList? when storesList.isNotEmpty) {
      if (selectedStore == null ||
          !storesList.any((st) => st.id == selectedStore.id)) {
        Future.microtask(() {
          selectedTabStoreSignal.value = storesList.first;
        });
      }
    }

    return div(
      classes:
          'w-full flex-1 min-h-0 p-4 flex flex-col lg:flex-row gap-4 overflow-y-auto lg:overflow-hidden',
      [
        if (activeModal == ActiveModal.addStore) const AddEditStoreModal(),
        if (activeModal == ActiveModal.editStore)
          AddEditStoreModal(store: editingStore),
        if (activeModal == ActiveModal.addTerminal)
          const AddEditTerminalModal(),
        if (activeModal == ActiveModal.editTerminal)
          AddEditTerminalModal(terminal: editingTerminal),
        if (activeModal == ActiveModal.bottleReturns && selectedStore != null)
          BottleReturnModal(store: selectedStore),

        const StoresContainer(),
        const TerminalsContainer(),
      ],
    );
  }
}
