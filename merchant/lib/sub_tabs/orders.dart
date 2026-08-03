import 'package:date_format/date_format.dart' as df;
import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/generated_icons/chevron_down.dart';
import 'package:merchant/components/centered_message.dart';
import 'package:merchant/components/fields/date_range_picker.dart';
import 'package:merchant/components/fields/searchbar.dart';
import 'package:merchant/components/loading.dart';
import 'package:merchant/components/modals/order_details_modal.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/components/table_pagination.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/orders_signal.dart';
import 'package:merchant/signals/reports_date_signal.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:models/models.dart';
import 'package:web/web.dart' as web;

class Orders extends SignalComponent {
  const Orders({super.key});
  @override
  SignalState<Orders> createState() => _OrdersState();
}

class _OrdersState extends SignalState<Orders> {
  @override
  void initState() {
    super.initState();
    refreshOrdersSignal();
  }

  void _closeDropdowns() {
    final activeElement = web.document.activeElement;
    if (activeElement != null) {
      final element = activeElement as web.HTMLElement;
      element.blur();
      final details = element.closest('details');
      if (details != null) {
        details.removeAttribute('open');
      }
    }
  }

  void _changeEntry(int entry) {
    entriesSignal.value = entry;
    ordersPageSignal.value = 1;
    refreshOrdersSignal();
    _closeDropdowns();
  }

  String _formatDate(DateTime dt) =>
      df.formatDate(dt.toLocal(), [df.dd, '-', df.M, '-', df.yyyy]);

  String _formatPaymentType(PaymentMethod method) {
    return switch (method) {
      .cash => 'CASH',
      .upi => 'UPI',
      .complimentary => 'FREE',
    };
  }

  Component _buildPaymentModeFilter() {
    final currentMode = reportsPaymentMethodSignal.value;
    final label = switch (currentMode) {
      'cash' => 'Payment: Cash',
      'upi' => 'Payment: UPI',
      'complimentary' => 'Payment: Free',
      _ => 'Payment Mode: All',
    };

    return details(
      classes: 'dropdown dropdown-bottom dropdown-start inline-block',
      [
        summary(
          classes:
              'btn btn-sm rounded-full border border-border-medium bg-base-100 hover:bg-base-200 text-xs px-3 font-medium flex items-center gap-1.5 shadow-2xs cursor-pointer list-none select-none',
          [
            span(classes: 'text-xs text-base-content font-medium', [
              .text(label),
            ]),
            ChevronDown(classes: 'w-3.5 h-3.5 opacity-60'),
          ],
        ),
        ul(
          classes:
              'dropdown-content menu bg-base-100 rounded-2xl z-30 mt-2 p-2 shadow-xl border border-border-medium w-48 flex flex-col gap-1',
          [
            li([
              a(
                href: '#',
                classes:
                    'rounded-md text-xs hover:bg-neutral ${currentMode == null ? 'bg-neutral font-bold text-primary' : ''}',
                onClick: () {
                  reportsPaymentMethodSignal.value = null;
                  ordersPageSignal.value = 1;
                  refreshOrdersSignal();
                  _closeDropdowns();
                },
                [.text('All Payment Modes')],
              ),
            ]),
            li([
              a(
                href: '#',
                classes:
                    'rounded-md text-xs hover:bg-neutral ${currentMode == 'cash' ? 'bg-neutral font-bold text-primary' : ''}',
                onClick: () {
                  reportsPaymentMethodSignal.value = 'cash';
                  ordersPageSignal.value = 1;
                  refreshOrdersSignal();
                  _closeDropdowns();
                },
                [.text('Cash')],
              ),
            ]),
            li([
              a(
                href: '#',
                classes:
                    'rounded-md text-xs hover:bg-neutral ${currentMode == 'upi' ? 'bg-neutral font-bold text-primary' : ''}',
                onClick: () {
                  reportsPaymentMethodSignal.value = 'upi';
                  ordersPageSignal.value = 1;
                  refreshOrdersSignal();
                  _closeDropdowns();
                },
                [.text('UPI')],
              ),
            ]),
            li([
              a(
                href: '#',
                classes:
                    'rounded-md text-xs hover:bg-neutral ${currentMode == 'complimentary' ? 'bg-neutral font-bold text-primary' : ''}',
                onClick: () {
                  reportsPaymentMethodSignal.value = 'complimentary';
                  ordersPageSignal.value = 1;
                  refreshOrdersSignal();
                  _closeDropdowns();
                },
                [.text('Complimentary / Free')],
              ),
            ]),
          ],
        ),
      ],
    );
  }

