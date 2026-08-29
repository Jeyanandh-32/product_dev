import 'package:client_repositories/client_repositories.dart';
import 'package:customer/components/signal_component.dart';
import 'package:customer/components/store/recent_stores_section.dart';
import 'package:customer/components/store/store_search_bar.dart';
import 'package:customer/components/store/store_search_results_grid.dart';
import 'package:customer/signals/cart_signal.dart';
import 'package:customer/signals/customer_auth_signal.dart';
import 'package:customer/signals/online_stores_signal.dart';
import 'package:customer/signals/recent_stores_signal.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';
import 'package:models/models.dart' as m;
import 'package:signals/signals.dart';
import 'package:web/web.dart' as web;

/// Store search and discovery landing page for customer application.
class StoreSearchPage extends SignalComponent {
  const StoreSearchPage({super.key});

  @override
  SignalState<StoreSearchPage> createState() => _StoreSearchPageState();
}

class _StoreSearchPageState extends SignalState<StoreSearchPage> {
  String _searchQuery = '';
  bool _isCheckingRedirect = true;

  @override
  void initState() {
    super.initState();
    clearActiveStore();
    refreshOnlineStoresSignal();
    _checkLastVisitedStore();
  }

  Future<void> _checkLastVisitedStore() async {
    final isExplicitDiscovery =
        web.window.location.search.contains('all=true') ||
        web.window.location.search.contains('switch=true');

    final customer = customerAuthSignal.value.value;

    if (!isExplicitDiscovery && customer != null) {
      try {
        final recentStores = await CustomerAuthRepository.getRecentStores();
        if (recentStores.isNotEmpty && mounted) {
          final lastStore = recentStores.first;
          if (lastStore.slug case final slug?
              when slug.isNotEmpty && lastStore.isOnlineEnabled) {
            Router.of(context).replace('/store/$slug');
            return;
          }
        }
      } catch (_) {}
    }

    if (mounted) {
      setState(() => _isCheckingRedirect = false);
    }
  }

  void _navigateToStore(m.Store store) {
    if (store.slug case final slug? when slug.isNotEmpty) {
      Router.of(context).push('/store/$slug');
    }
  }

  @override
  Component buildSignal(BuildContext context) {
    if (_isCheckingRedirect) {
      return div(classes: 'flex justify-center items-center min-h-[60vh]', [
        span(classes: 'loading loading-spinner loading-lg text-black', []),
      ]);
    }

    final storesState = onlineStoresSignal.value;
    final recentStoresState = recentStoresSignal.value;

    return div(classes: 'flex flex-col gap-6 w-full max-w-4xl mx-auto py-2', [
      StoreSearchBar(
        searchQuery: _searchQuery,
        onQueryChanged: (val) => setState(() => _searchQuery = val),
        onClear: () => setState(() => _searchQuery = ''),
      ),

      switch (recentStoresState) {
        AsyncData(value: final recentStores) => RecentStoresSection(
          recentStores: recentStores,
          onSelectStore: _navigateToStore,
        ),
        _ => div([]),
      },

      div(
        classes:
            'flex items-center justify-between border-t border-gray-200 pt-5',
        [
          h2(
            classes: 'text-base sm:text-lg font-bold text-black tracking-tight',
            [
              .text(
                _searchQuery.isEmpty ? 'All Online Stores' : 'Search Results',
              ),
            ],
          ),
        ],
      ),

      switch (storesState) {
        AsyncData(value: final stores) => StoreSearchResultsGrid(
          stores: stores,
          searchQuery: _searchQuery,
          onSelectStore: _navigateToStore,
        ),
        AsyncError() => div(
          classes: 'p-6 bg-red-50 text-red-600 rounded-2xl text-center font-semibold border border-red-100 text-xs',
          [
            .text('Failed to load stores from server.'),
          ],
        ),
        _ => div(
          classes: 'flex justify-center p-12',
          [
            span(
              classes: 'loading loading-spinner loading-lg text-black',
              [],
            ),
          ],
        ),
      },
    ]);
  }
}
