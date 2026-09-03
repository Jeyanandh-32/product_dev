import 'package:customer/components/modals/modal.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router;
import 'package:web/web.dart' as web;

class TopUpModal extends StatelessComponent {
  final double topUpAmount;
  final bool isLoading;
  final ValueChanged<double> onAmountChanged;
  final VoidCallback onConfirm;
  final VoidCallback onClose;

  const TopUpModal({
    super.key,
    required this.topUpAmount,
    required this.isLoading,
    required this.onAmountChanged,
    required this.onConfirm,
    required this.onClose,
  });

  @override
  Component build(BuildContext context) {
    return Modal(
      title: 'Top Up Wallet',
      onClose: onClose,
      child: div(classes: 'flex flex-col gap-6', [
        div(classes: 'flex flex-col gap-4', [
          label(
            classes: 'text-xs font-bold text-gray-700 uppercase tracking-wider',
            [
              .text('Select Amount (₹)'),
            ],
          ),
          div(classes: 'grid grid-cols-3 gap-2.5', [
            for (final amt in [100.0, 500.0, 1000.0])
              () {
                final isSelected = amt == topUpAmount;
                final style = isSelected
                    ? 'bg-emerald-50 text-emerald-700 border-emerald-500 font-extrabold shadow-2xs'
                    : 'bg-gray-50 text-gray-800 border-gray-200 hover:bg-gray-100';

                return button(
                  classes:
                      'py-3 rounded-2xl font-bold text-sm border cursor-pointer transition-all $style',
                  onClick: () => onAmountChanged(amt),
                  [.text('₹${amt.toInt()}')],
                );
              }(),
          ]),

          div(classes: 'flex flex-col gap-1.5 pt-2', [
            label(
              classes:
                  'text-xs font-bold text-gray-700 uppercase tracking-wider',
              [
                .text('Custom Amount (₹)'),
              ],
            ),
            input(
              type: InputType.number,
              classes: 'w-full px-4 py-3 rounded-2xl border border-gray-300 focus:border-black focus:outline-hidden text-base font-bold text-black bg-gray-50/50 font-mono',
              value: topUpAmount.toInt().toString(),
              events: {
                'input': (e) {
                  final input = e.target as web.HTMLInputElement;
                  final parsed = double.tryParse(input.value);
                  if (parsed != null && parsed > 0) {
                    onAmountChanged(parsed);
                  }
                },
              },
            ),
          ]),

          div(
            classes: 'bg-gray-50/80 rounded-2xl p-3.5 border border-gray-200/60 flex flex-col gap-2 text-xs',
            [
              div(classes: 'flex justify-between text-gray-600', [
                span([.text('Top Up Credit')]),
                span(classes: 'font-bold font-mono text-gray-900', [
                  .text('₹${topUpAmount.toStringAsFixed(2)}'),
                ]),
              ]),
              div(classes: 'flex justify-between text-gray-600', [
                span([.text('Gateway Charges (PhonePe)')]),
                span(classes: 'font-bold text-emerald-700 font-mono', [
                  .text('Free (₹0.00)'),
                ]),
              ]),
              div(
                classes: 'pt-1.5 border-t border-gray-200/60 flex justify-between font-bold text-gray-900',
                [
                  span([.text('Total to Pay')]),
                  span(classes: 'font-mono text-emerald-700 font-extrabold', [
                    .text('₹${topUpAmount.toStringAsFixed(2)}'),
                  ]),
                ],
              ),
            ],
          ),
        ]),

        div(
          classes: 'flex items-center justify-end gap-2 pt-2 border-t border-gray-100',
          [
            button(
              classes: 'px-4 py-2.5 rounded-xl bg-gray-100 hover:bg-gray-200 text-gray-700 font-bold text-xs transition-all border-0 cursor-pointer',
              onClick: onClose,
              [.text('Cancel')],
            ),
            button(
              classes: 'px-6 py-2.5 rounded-xl bg-emerald-50 hover:bg-emerald-600 text-emerald-700 hover:text-white border border-emerald-200/60 hover:border-emerald-600 font-bold text-xs transition-all cursor-pointer shadow-2xs flex items-center gap-2 active:scale-95',
              onClick: isLoading ? null : onConfirm,
              [
                if (isLoading)
                  span(
                    classes: 'loading loading-spinner loading-xs text-current',
                    [],
                  )
                else
                  Check(classes: 'w-4 h-4'),
                .text(isLoading ? 'Processing...' : 'Confirm Top Up'),
              ],
            ),
          ],
        ),
      ]),
    );
  }
}