  Component _buildStatusFilter() {
    final currentStatus = reportsOrderStatusSignal.value;
    final label = switch (currentStatus) {
      'completed' => 'Status: Completed',
      'pending' => 'Status: Pending',
      'preparing' => 'Status: Preparing',
      'cancelled' => 'Status: Cancelled',
      _ => 'Status: All',
    };

    return details(
      classes: 'dropdown dropdown-bottom dropdown-start inline-block',
      [
        summary(
          classes:
              'btn btn-sm rounded-full border border-border-medium bg-base-100 hover:bg-base-200 text-xs px-3 font-medium flex items-center gap-1.5 shadow-2xs cursor-pointer list-none select-none',
          [
            span(classes: 'text-xs text-base-content font-medium', [
              .text(label),
            ]),
            ChevronDown(classes: 'w-3.5 h-3.5 opacity-60'),
          ],
        ),
        ul(
          classes:
              'dropdown-content menu bg-base-100 rounded-2xl z-30 mt-2 p-2 shadow-xl border border-border-medium w-40 flex flex-col gap-1',
          [
            li([
              a(
                href: '#',
                classes:
                    'rounded-md text-xs hover:bg-neutral ${currentStatus == null ? 'bg-neutral font-bold text-primary' : ''}',
                onClick: () {
                  reportsOrderStatusSignal.value = null;
                  ordersPageSignal.value = 1;
                  refreshOrdersSignal();
                  _closeDropdowns();
                },
                [.text('All Statuses')],
              ),
            ]),
            li([
              a(
                href: '#',
                classes:
                    'rounded-md text-xs hover:bg-neutral ${currentStatus == 'completed' ? 'bg-neutral font-bold text-primary' : ''}',
                onClick: () {
                  reportsOrderStatusSignal.value = 'completed';
                  ordersPageSignal.value = 1;
                  refreshOrdersSignal();
                  _closeDropdowns();
                },
                [.text('Completed')],
              ),
            ]),
            li([
              a(
                href: '#',
                classes:
                    'rounded-md text-xs hover:bg-neutral ${currentStatus == 'pending' ? 'bg-neutral font-bold text-primary' : ''}',
                onClick: () {
                  reportsOrderStatusSignal.value = 'pending';
                  ordersPageSignal.value = 1;
                  refreshOrdersSignal();
                  _closeDropdowns();
                },
                [.text('Pending')],
              ),
            ]),
            li([
              a(
                href: '#',
                classes:
                    'rounded-md text-xs hover:bg-neutral ${currentStatus == 'preparing' ? 'bg-neutral font-bold text-primary' : ''}',
                onClick: () {
                  reportsOrderStatusSignal.value = 'preparing';
                  ordersPageSignal.value = 1;
                  refreshOrdersSignal();
                  _closeDropdowns();
                },
                [.text('Preparing')],
              ),
            ]),
            li([
              a(
                href: '#',
                classes:
                    'rounded-md text-xs hover:bg-neutral ${currentStatus == 'cancelled' ? 'bg-neutral font-bold text-primary' : ''}',
                onClick: () {
                  reportsOrderStatusSignal.value = 'cancelled';
                  ordersPageSignal.value = 1;
                  refreshOrdersSignal();
                  _closeDropdowns();
                },
                [.text('Cancelled')],
              ),
            ]),
          ],
        ),
      ],
    );
  }

