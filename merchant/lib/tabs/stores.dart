import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:merchant/components/containers/stores_container.dart';
import 'package:merchant/components/containers/terminals_container.dart';
import 'package:merchant/components/modals/add_edit_store_modal.dart';
import 'package:merchant/components/modals/add_edit_terminal_modal.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:merchant/signals/ui_signals.dart';

class Stores extends SignalComponent {
  const Stores({super.key});

  @override
  SignalState<Stores> createState() => _StoresState();
}

class _StoresState extends SignalState<Stores> {
  @override
  void initState() {
    super.initState();
    refreshStoresSignal();
  }

  @override
  Component buildSignal(BuildContext context) {
    final activeModal = activeModalSignal.value;
    final storesState = storesSignal.value;
    final selectedStore = selectedTabStoreSignal.value;
    final editingStore = editingStoreSignal.value;
    final editingTerminal = editingTerminalSignal.value;

    if (storesState.hasValue && storesState.value!.isNotEmpty) {
      if (selectedStore == null ||
          !storesState.value!.any((st) => st.id == selectedStore.id)) {
        Future.microtask(() {
          selectedTabStoreSignal.value = storesState.value!.first;
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

        const StoresContainer(),
        const TerminalsContainer(),
      ],
    );
  }
}
