import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Segmented tab toggle for switching between Pending and Completed customer order views.
class CustomerOrderStatusTabs extends StatelessComponent {
  final String selectedTab;
  final ValueChanged<String> onTabSelected;

  const CustomerOrderStatusTabs({
    super.key,
    required this.selectedTab,
    required this.onTabSelected,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes:
          'flex items-center p-1 bg-gray-100 rounded-2xl max-w-sm w-full gap-1 border border-gray-200/80 mx-auto',
      [
        button(
          classes: selectedTab == 'pending'
              ? 'flex-1 py-2 px-4 rounded-xl bg-white text-black font-extrabold text-xs shadow-2xs transition-all border-0 cursor-pointer text-center'
              : 'flex-1 py-2 px-4 rounded-xl text-gray-500 hover:text-black font-bold text-xs transition-all border-0 cursor-pointer text-center',
          onClick: () => onTabSelected('pending'),
          [.text('Pending')],
        ),
        button(
          classes: selectedTab == 'completed'
              ? 'flex-1 py-2 px-4 rounded-xl bg-white text-black font-extrabold text-xs shadow-2xs transition-all border-0 cursor-pointer text-center'
              : 'flex-1 py-2 px-4 rounded-xl text-gray-500 hover:text-black font-bold text-xs transition-all border-0 cursor-pointer text-center',
          onClick: () => onTabSelected('completed'),
          [.text('Completed')],
        ),
      ],
    );
  }
}
