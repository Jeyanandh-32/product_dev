import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/generated_icons/chevron_down.dart';
import 'package:merchant/components/fields/searchbar.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/components/table_pagination.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:models/models.dart';
import 'package:web/web.dart';

class PaymentItem {
  final String orderReference;
  final String date;
  final String orderId;
  final double orderAmount;
  final double paidAmount;
  final PaymentMethod paymentMode;

  const PaymentItem({
    required this.orderReference,
    required this.date,
    required this.orderId,
    required this.orderAmount,
    required this.paidAmount,
    required this.paymentMode,
  });
}

class Payments extends SignalComponent {
  const Payments({super.key});

  @override
  SignalState<Payments> createState() => _PaymentsState();
}

class _PaymentsState extends SignalState<Payments> {
  int _currentPage = 1;

  final List<PaymentItem> _mockPayments = const [
    PaymentItem(
      orderReference: 'REF-2026-001',
      date: '01-Aug-2026 10:30 AM',
      orderId: '1001',
      orderAmount: 35.06,
      paidAmount: 35.06,
      paymentMode: PaymentMethod.cash,
    ),
    PaymentItem(
      orderReference: 'REF-2026-002',
      date: '01-Aug-2026 11:15 AM',
      orderId: '1002',
      orderAmount: 120.50,
      paidAmount: 120.50,
      paymentMode: PaymentMethod.upi,
    ),
    PaymentItem(
      orderReference: 'REF-2026-003',
      date: '01-Aug-2026 12:45 PM',
      orderId: '1003',
      orderAmount: 450.00,
      paidAmount: 450.00,
      paymentMode: PaymentMethod.cash,
    ),
    PaymentItem(
      orderReference: 'REF-2026-004',
      date: '01-Aug-2026 01:20 PM',
      orderId: '1004',
      orderAmount: 89.99,
      paidAmount: 89.99,
      paymentMode: PaymentMethod.upi,
    ),
  ];

  void _changeEntry(int entry) {
    entriesSignal.value = entry;
    _currentPage = 1;
    setState(() {});

    final activeElement = document.activeElement;
    if (activeElement != null) {
      (activeElement as HTMLElement).blur();
    }
  }

  String _formatPaymentType(PaymentMethod method) {
    return switch (method) {
      PaymentMethod.cash => 'CASH',
      PaymentMethod.upi => 'UPI',
    };
  }

  @override
  Component buildSignal(BuildContext context) {
    final entries = entriesSignal.value;

    return div(
      classes:
          'flex flex-col flex-1 min-h-0 m-4 bg-white rounded-2xl border border-border-medium shadow-xs overflow-hidden',
      [
        div(
          classes:
              'flex flex-col md:items-center md:flex-row md:justify-between w-full border-b border-border-medium p-4 gap-4',
          [
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

        div(classes: 'flex-1 min-h-0 overflow-auto', [
          table(
            classes: 'table table-zebra table-pin-rows table-pin-cols',
            [
              tableHead(),
              tbody([
                for (final item in _mockPayments)
                  tableRow(
                    orderReference: item.orderReference,
                    date: item.date,
                    orderId: item.orderId,
                    orderAmount: item.orderAmount,
                    paidAmount: item.paidAmount,
                    paymentMode: _formatPaymentType(item.paymentMode),
                  ),
              ]),
            ],
          ),
        ]),

        TablePagination(
          currentPage: _currentPage,
          totalPages: 1,
          onPageChanged: (page) {
            setState(() {
              _currentPage = page;
            });
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
  }) {
    final isCash = paymentMode == 'CASH';

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
