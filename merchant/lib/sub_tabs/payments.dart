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
import 'package:merchant/signals/payments_signal.dart';
import 'package:merchant/signals/reports_date_signal.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:models/models.dart';
import 'package:web/web.dart';

class Payments extends SignalComponent {
  const Payments({super.key});

  @override
  SignalState<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends SignalState<Payments> {
  @override
  void initState() {
    super.initState();
    refreshPaymentsSignal();
  }

  void _changeEntry(int entry) {
    entriesSignal.value = entry;
    paymentsPageSignal.value = 1;
    refreshPaymentsSignal();

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

  (String label, String badgeClass) _formatPaymentStatus(PaymentStatus status) {
    return switch (status) {
      PaymentStatus.paid => (
        'COMPLETED',
        'bg-emerald-50 text-emerald-700 border border-emerald-200',
      ),
      PaymentStatus.unpaid => (
        'PENDING',
        'bg-amber-50 text-amber-700 border border-amber-200',
      ),
      PaymentStatus.complimentary => (
        'COMPLETED',
        'bg-emerald-50 text-emerald-700 border border-emerald-200',
      ),
      PaymentStatus.refunded => (
        'CANCELLED',
        'bg-rose-50 text-rose-700 border border-rose-200',
      ),
      PaymentStatus.cancelled => (
        'CANCELLED',
        'bg-rose-50 text-rose-700 border border-rose-200',
      ),
    };
  }

  @override
  Component buildSignal(BuildContext context) {
    final entries = entriesSignal.value;
    final payments = paymentsSignal.value;
    final currentPage = paymentsPageSignal.value;
    final totalPages = paymentsTotalPagesSignal.value;
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
                  paymentsPageSignal.value = 1;
                  refreshPaymentsSignal();
                },
                onToDateChanged: (val) {
                  reportsToDateSignal.value = val;
                  paymentsPageSignal.value = 1;
                  refreshPaymentsSignal();
                },
              ),
            ]),
            div(
              classes:
                  'flex justify-between gap-2 items-center w-full sm:w-auto',
              [
                Searchbar(
                  placeholder: 'Search Payments...',
                  classes: 'flex-1 sm:flex-none sm:w-64',
                ),
              ],
            ),
          ],
        ),

        if (payments.isLoading)
          Loading(text: 'Loading payments...', fullScreen: false)
        else if (store == null)
          CenteredMessage(message: 'Create Store to view payments.')
        else if (payments.hasError)
          CenteredMessage(
            message: payments.error is ApiException
                ? (payments.error as ApiException).message
                : 'Failed to load payments. Please try again.',
          )
        else if (payments.hasValue && payments.value!.isEmpty)
          CenteredMessage(message: 'No Payments found.')
        else
          div(classes: 'flex-1 min-h-0 overflow-auto', [
            table(
              classes: 'table table-zebra table-pin-rows table-pin-cols',
              [
                tableHead(),
                tbody([
                  for (final payment in payments.value!)
                    tableRow(
                      orderReference: payment.orderReference,
                      date: _formatDate(payment.date),
                      orderId: payment.orderId,
                      orderAmount: payment.orderAmount,
                      paidAmount: payment.paidAmount,
                      paymentMode: _formatPaymentType(payment.paymentMode),
                      paymentStatus: payment.paymentStatus,
                    ),
                ]),
              ],
            ),
          ]),

        TablePagination(
          currentPage: currentPage,
          totalPages: totalPages,
          onPageChanged: (page) {
            paymentsPageSignal.value = page;
            refreshPaymentsSignal();
          },
        ),
      ],
    );
  }

  thead tableHead() {
    return thead([
      tr([
        th([]),
        td([.text('Order Reference')]),
        td([.text('Date')]),
        th([.text('Order ID')]),
        td([.text('Order Amount (₹)')]),
        td([.text('Paid Amount (₹)')]),
        td([.text('Payment Mode')]),
        td([.text('Payment Status')]),
        th([]),
      ]),
    ]);
  }

  tr tableRow({
    required String orderReference,
    required String date,
    required String orderId,
    required double orderAmount,
    required double paidAmount,
    required String paymentMode,
    required PaymentStatus paymentStatus,
  }) {
    final isCash = paymentMode == 'CASH';
    final (statusLabel, statusClass) = _formatPaymentStatus(paymentStatus);

    return tr([
      th([]),
      td(classes: 'whitespace-nowrap font-medium text-gray-700', [
        .text(orderReference),
      ]),
      td(classes: 'whitespace-nowrap', [.text(date)]),
      th(classes: 'whitespace-nowrap', [
        a(
          href: '#',
          classes: 'text-accent font-medium hover:underline',
          [.text(orderId)],
        ),
      ]),
      td([.text(orderAmount.toStringAsFixed(2))]),
      td(classes: 'font-semibold text-gray-900', [
        .text(paidAmount.toStringAsFixed(2)),
      ]),
      td([
        div(
          classes:
              '${isCash ? 'bg-soft-blue text-soft-blue-content' : 'bg-soft-purple text-soft-purple-content'} rounded-full px-3 py-1 text-center text-xs font-semibold inline-block',
          [
            .text(paymentMode),
          ],
        ),
      ]),
      td([
        div(
          classes:
              '$statusClass rounded-full px-3 py-1 text-center text-xs font-semibold inline-block',
          [
            .text(statusLabel),
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
