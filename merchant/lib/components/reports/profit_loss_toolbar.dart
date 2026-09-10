import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/fields/date_range_picker.dart';
import 'package:merchant/components/fields/searchbar.dart';
import 'package:merchant/components/reports/stats_toggle_button.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/profit_loss_signal.dart';
import 'package:merchant/signals/reports_date_signal.dart';

/// Top control toolbar for profit & loss sub-tab (date range, stats toggle, and search).
class ProfitLossToolbar extends StatelessComponent {
  final ValueChanged<String> onSearch;

  const ProfitLossToolbar({
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
            DateRangePicker(
              fromDate: reportsFromDateSignal.value,
              toDate: reportsToDateSignal.value,
              onChanged: (from, to) {
                reportsFromDateSignal.value = from;
                reportsToDateSignal.value = to;
                profitLossPageSignal.value = 1;
                refreshProfitLossSignal();
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
