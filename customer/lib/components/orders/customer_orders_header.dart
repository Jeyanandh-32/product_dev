import 'dart:js_interop';

import 'package:customer/signals/cart_signal.dart';
import 'package:customer/utils/customer_navigation.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router;
import 'package:web/web.dart' as web;

/// Header toolbar for the customer orders page including back navigation and store scope indicators.
class CustomerOrdersHeader extends StatelessComponent {
  final String selectedDate;
  final ValueChanged<String> onDateChanged;

  const CustomerOrdersHeader({
    super.key,
    required this.selectedDate,
    required this.onDateChanged,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes:
          'flex flex-col sm:flex-row sm:items-center justify-between gap-4',
      [
        div(classes: 'flex items-center gap-3', [
          button(
            classes:
                'w-9 h-9 rounded-full bg-gray-100 hover:bg-gray-200 text-gray-700 flex items-center justify-center cursor-pointer border-0 transition-all active:scale-95 shrink-0',
            onClick: () => navigateToRecentStoreOrAll(context),
            [ArrowLeft(classes: 'w-5 h-5')],
          ),
          div(classes: 'flex flex-col', [
            h1(
              classes:
                  'text-2xl sm:text-3xl font-extrabold text-black tracking-tight',
              [.text('My Orders')],
            ),
            if (currentCartStoreSignal.value case final store?)
              span(classes: 'text-xs font-bold text-emerald-700', [
                .text(
                  'Showing orders for: ${store.name}',
                ),
              ])
            else
              span(classes: 'text-xs font-semibold text-gray-400', [
                .text('Showing all orders across stores'),
              ]),
          ]),
        ]),

        // Mobile-responsive Date Picker Control
        div(
          classes:
              'flex items-center justify-between sm:justify-start gap-2 bg-gray-50 border border-gray-200 rounded-2xl px-3.5 py-2 shadow-2xs w-full sm:w-auto',
          [
            div(classes: 'flex items-center gap-2', [
              Calendar(classes: 'w-4 h-4 text-gray-500 shrink-0'),
              span(
                classes: 'text-xs font-bold text-gray-600 shrink-0',
                [.text('Filter Date:')],
              ),
            ]),
            input(
              type: .date,
              classes:
                  'bg-transparent text-xs font-bold text-black focus:outline-none cursor-pointer text-right sm:text-left',
              attributes: {'value': selectedDate},
              events: {
                'change': (event) {
                  final target = event.target;
                  if (target != null && target.isA<web.HTMLInputElement>()) {
                    final input = target as web.HTMLInputElement;
                    final val = input.value;
                    if (val.isNotEmpty && val != selectedDate) {
                      onDateChanged(val);
                    }
                  }
                },
                'input': (event) {
                  final target = event.target;
                  if (target != null && target.isA<web.HTMLInputElement>()) {
                    final input = target as web.HTMLInputElement;
                    final val = input.value;
                    if (val.isNotEmpty && val != selectedDate) {
                      onDateChanged(val);
                    }
                  }
                },
              },
            ),
          ],
        ),
      ],
    );
  }
}
