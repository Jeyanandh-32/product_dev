import 'package:signals_flutter/signals_flutter.dart';

/// Supported pages for the POS Terminal navigation shell.
enum TerminalNavPage {
  billing('Billing'),
  orders('Orders'),
  inventoryProducts('Products'),
  inventoryCategories('Categories'),
  inventoryCounters('Counters'),
  account('Account');

  const TerminalNavPage(this.label);
  final String label;
}

/// Reactive signal tracking the active page in the index-based terminal body.
final activeTerminalPageSignal = signal<TerminalNavPage>(TerminalNavPage.billing);

/// Resets active navigation page back to billing.
void resetNavigationSignal() {
  activeTerminalPageSignal.value = TerminalNavPage.billing;
}
