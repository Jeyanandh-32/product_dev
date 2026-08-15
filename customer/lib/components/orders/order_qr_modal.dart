import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router;

class OrderQrModal extends StatelessComponent {
  final String orderReference;
  final int billNo;
  final VoidCallback onClose;

  const OrderQrModal({
    super.key,
    required this.orderReference,
    required this.billNo,
    required this.onClose,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes:
          'fixed inset-0 bg-black/40 z-50 flex items-center justify-center px-4',
      events: {
        'click': (e) => onClose(),
      },
      [
        div(
          classes:
              'bg-white w-full max-w-sm rounded-3xl shadow-xl p-6 sm:p-8 flex flex-col items-center text-center gap-4 relative max-h-[90vh] overflow-y-auto',
          events: {'click': (e) => e.stopPropagation()},
          [
            // Close X Button
            button(
              classes:
                  'absolute top-4 right-4 w-8 h-8 rounded-full bg-gray-100 hover:bg-gray-200 text-gray-600 flex items-center justify-center cursor-pointer border-0',
              onClick: onClose,
              [
                X(classes: 'w-4 h-4'),
              ],
            ),

            // Header Badge
            div(
              classes:
                  'w-12 h-12 rounded-2xl bg-emerald-50 text-emerald-600 flex items-center justify-center',
              [
                QrCode(classes: 'w-6 h-6'),
              ],
            ),

            div(classes: 'flex flex-col gap-1', [
              h3(
                classes: 'text-xl font-extrabold text-black tracking-tight',
                [
                  .text('Order Verification QR'),
                ],
              ),
              p(classes: 'text-xs text-gray-500 font-medium', [
                .text(
                  'Present this QR code to the store merchant or counter staff to collect your order.',
                ),
              ]),
            ]),

            // Dynamic HTML Canvas QR Code Container
            div(
              classes:
                  'p-4 bg-white border-2 border-dashed border-gray-200 rounded-2xl flex items-center justify-center shadow-xs my-1',
              [
                Component.element(
                  tag: 'canvas',
                  id: 'customer-qr-canvas',
                  classes: 'rounded-lg',
                  children: [],
                ),
              ],
            ),

            div(classes: 'flex flex-col gap-0.5', [
              span(
                classes: 'text-xs font-bold text-gray-400 font-mono',
                [
                  .text('Order #$billNo'),
                ],
              ),
              span(
                classes:
                    'text-[11px] text-gray-500 font-mono tracking-tight break-all',
                [
                  .text(orderReference),
                ],
              ),
            ]),

            button(
              classes:
                  'w-full mt-2 py-3 rounded-xl bg-black text-white text-xs font-bold hover:bg-gray-800 transition-all border-0 cursor-pointer',
              onClick: onClose,
              [
                .text('Done'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
