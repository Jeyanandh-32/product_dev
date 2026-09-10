import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/fields/date_picker.dart';
import 'package:merchant/components/fields/searchbar.dart';
import 'package:merchant/components/reports/stats_toggle_button.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/stock_summary_signal.dart';

/// Top control toolbar for stock summary sub-tab (date picker, stats toggle, and search).
class StockSummaryToolbar extends StatelessComponent {
  final ValueChanged<String> onSearch;

  const StockSummaryToolbar({
    super.key,
    required this.onSearch,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'flex flex-col md:items-center md:flex-row md:justify-between w-full border-b border-border-medium p-4 gap-4',
      [
        div(
          classes: 'flex flex-wrap items-center gap-3 text-sm font-medium',
          [
            DatePicker(
              date: stockSummaryDateSignal.value,
              onDateChanged: (selectedDate) {
                stockSummaryDateSignal.value = selectedDate;
                stockSummaryPageSignal.value = 1;
                refreshStockSummarySignal();
              },
            ),
            StatsToggleButton(
              showStats: showReportsStatsSignal.value,
              onToggle: () {
                showReportsStatsSignal.value = !showReportsStatsSignal.value;
              },
            ),
          ],
        ),
        div(
          classes: 'flex justify-between gap-2 items-center w-full sm:w-auto',
          [
            Searchbar(
              placeholder: 'Search Products...',
              classes: 'flex-1 sm:flex-none sm:w-64',
              onInput: onSearch,
            ),
          ],
        ),
      ],
    );
  }
}
