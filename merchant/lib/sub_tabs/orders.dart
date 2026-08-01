import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/generated_icons/chevron_down.dart';
import 'package:merchant/components/centered_message.dart';
import 'package:merchant/components/fields/date_range_picker.dart';
import 'package:merchant/components/fields/searchbar.dart';
import 'package:merchant/components/loading.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/components/table_pagination.dart';
import 'package:merchant/exceptions/api_exception.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/orders_signal.dart';
import 'package:merchant/signals/reports_date_signal.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:models/models.dart';
import 'package:web/web.dart';

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

  void _changeEntry(int entry) {
    entriesSignal.value = entry;
    ordersPageSignal.value = 1;
    refreshOrdersSignal();

    final activeElement = document.activeElement;
    if (activeElement != null) {
      (activeElement as HTMLElement).blur();
    }
  }

  String _formatDate(DateTime dt) {
    final local = dt.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final month = months[local.month - 1];
    final year = local.year;
    return '$day-$month-$year';
  }

  String _formatPaymentType(PaymentMethod method) {
    return switch (method) {
      PaymentMethod.cash => 'CASH',
      PaymentMethod.upi => 'UPI',
      PaymentMethod.complimentary => 'FREE',
    };
  }

  @override
  Component buildSignal(BuildContext context) {
    final entries = entriesSignal.value;
    final orders = ordersSignal.value;
    final currentPage = ordersPageSignal.value;
    final totalPages = ordersTotalPagesSignal.value;
    final store = storeSignal.value;

    return div(
      classes:
          'flex flex-col flex-1 min-h-0 m-4 bg-white rounded-2xl border border-border-medium shadow-xs overflow-hidden',
      [
        div(
          classes:
              'flex flex-col md:items-center md:flex-row md:justify-between w-full border-b border-border-medium p-4 gap-4',
          [
            div(classes: 'flex flex-wrap items-center gap-4 text-sm font-medium', [
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
                        onClick: () => _changeEntry(10),
                      ),
                      dropdownButton(
                        name: '25',
                        onClick: () => _changeEntry(25),
                      ),
                      dropdownButton(
                        name: '50',
                        onClick: () => _changeEntry(50),
                      ),
                      dropdownButton(
                        name: '100',
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

        if (orders.isLoading)
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
        th([.text('Order ID')]),
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
  }) {
    final isCompleted = status == 'COMPLETED';
    final isCash = paymentType == 'CASH';

    return tr([
      th([]),
      th(classes: 'whitespace-nowrap', [
        a(
          href: '#',
          classes: 'text-accent font-medium hover:underline',
          [.text(orderId)],
        ),
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
    ]);
  }

  li dropdownButton({
    required String name,
    VoidCallback? onClick,
  }) {
    return li([
      a(
        href: '#',
        classes: 'rounded-md hover:bg-neutral',
        onClick: onClick,
        [
          .text(name),
        ],
      ),
    ]);
  }
}