  @override
  Component buildSignal(BuildContext context) {
    final entries = entriesSignal.value;
    final orders = ordersSignal.value;
    final currentPage = ordersPageSignal.value;
    final totalPages = ordersTotalPagesSignal.value;
    final store = storeSignal.value;
    final activeModal = activeModalSignal.value;
    final selectedOrderState = selectedOrderSignal.value;

    return div(
      classes:
          'flex flex-col flex-1 min-h-0 m-4 bg-white rounded-2xl border border-border-medium shadow-xs overflow-hidden',
      [
        if (activeModal == ActiveModal.orderDetails)
          OrderDetailsModal(state: selectedOrderState),

        div(
          classes:
              'flex flex-col md:items-center md:flex-row md:justify-between w-full border-b border-border-medium p-4 gap-4',
          [
            div(classes: 'flex flex-wrap items-center gap-3 text-sm font-medium', [
              span(classes: 'flex gap-2 items-center text-sm font-medium', [
                .text('Show'),
                div(classes: 'dropdown dropdown-bottom dropdown-center', [
                  div(
                    classes:
                        'btn rounded-full border border-border-medium bg-white hover:bg-base-200 text-sm h-8 min-h-0',
                    attributes: {
                      'tabindex': '0',
                      'role': 'button',
                    },
                    [
                      .text('$entries'),
                      ChevronDown(classes: 'w-4 h-4'),
                    ],
                  ),
                  ul(
                    attributes: {'tabindex': '-1'},
                    classes:
                        'dropdown-content menu bg-base-100 rounded-box z-10 mt-2.5 p-2 shadow-sm border border-border-light',
                    [
                      dropdownButton(
                        name: '10',
                        isSelected: entries == 10,
                        onClick: () => _changeEntry(10),
                      ),
                      dropdownButton(
                        name: '25',
                        isSelected: entries == 25,
                        onClick: () => _changeEntry(25),
                      ),
                      dropdownButton(
                        name: '50',
                        isSelected: entries == 50,
                        onClick: () => _changeEntry(50),
                      ),
                      dropdownButton(
                        name: '100',
                        isSelected: entries == 100,
                        onClick: () => _changeEntry(100),
                      ),
                    ],
                  ),
                ]),
                .text('entries'),
              ]),
              DateRangePicker(
                fromDate: reportsFromDateSignal.value,
                toDate: reportsToDateSignal.value,
                onFromDateChanged: (val) {
                  reportsFromDateSignal.value = val;
                  ordersPageSignal.value = 1;
                  refreshOrdersSignal();
                },
                onToDateChanged: (val) {
                  reportsToDateSignal.value = val;
                  ordersPageSignal.value = 1;
                  refreshOrdersSignal();
                },
              ),
              _buildPaymentModeFilter(),
              _buildStatusFilter(),
            ]),
            div(
              classes:
                  'flex justify-between gap-2 items-center w-full sm:w-auto',
              [
                Searchbar(
                  placeholder: 'Search Orders...',
                  classes: 'flex-1 sm:flex-none sm:w-64',
                ),
              ],
            ),
          ],
        ),

        if (storesSignal.value.isLoading || orders.isLoading)
          Loading(text: 'Loading orders...', fullScreen: false)
        else if (store == null)
          CenteredMessage(message: 'Create Store to view orders.')
        else if (orders.hasError)
          CenteredMessage(
            message: orders.error is ApiException
                ? (orders.error as ApiException).message
                : 'Failed to load orders. Please try again.',
          )
        else if (orders.hasValue && orders.value!.isEmpty)
          CenteredMessage(message: 'No Orders found.')
        else
          div(classes: 'flex-1 min-h-0 overflow-auto', [
            table(
              classes: 'table table-zebra table-pin-rows table-pin-cols',
              [
                tableHead(),
                tbody([
                  for (final order in orders.value!)
                    tableRow(
                      orderId: '${order.billNo}',
                      date: _formatDate(order.createdAt),
                      totalAmount: order.grandTotal,
                      paymentType: _formatPaymentType(order.paymentMethod),
                      status: order.status.name.toUpperCase(),
                      onClick: () => fetchOrderDetails(order.id),
                    ),
                ]),
              ],
            ),
          ]),

        TablePagination(
          currentPage: currentPage,
          totalPages: totalPages,
          onPageChanged: (page) {
            ordersPageSignal.value = page;
            refreshOrdersSignal();
          },
        ),
      ],
    );
  }

  thead tableHead() {
    return thead([
      tr([
        th([]),
        th([.text('Bill No')]),
        td([.text('Date')]),
        td([.text('Total Amount (₹)')]),
        td([.text('Payment Mode')]),
        td([.text('Status')]),
        th([]),
      ]),
    ]);
  }

  tr tableRow({
    required String orderId,
    required String date,
    required double totalAmount,
    required String paymentType,
    required String status,
    VoidCallback? onClick,
  }) {
    final isCompleted = status == 'COMPLETED';
    final isCash = paymentType == 'CASH';

    return tr(
      classes: 'hover:cursor-pointer',
      events: {
        if (onClick != null) 'click': (e) => onClick(),
      },
      [
        th([]),
        th(classes: 'whitespace-nowrap font-medium text-primary', [
          .text(orderId),
        ]),
        td(classes: 'whitespace-nowrap', [.text(date)]),
        td([.text(totalAmount.toStringAsFixed(2))]),
        td([
          div(
            classes:
                '${isCash ? 'bg-soft-blue text-soft-blue-content' : 'bg-soft-purple text-soft-purple-content'} rounded-full px-3 py-1 text-center text-xs font-semibold inline-block',
            [
              .text(paymentType),
            ],
          ),
        ]),
        td([
          div(
            classes:
                '${isCompleted ? 'bg-soft-green text-soft-green-content' : 'bg-soft-yellow text-soft-yellow-content'} rounded-full px-3 py-1 text-center text-xs font-semibold inline-block',
            [
              .text(status),
            ],
          ),
        ]),
        th([]),
      ],
    );
  }

  li dropdownButton({
    required String name,
    required bool isSelected,
    VoidCallback? onClick,
  }) {
    return li([
      a(
        href: '#',
        classes:
            'rounded-md text-xs hover:bg-neutral ${isSelected ? 'bg-neutral font-bold text-primary' : ''}',
        onClick: onClick,
        [
          .text(name),
        ],
      ),
    ]);
  }
}
