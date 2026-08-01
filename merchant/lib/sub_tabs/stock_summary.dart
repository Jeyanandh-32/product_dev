import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:merchant/components/fields/date_range_picker.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/signals/reports_date_signal.dart';

class StockSummary extends SignalComponent {
  const StockSummary({super.key});

  @override
  SignalState<StockSummary> createState() => _StockSummaryState();
}

class _StockSummaryState extends SignalState<StockSummary> {
  @override
  Component buildSignal(BuildContext context) {
    return div(
      classes:
          'flex flex-col flex-1 min-h-0 m-4 bg-white rounded-2xl border border-border-medium shadow-xs overflow-hidden',
      [
        div(
          classes:
              'flex flex-col md:items-center md:flex-row md:justify-between w-full border-b border-border-medium p-4 gap-4',
          [
            div(
              classes: 'flex flex-wrap items-center gap-4 text-sm font-medium',
              [
                DateRangePicker(
                  fromDate: reportsFromDateSignal.value,
                  toDate: reportsToDateSignal.value,
                  onFromDateChanged: (val) {
                    reportsFromDateSignal.value = val;
                  },
                  onToDateChanged: (val) {
                    reportsToDateSignal.value = val;
                  },
                ),
              ],
            ),
          ],
        ),
        div(
          classes:
              'p-8 text-gray-400 font-medium text-center flex-1 flex items-center justify-center',
          [
            .text('StockSummary content coming soon!'),
          ],
        ),
      ],
    );
  }
}
