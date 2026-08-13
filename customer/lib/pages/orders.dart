import 'dart:js_interop';

import 'package:api_client/api_client.dart';
import 'package:client_repositories/client_repositories.dart';
import 'package:customer/components/signal_component.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router;
import 'package:jaspr_router/jaspr_router.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

import 'package:customer/utils/phonepe_interop.dart';
import 'package:web/web.dart' as web;

class CustomerOrdersPage extends SignalComponent {
  const CustomerOrdersPage({super.key});

  @override
  SignalState<CustomerOrdersPage> createState() => _CustomerOrdersPageState();
}

class _CustomerOrdersPageState extends SignalState<CustomerOrdersPage> {
  late final _ordersSignal = asyncSignal<PaginatedResponse<Order>>(
    const AsyncLoading(),
  );

  // Default date filter initialized to today (YYYY-MM-DD)
  late String _selectedDate = _formatDate(DateTime.now());

  // Selected tab: 'pending' (default) or 'completed'
  String _selectedTab = 'pending';

  // Modal QR state
  Order? _qrModalOrder;

  @override
  void initState() {
    super.initState();
    _fetchOrders();
  }

  String _formatDate(DateTime dt) {
    final y = dt.year;
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  Future<void> _fetchOrders() async {
    _ordersSignal.value = const AsyncLoading();
    try {
      final res = await OrderRepository.getCustomerOrders(
        date: _selectedDate,
        page: 1,
        size: 50,
      );
      _ordersSignal.value = AsyncData(res);
    } catch (e, st) {
      _ordersSignal.value = AsyncError(e, st);
    }
  }

  @override
  Component buildSignal(BuildContext context) {
    final state = _ordersSignal.value;

    return div(classes: 'flex flex-col gap-5 max-w-4xl mx-auto w-full min-h-[60vh]', [
      // Top Header & Date Picker Bar
      div(classes: 'flex flex-col sm:flex-row sm:items-center justify-between gap-4', [
        div(classes: 'flex items-center gap-3', [
          button(
            classes:
                'w-9 h-9 rounded-full bg-gray-100 hover:bg-gray-200 text-gray-700 flex items-center justify-center cursor-pointer border-0 transition-all active:scale-95 shrink-0',
            onClick: () => Router.of(context).push('/'),
            [
              ArrowLeft(classes: 'w-5 h-5'),
            ],
          ),
          h1(
            classes: 'text-2xl sm:text-3xl font-extrabold text-black tracking-tight',
            [
              .text('My Orders'),
            ],
          ),
        ]),

        // Mobile-responsive Date Picker Control
        div(classes: 'flex items-center justify-between sm:justify-start gap-2 bg-gray-50 border border-gray-200 rounded-2xl px-3.5 py-2 shadow-2xs w-full sm:w-auto', [
          div(classes: 'flex items-center gap-2', [
            Calendar(classes: 'w-4 h-4 text-gray-500 shrink-0'),
            span(classes: 'text-xs font-bold text-gray-600 shrink-0', [.text('Filter Date:')]),
          ]),
          input(
            type: .date,
            classes:
                'bg-transparent text-xs font-bold text-black focus:outline-none cursor-pointer text-right sm:text-left',
            attributes: {'value': _selectedDate},
            events: {
              'change': (event) {
                final target = event.target;
                if (target != null && target.isA<web.HTMLInputElement>()) {
                  final input = target as web.HTMLInputElement;
                  final val = input.value;
                  if (val.isNotEmpty && val != _selectedDate) {
                    setState(() => _selectedDate = val);
                    _fetchOrders();
                  }
                }
              },
              'input': (event) {
                final target = event.target;
                if (target != null && target.isA<web.HTMLInputElement>()) {
                  final input = target as web.HTMLInputElement;
                  final val = input.value;
                  if (val.isNotEmpty && val != _selectedDate) {
                    setState(() => _selectedDate = val);
                    _fetchOrders();
                  }
                }
              },
            },
          ),
        ]),
      ]),

      // Status Tabs Bar (Pending [Default] / Completed)
      div(classes: 'flex items-center p-1 bg-gray-100 rounded-2xl max-w-sm w-full gap-1 border border-gray-200/80', [
        button(
          classes: _selectedTab == 'pending'
              ? 'flex-1 py-2 px-4 rounded-xl bg-white text-black font-extrabold text-xs shadow-2xs transition-all border-0 cursor-pointer text-center'
              : 'flex-1 py-2 px-4 rounded-xl text-gray-500 hover:text-black font-bold text-xs transition-all border-0 cursor-pointer text-center',
          onClick: () => setState(() => _selectedTab = 'pending'),
          [
            .text('Pending Pickup'),
          ],
        ),
        button(
          classes: _selectedTab == 'completed'
              ? 'flex-1 py-2 px-4 rounded-xl bg-white text-black font-extrabold text-xs shadow-2xs transition-all border-0 cursor-pointer text-center'
              : 'flex-1 py-2 px-4 rounded-xl text-gray-500 hover:text-black font-bold text-xs transition-all border-0 cursor-pointer text-center',
          onClick: () => setState(() => _selectedTab = 'completed'),
          [
            .text('Completed'),
          ],
        ),
      ]),

      // Orders Content List
      switch (state) {
        AsyncData(:final value) => () {
            // Filter orders based on active tab
            final filteredOrders = value.items.where((o) {
              if (_selectedTab == 'pending') {
                return o.status != OrderStatus.completed;
              } else {
                return o.status == OrderStatus.completed;
              }
            }).toList();

            if (filteredOrders.isEmpty) {
              final dateParts = _selectedDate.split('-');
              final formattedDisplayDate = dateParts.length == 3
                  ? '${dateParts[2]}/${dateParts[1]}/${dateParts[0]}'
                  : _selectedDate;

              final emptyMsg = _selectedTab == 'pending'
                  ? 'No pending orders for $formattedDisplayDate.'
                  : 'No completed orders for $formattedDisplayDate.';

              return div(
                classes:
                    'flex-1 min-h-[40vh] text-center bg-gray-50/50 rounded-3xl text-gray-400 font-medium border border-dashed border-gray-200 flex flex-col items-center justify-center gap-3 p-8',
                [
                  ShoppingBag(classes: 'w-12 h-12 text-gray-300'),
                  h3(classes: 'text-lg font-bold text-gray-700', [
                    .text('No ${_selectedTab.toUpperCase()} orders'),
                  ]),
                  p(classes: 'text-xs text-gray-400 max-w-sm', [
                    .text(emptyMsg),
                  ]),
                  button(
                    classes:
                        'mt-2 px-5 py-2.5 rounded-full bg-black text-white text-xs font-bold hover:bg-gray-800 transition-all cursor-pointer shadow-sm',
                    onClick: () => Router.of(context).push('/'),
                    [
                      .text('Explore Stores'),
                    ],
                  ),
                ],
              );
            }

            return div(classes: 'flex flex-col gap-3', [
              for (final order in filteredOrders) _buildOrderTile(context, order),
            ]);
          }(),
        AsyncError() => div(
            classes:
                'flex-1 min-h-[30vh] bg-red-50 text-red-600 rounded-2xl text-center font-semibold border border-red-100 text-xs flex flex-col items-center justify-center gap-2 p-6',
            [
              .text('Failed to load your orders.'),
              button(
                classes: 'btn btn-xs bg-red-600 text-white border-0',
                onClick: _fetchOrders,
                [.text('Retry')],
              ),
            ],
          ),
        _ => div(
            classes: 'flex-1 min-h-[50vh] flex flex-col items-center justify-center gap-3 text-center',
            [
              span(
                classes: 'loading loading-spinner loading-lg text-black',
                [],
              ),
              p(classes: 'text-xs font-semibold text-gray-400', [
                .text('Loading orders...'),
              ]),
            ],
          ),
      },

      // QR Code Modal Dialog Overlay for Order Pickup Verification
      if (_qrModalOrder != null)
        div(
          classes:
              'fixed inset-0 z-50 bg-black/60 backdrop-blur-xs flex items-center justify-center p-4 animate-in fade-in duration-200',
          events: {'click': (_) => setState(() => _qrModalOrder = null)},
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
                  onClick: () => setState(() => _qrModalOrder = null),
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
                  .text('Order Pickup QR'),
                ]),

                p(classes: 'text-xs text-gray-500 font-medium -mt-2', [
                  .text(
                    'Show this QR code at the store counter for verification.',
                  ),
                ]),

                // QR Code Display (Instant Client-Side rendering + fast fallback)
                div(
                  classes:
                      'p-4 bg-white rounded-2xl border-2 border-gray-100 shadow-inner flex items-center justify-center min-w-[216px] min-h-[216px]',
                  [
                    div(
                      id: 'customer-qr-canvas',
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
                    .text(_qrModalOrder!.orderReference),
                  ]),
                ]),

                button(
                  classes:
                      'w-full mt-2 py-3 rounded-xl bg-black text-white font-bold text-xs cursor-pointer border-0 hover:bg-gray-800 transition-all',
                  onClick: () => setState(() => _qrModalOrder = null),
                  [
                    .text('Done'),
                  ],
                ),
              ],
            ),
          ],
        ),
    ]);
  }

  /// Compact Order List Tile Component
  Component _buildOrderTile(BuildContext context, Order order) {
    final formattedTime =
        '${order.createdAt.hour.toString().padLeft(2, '0')}:${order.createdAt.minute.toString().padLeft(2, '0')}';
    final dayStr = order.createdAt.day.toString().padLeft(2, '0');
    final monthStr = order.createdAt.month.toString().padLeft(2, '0');
    final formattedDate = '$dayStr/$monthStr/${order.createdAt.year}';

    // QR is visible ONLY if order is not completed yet (i.e. pending fulfillment)
    final isOrderCompleted = order.status == OrderStatus.completed;
    final showQrButton = !isOrderCompleted;

    return div(
      classes:
          'bg-white rounded-2xl border border-gray-200/90 p-4 sm:p-5 shadow-2xs hover:border-gray-300 transition-all flex flex-col gap-3.5',
      [
        // Top Tile Row: Bill No & Status Badge
        div(classes: 'flex items-center justify-between', [
          div(classes: 'flex items-center gap-3', [
            div(
              classes:
                  'w-10 h-10 rounded-xl bg-gray-100 text-black font-black text-sm flex items-center justify-center shrink-0 border border-gray-200/80',
              [
                .text('#${order.billNo}'),
              ],
            ),
            div(classes: 'flex flex-col min-w-0', [
              h3(classes: 'text-sm font-extrabold text-black truncate', [
                .text('Order #${order.billNo}'),
              ]),
              span(classes: 'text-xs text-gray-500 font-medium', [
                .text('$formattedDate at $formattedTime'),
              ]),
            ]),
          ]),

          span(
            classes: isOrderCompleted
                ? 'px-2.5 py-1 rounded-full text-xs font-bold bg-emerald-50 text-emerald-700 border border-emerald-200'
                : 'px-2.5 py-1 rounded-full text-xs font-bold bg-amber-50 text-amber-700 border border-amber-200',
            [
              .text(isOrderCompleted ? 'COMPLETED' : 'PENDING'),
            ],
          ),
        ]),



        // Bottom Tile Row: Total Amount & Equal-Width Action Buttons
        div(classes: 'flex flex-col sm:flex-row sm:items-center justify-between gap-3 pt-1 border-t border-gray-100', [
          div(classes: 'flex items-center gap-1.5', [
            span(classes: 'text-xs text-gray-500 font-medium', [.text('Total Amount:')]),
            span(classes: 'text-base font-extrabold text-black', [
              .text('₹${order.grandTotal.toStringAsFixed(2)}'),
            ]),
          ]),

          div(classes: 'flex items-center gap-2 w-full sm:w-auto', [
            if (showQrButton)
              button(
                classes:
                    'flex-1 sm:flex-none sm:w-32 justify-center flex items-center gap-1.5 px-4 py-2 rounded-xl bg-emerald-600 hover:bg-emerald-700 text-white font-bold text-xs transition-all cursor-pointer border-0 active:scale-95 shadow-2xs',
                onClick: () {
                  setState(() => _qrModalOrder = order);
                  Future.microtask(() {
                    renderQrCodeCanvas(
                      elementId: 'customer-qr-canvas',
                      text: order.orderReference,
                      size: 190,
                    );
                  });
                },
                [
                  QrCode(classes: 'w-3.5 h-3.5 text-white'),
                  .text('View QR'),
                ],
              ),

            button(
              classes: showQrButton
                  ? 'flex-1 sm:flex-none sm:w-32 justify-center flex items-center gap-1.5 px-4 py-2 rounded-xl bg-gray-100 hover:bg-black hover:text-white text-gray-800 font-bold text-xs transition-all cursor-pointer border-0 active:scale-95'
                  : 'w-full sm:w-36 justify-center flex items-center gap-1.5 px-4 py-2 rounded-xl bg-gray-100 hover:bg-black hover:text-white text-gray-800 font-bold text-xs transition-all cursor-pointer border-0 active:scale-95',
              onClick: () =>
                  Router.of(context).push('/order/status?reference=${order.orderReference}'),
              [
                .text('View Details'),
              ],
            ),
          ]),
        ]),
      ],
    );
  }
}
