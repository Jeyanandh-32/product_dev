import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide Store, Router;
import 'package:jaspr_router/jaspr_router.dart';
import 'package:merchant/components/navigation/store_selector_dropdown.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:models/models.dart';
import 'package:web/web.dart';

/// Top application header bar displaying page breadcrumb title and active store selector dropdown.
class Header extends SignalComponent {
  const Header({super.key});

  @override
  SignalState<Header> createState() => _HeaderState();
}

class _HeaderState extends SignalState<Header> {
  void _changeStore(Store store) {
    selectActiveStore(store);

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
    return ('Dashboard', null);
  }

  @override
  Component buildSignal(BuildContext context) {
    final store = storeSignal.value;
    final isNavOpen = navOpenSignal.value;
    final stores = storesSignal.value.value;
    final location = Router.of(context).matchList.uri.toString();
    final (headerTitle, headerSubTitle) = _getHeaderTitles(location);
    final hideStoreSelector = location == '/stores' || location == '/account';

    if (stores != null && stores.isNotEmpty) {
      if (store == null || !stores.any((st) => st.id == store.id)) {
        Future.microtask(() {
          selectActiveStore(resolvePreferredStore(stores));
        });
      }
    }

    return div(
      classes: 'w-full h-15 min-h-15 px-3 sm:px-4 lg:px-8 flex justify-between items-center gap-2 bg-white border-b border-border-medium shrink-0',
      [
        div(classes: 'flex items-center gap-2.5 lg:gap-0 min-w-0 flex-1 mr-1', [
          button(
            classes: 'block lg:hidden hover:cursor-pointer transition-all duration-300 shrink-0',
            onClick: () => navOpenSignal.value = !isNavOpen,
            [
              Menu(classes: 'w-5 h-5 text-gray-700'),
            ],
          ),

          h3(
            classes: 'font-semibold flex items-center gap-1 sm:gap-1.5 text-primary text-sm sm:text-base min-w-0 truncate',
            [
              span(classes: 'truncate font-bold', [.text(headerTitle)]),
              if (headerSubTitle != null) ...[
                span(
                  classes:
                      'text-gray-300 text-xs sm:text-sm font-normal shrink-0',
                  [
                    .text('/'),
                  ],
                ),
                span(
                  classes:
                      'text-xs sm:text-sm text-gray-500 font-medium truncate',
                  [
                    .text(headerSubTitle),
                  ],
                ),
              ],
            ],
          ),
        ]),

        if (store != null && !hideStoreSelector)
          StoreSelectorDropdown(
            store: store,
            stores: stores,
            onSelectStore: _changeStore,
          ),
      ],
    );
  }
}
