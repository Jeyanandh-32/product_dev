import 'package:client_repositories/client_repositories.dart';
import 'package:customer/components/signal_component.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router, Store;
import 'package:jaspr_router/jaspr_router.dart';
import 'package:models/models.dart';

import 'package:customer/utils/phonepe_interop.dart';

class OrderStatusPage extends SignalComponent {
  const OrderStatusPage({required this.reference, super.key});

  final String reference;

  @override
  SignalState<OrderStatusPage> createState() => _OrderStatusPageState();
}

class _OrderStatusPageState extends SignalState<OrderStatusPage> {
  Order? _order;
  bool _isLoading = true;
  String? _errorMessage;
  bool _showQrModal = false;

  @override
  void initState() {
    super.initState();
    _fetchOrderStatus();
  }

  Future<void> _fetchOrderStatus() async {
    try {
      final order = await OrderRepository.verifyStatus(
        reference: component.reference,
      );

      setState(() {
        _order = order;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        _isLoading = false;
      });
    }
  }

  @override
  Component buildSignal(BuildContext context) {
    if (_isLoading) {
      return div(
        classes: 'min-h-[60vh] flex flex-col items-center justify-center gap-4',
        [
          span(classes: 'loading loading-spinner loading-lg text-black', []),
          p(classes: 'text-sm font-semibold text-gray-500', [
            .text('Loading order details...'),
          ]),
        ],
      );
    }

    if (_errorMessage != null || _order == null) {
      return div(
        classes: 'min-h-[60vh] flex flex-col items-center justify-center gap-4 text-center px-4',
        [
          div(
            classes: 'w-16 h-16 rounded-full bg-red-50 text-red-500 flex items-center justify-center text-2xl font-bold',
            [
              .text('⚠️'),
            ],
          ),
          h1(classes: 'text-2xl font-extrabold text-black', [
            .text('Payment Status Pending'),
          ]),
          p(classes: 'text-sm text-gray-500 max-w-md', [
            .text('We are verifying your transaction with PhonePe. Reference: ${component.reference}'),
          ]),
          button(
            classes: 'mt-4 px-6 py-3 rounded-xl bg-black text-white text-sm font-bold cursor-pointer border-0',
            onClick: () => Router.of(context).push('/'),
            [
              .text('Return to Store Menu'),
            ],
          ),
        ],
      );
    }

    final order = _order!;
    final isCompleted = order.paymentStatus == PaymentStatus.completed;
    final isFailed = order.paymentStatus == PaymentStatus.failed || order.status == OrderStatus.cancelled;

    final iconBgClass = isCompleted
        ? 'w-20 h-20 rounded-full bg-emerald-50 text-emerald-600 flex items-center justify-center'
        : (isFailed
            ? 'w-20 h-20 rounded-full bg-red-50 text-red-600 flex items-center justify-center'
            : 'w-20 h-20 rounded-full bg-amber-50 text-amber-600 flex items-center justify-center');

    final titleText = isCompleted
        ? 'Order Confirmed!'
        : (isFailed ? 'Payment Failed / Cancelled' : 'Payment Pending');

    final statusTextClass = isCompleted
        ? 'font-bold text-emerald-600'
        : (isFailed ? 'font-bold text-red-600' : 'font-bold text-amber-600');

    return div(
      classes: 'max-w-3xl mx-auto w-full py-8 px-4 flex flex-col gap-6',
      [
        div(
          classes: 'bg-white rounded-3xl p-6 sm:p-8 border border-gray-200/80 shadow-sm flex flex-col items-center text-center gap-5 w-full',
          [
            div(
              classes: iconBgClass,
              [
                if (isCompleted) Check(classes: 'w-10 h-10 text-emerald-600')
                else if (isFailed) X(classes: 'w-10 h-10 text-red-600')
                else Clock(classes: 'w-10 h-10 text-amber-600'),
              ],
            ),
            h1(classes: 'text-3xl font-black text-black tracking-tight', [
              .text(titleText),
            ]),
            p(classes: 'text-sm text-gray-500 font-medium flex flex-col items-center gap-0.5', [
              span(classes: 'font-extrabold text-black text-base', [
                .text('Order No: #${order.billNo}'),
              ]),
              span(classes: 'text-xs text-gray-400 font-mono', [
                .text('Reference: ${order.orderReference}'),
              ]),
            ]),

            div(classes: 'w-full border-t border-gray-100 my-2', []),

            // Items Receipt List
            div(classes: 'w-full flex flex-col gap-3 text-left', [
              h3(classes: 'text-sm font-extrabold text-black uppercase tracking-wider', [
                .text('Order Items'),
              ]),
              ...order.items.map(
                (item) => div(classes: 'flex justify-between items-center text-sm', [
                  div(classes: 'flex items-center gap-2 text-gray-800 font-medium', [
                    span(classes: 'font-bold text-black', [.text('${item.quantity}x')]),
                    span([.text(item.product?.name ?? 'Product')]),
                  ]),
                  span(classes: 'font-semibold text-black', [
                    .text('₹${(item.unitPrice * item.quantity).toStringAsFixed(2)}'),
                  ]),
                ]),
              ),
            ]),

            div(classes: 'w-full border-t border-dashed border-gray-200 my-2', []),

            // Summary Breakdown
            div(classes: 'w-full flex flex-col gap-2 text-sm', [
              div(classes: 'flex justify-between text-gray-500', [
                span([.text('Payment Method')]),
                span(classes: 'font-semibold text-black', [.text('PhonePe (UPI)')]),
              ]),
              div(classes: 'flex justify-between text-gray-500', [
                span([.text('Payment Status')]),
                span(
                  classes: statusTextClass,
                  [.text(order.paymentStatus.name.toUpperCase())],
                ),
              ]),
              div(classes: 'flex justify-between text-base font-extrabold text-black pt-2 border-t border-gray-100', [
                span([.text('Total Amount')]),
                span([.text('₹${order.grandTotal.toStringAsFixed(2)}')]),
              ]),
            ]),

            if (isCompleted && order.status != OrderStatus.completed) ...[
              button(
                classes:
                    'w-full mt-2 py-3.5 rounded-2xl bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-sm flex items-center justify-center gap-2 cursor-pointer transition-all border-0 shadow-sm active:scale-98',
                onClick: () {
                  setState(() => _showQrModal = true);
                  Future.microtask(() {
                    renderQrCodeCanvas(
                      elementId: 'order-status-qr-canvas',
                      text: order.orderReference,
                      size: 190,
                    );
                  });
                },
                [
                  QrCode(classes: 'w-4 h-4 text-white'),
                  .text('Display Order Pickup QR'),
                ],
              ),
            ],

            button(
              classes:
                  'w-full mt-2 py-3.5 rounded-2xl bg-gray-100 hover:bg-gray-200 text-gray-900 font-bold text-sm flex items-center justify-center gap-2 cursor-pointer transition-all border-0 active:scale-98',
              onClick: () => Router.of(context).push('/'),
              [
                .text('Back to Store Menu'),
                ArrowRight(classes: 'w-4 h-4'),
              ],
            ),
          ],
        ),

        // QR Code Modal Dialog Overlay for Order Pickup Verification
        if (_showQrModal)
          div(
            classes:
                'fixed inset-0 z-50 bg-black/60 backdrop-blur-xs flex items-center justify-center p-4 animate-in fade-in duration-200',
            events: {'click': (_) => setState(() => _showQrModal = false)},
            [
              div(
                classes:
                    'bg-white rounded-3xl p-6 sm:p-8 max-w-sm w-full flex flex-col items-center text-center gap-4 shadow-2xl relative animate-in zoom-in-95 duration-200',
                attributes: {'onclick': 'event.stopPropagation()'},
                [
                  // Close X Button
                  button(
                    classes:
                        'absolute top-4 right-4 w-8 h-8 rounded-full bg-gray-100 hover:bg-gray-200 text-gray-600 flex items-center justify-center cursor-pointer border-0',
                    onClick: () => setState(() => _showQrModal = false),
                    [
                      X(classes: 'w-4 h-4'),
                    ],
                  ),

                  // Header Badge
                  div(
                    classes:
                        'w-12 h-12 rounded-full bg-emerald-50 text-emerald-600 flex items-center justify-center text-xl font-bold mt-1',
                    [
                      QrCode(classes: 'w-6 h-6'),
                    ],
                  ),

                  h2(classes: 'text-xl font-black text-black tracking-tight', [
                    .text('Order Verification QR'),
                  ]),

                  p(classes: 'text-xs text-gray-500 font-medium -mt-2', [
                    .text(
                      'Show this QR code at the counter for pickup verification & fulfillment.',
                    ),
                  ]),

                  // QR Code Display (Instant Client-Side rendering)
                  div(
                    classes:
                        'p-4 bg-white rounded-2xl border-2 border-gray-100 shadow-inner flex items-center justify-center min-w-[216px] min-h-[216px]',
                    [
                      div(
                        id: 'order-status-qr-canvas',
                        classes: 'w-48 h-48 flex items-center justify-center',
                        [],
                      ),
                    ],
                  ),

                  div(classes: 'flex flex-col gap-0.5 text-center', [
                    span(classes: 'text-xs font-bold text-gray-400 uppercase tracking-widest', [
                      .text('Order Reference'),
                    ]),
                    span(classes: 'text-sm font-extrabold text-black font-mono tracking-wider', [
                      .text(order.orderReference),
                    ]),
                  ]),

                  button(
                    classes:
                        'w-full mt-2 py-3 rounded-xl bg-black text-white font-bold text-xs cursor-pointer border-0 hover:bg-gray-800 transition-all',
                    onClick: () => setState(() => _showQrModal = false),
                    [
                      .text('Done'),
                    ],
                  ),
                ],
              ),
            ],
          ),
      ],
    );
  }
}
