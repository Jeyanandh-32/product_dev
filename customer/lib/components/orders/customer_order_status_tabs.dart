import 'package:customer/components/orders/customer_order_tab.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Segmented tab toggle for switching between Pending and Completed customer order views.
class CustomerOrderStatusTabs extends StatelessComponent {
  final CustomerOrderTab selectedTab;
  final ValueChanged<CustomerOrderTab> onTabSelected;

  const CustomerOrderStatusTabs({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'flex items-center p-1 bg-slate-100 rounded-2xl max-w-sm w-full gap-1 border border-border-medium mx-auto',
      [
        button(
          classes: selectedTab == CustomerOrderTab.pending
              ? 'flex-1 py-2 px-4 rounded-xl bg-[#0B132B] text-white font-bold text-xs shadow-2xs transition-all border-0 cursor-pointer text-center'
              : 'flex-1 py-2 px-4 rounded-xl text-slate-600 hover:text-slate-900 font-semibold text-xs transition-all border-0 cursor-pointer text-center',
          onClick: () => onTabSelected(CustomerOrderTab.pending),
          [.text('Pending')],
        ),
        button(
          classes: selectedTab == CustomerOrderTab.completed
              ? 'flex-1 py-2 px-4 rounded-xl bg-[#0B132B] text-white font-bold text-xs shadow-2xs transition-all border-0 cursor-pointer text-center'
              : 'flex-1 py-2 px-4 rounded-xl text-slate-600 hover:text-slate-900 font-semibold text-xs transition-all border-0 cursor-pointer text-center',
          onClick: () => onTabSelected(CustomerOrderTab.completed),
          [.text('Completed')],
        ),
      ],
    );
  }
}
