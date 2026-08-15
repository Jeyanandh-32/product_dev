import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/fields/form_field.dart';
import 'package:web/web.dart' as web;

/// Toggle and numeric threshold settings for product stock monitoring.
class StockMonitorSettingsSection extends StatelessComponent {
  final bool stockMonitor;
  final String lowStockThreshold;
  final ValueChanged<bool> onToggleMonitor;
  final ValueChanged<String> onThresholdChanged;

  const StockMonitorSettingsSection({
    super.key,
    required this.stockMonitor,
    required this.lowStockThreshold,
    required this.onToggleMonitor,
    required this.onThresholdChanged,
  });

  @override
  Component build(BuildContext context) {
    return div(classes: 'flex flex-col', [
      div(
        classes:
            'form-control mb-4 flex flex-row items-center justify-between p-3 rounded-xl bg-neutral/20 border border-border-medium',
        [
          div(classes: 'flex flex-col', [
            span(classes: 'text-sm font-semibold text-gray-700', [
              .text('Stock Monitor'),
            ]),
            span(classes: 'text-xs text-gray-500', [
              .text('Receive low stock alerts'),
            ]),
          ]),
          input(
            type: InputType.checkbox,
            classes:
                'toggle ${stockMonitor ? 'toggle-success' : ''} hover:cursor-pointer',
            checked: stockMonitor,
            events: {
              'change': (e) {
                final target = e.target as web.HTMLInputElement;
                onToggleMonitor(target.checked);
              },
            },
          ),
        ],
      ),
      if (stockMonitor)
        FormField(
          id: 'lowStockThreshold',
          labelText: 'Low Stock Threshold',
          type: InputType.number,
          attributes: {
            'placeholder': '5',
            'min': '0',
            'value': lowStockThreshold,
          },
          hintText: 'Alert when inventory falls below this count.',
          onChange: (value) => onThresholdChanged(value as String),
        ),
    ]);
  }
}
