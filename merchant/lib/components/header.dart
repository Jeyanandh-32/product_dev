import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide Store, Router;
import 'package:jaspr_router/jaspr_router.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/signals/categories_signal.dart';
import 'package:merchant/signals/counters_signal.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/orders_signal.dart';
import 'package:merchant/signals/payments_signal.dart';
import 'package:merchant/signals/products_signal.dart';
import 'package:merchant/signals/profit_loss_signal.dart';
import 'package:merchant/signals/stock_summary_signal.dart';
import 'package:merchant/signals/stores_signal.dart';

import 'package:models/models.dart';
import 'package:web/web.dart';

class Header extends SignalComponent {
  const Header({super.key});

  @override
  SignalState<Header> createState() => _HeaderState();
}

class _HeaderState extends SignalState<Header> {
  void _changeStore(Store store) {
    storeSignal.value = store;
    refreshProductsSignal();
    refreshCategoriesSignal();
    refreshCountersSignal();
    refreshOrdersSignal();
    refreshPaymentsSignal();
    refreshProfitLossSignal();
    refreshStockSummarySignal();

    final activeElement = document.activeElement;
    if (activeElement != null) {
      (activeElement as HTMLElement).blur();
    }
  }

  (String title, String? subTitle) _getHeaderTitles(String location) {
    if (location.startsWith('/inventory')) {
      if (location == '/inventory/categories') {
        return ('Inventory', 'Category');
      }
      if (location == '/inventory/counters') {
        return ('Inventory', 'Counters');
      }
      return ('Inventory', 'Products');
    }
    if (location.startsWith('/reports')) {
      if (location == '/reports/payments') {
        return ('Reports', 'Payments');
      }
      if (location == '/reports/profit-loss') {
        return ('Reports', 'Profit & Loss');
      }
      if (location == '/reports/stock-summary') {
        return ('Reports', 'Stock Summary');
      }
      return ('Reports', 'Orders');
    }
    if (location == '/stores') {
      return ('Stores', null);
    }
    if (location == '/account') {
      return ('Account', null);
    }
    if (location == '/settings') {
      return ('Settings', null);
    }
    return ('Dashboard', null);
  }

  @override
  Component buildSignal(BuildContext context) {
    final store = storeSignal.value;
    final isNavOpen = navOpenSignal.value;
    final stores = storesSignal.value.value;
    final location = Router.of(context).matchList.uri.toString();
    final (headerTitle, headerSubTitle) = _getHeaderTitles(location);
    final isStoresPage = location == '/stores';

    if (stores != null && stores.isNotEmpty) {
      if (store == null || !stores.any((st) => st.id == store.id)) {
        Future.microtask(() {
          storeSignal.value = stores.first;
          refreshProductsSignal();
          refreshCategoriesSignal();
          refreshCountersSignal();
          refreshOrdersSignal();
          refreshPaymentsSignal();
          refreshProfitLossSignal();
          refreshStockSummarySignal();
        });
      }
    }

    return div(
      classes:
          'w-full h-15 px-4 lg:px-8 flex justify-between items-center bg-white border-b border-border-medium',
      [
        div(classes: 'flex items-center gap-3 lg:gap-0', [
          button(
            classes:
                'block lg:hidden hover:cursor-pointer transition-all duration-300',
            onClick: () => navOpenSignal.value = !isNavOpen,
            [
              Menu(classes: 'w-5 h-5'),
            ],
          ),

          h3(classes: 'font-semibold flex items-center gap-1.5 text-primary', [
            .text(headerTitle),
            if (headerSubTitle != null) ...[
              span(classes: 'text-gray-300 text-sm font-normal', [.text('/')]),
              span(classes: 'text-sm text-gray-400 font-normal', [
                .text(headerSubTitle),
              ]),
            ],
          ]),
        ]),

        if (store != null && !isStoresPage)
          div(classes: 'dropdown dropdown-bottom dropdown-end', [
            div(
              classes:
                  'btn rounded-full border border-border-medium px-4 bg-white hover:bg-base-200 text-sm h-8 min-h-0',
              attributes: {
                'tabindex': '0',
                'role': 'button',
              },
              [
                .text(store.name),
                ChevronDown(classes: 'w-4 h-4'),
              ],
            ),

            ul(
              attributes: {'tabindex': '-1'},
              classes:
                  'dropdown-content menu bg-base-100 rounded-box z-10 mt-2.5 w-52 p-2 shadow-sm border border-border-light',
              [
                if (stores != null)
                  for (final s in stores)
                    dropdownButton(
                      name: s.name,
                      onClick: () => _changeStore(s),
                    ),
              ],
            ),
          ]),
      ],
    );
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
