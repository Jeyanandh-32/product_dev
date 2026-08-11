import 'package:customer/components/signal_component.dart';
import 'package:customer/signals/customer_auth_signal.dart';
import 'package:customer/signals/online_stores_signal.dart';
import 'package:customer/signals/recent_stores_signal.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/generated_icons/store.dart' as icon;
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router, Store;
import 'package:jaspr_router/jaspr_router.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

class StoreSearchPage extends SignalComponent {
  const StoreSearchPage({super.key});

  @override
  SignalState<StoreSearchPage> createState() => _StoreSearchPageState();
}

class _StoreSearchPageState extends SignalState<StoreSearchPage> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    refreshOnlineStoresSignal();
    refreshRecentStoresSignal();
  }

  void _navigateToStore(Store store) {
    if (store.slug != null && store.slug!.isNotEmpty) {
      recordStoreVisitSignal(store.id);
      Router.of(context).push('/store/${store.slug!}');
    }
  }

  @override
  Component buildSignal(BuildContext context) {
    final storesState = onlineStoresSignal.value;
    final recentStoresState = recentStoresSignal.value;
    final customer = customerAuthSignal.value.value;

    return div(classes: 'flex flex-col gap-5 sm:gap-6 w-full', [
      // Compact Header Greeting Section
      div(classes: 'flex flex-col gap-1', [
        h1(
          classes: 'text-xl sm:text-2xl md:text-3xl font-extrabold text-black tracking-tight leading-snug',
          [
            .text(
              customer != null ? 'Welcome, ${customer.name}' : 'Discover Local Merchants',
            ),
          ],
        ),
        p(classes: 'text-xs text-gray-500 font-medium', [
          .text(
            'Order directly from registered stores for takeaway pickup.',
          ),
        ]),
      ]),

      // Compact Search Bar Capsule
      div(classes: 'w-full flex flex-col sm:flex-row gap-3 items-center', [
        label(
          classes:
              'w-full flex items-center gap-3 px-3.5 sm:px-4 h-11 sm:h-12 bg-gray-50 hover:bg-gray-100/90 rounded-xl border border-gray-200 shadow-2xs transition-all cursor-text focus-within:bg-white focus-within:border-black focus-within:ring-1 focus-within:ring-black',
          [
            Search(classes: 'w-4 h-4 text-gray-500 shrink-0'),
            input(
              type: .search,
              classes:
                  'grow w-full bg-transparent text-xs sm:text-sm text-black font-medium focus:outline-none placeholder:text-gray-400',
              attributes: {
                'placeholder': 'Search store by name or slug...',
                'value': _searchQuery,
              },
              onInput: (value) => setState(() => _searchQuery = (value as String?) ?? ''),
            ),
            if (_searchQuery.isNotEmpty)
              button(
                classes: 'btn btn-ghost btn-xs btn-circle text-gray-400 hover:text-black cursor-pointer',
                onClick: () => setState(() => _searchQuery = ''),
                [
                  X(classes: 'w-4 h-4'),
                ],
              ),
          ],
        ),
      ]),

      // Recently Visited Stores Section
      switch (recentStoresState) {
        AsyncData(value: final recentStores) when recentStores.isNotEmpty => div(
          classes: 'flex flex-col gap-3 border-t border-gray-200 pt-5',
          [
            div(classes: 'flex items-center justify-between', [
              h2(
                classes: 'text-xs font-bold uppercase tracking-wider text-gray-400 flex items-center gap-2',
                [
                  Clock(classes: 'w-4 h-4 text-gray-400'),
                  .text('Recently Visited'),
                ],
              ),
            ]),
            div(
              classes: 'flex gap-3 overflow-x-auto pb-2 scrollbar-none -mx-4 px-4 sm:mx-0 sm:px-0',
              [
                for (final store in recentStores)
                  div(
                    classes:
                        'bg-white rounded-2xl p-3.5 min-w-[200px] sm:min-w-[240px] border border-gray-200 hover:border-black transition-all cursor-pointer flex items-center gap-3 shrink-0 group shadow-2xs',
                    events: {'click': (e) => _navigateToStore(store)},
                    [
                      div(
                        classes:
                            'w-10 h-10 rounded-xl bg-gray-100 text-black flex items-center justify-center font-bold shrink-0 group-hover:bg-black group-hover:text-white transition-colors',
                        [
                          icon.Store(classes: 'w-5 h-5'),
                        ],
                      ),
                      div(classes: 'flex flex-col min-w-0', [
                        h3(
                          classes: 'text-sm font-bold text-black truncate group-hover:opacity-80',
                          [
                            .text(store.name),
                          ],
                        ),
                        if (store.storeType != null)
                          span(
                            classes: 'text-xs text-gray-400 font-medium truncate',
                            [
                              .text(store.storeType!),
                            ],
                          ),
                      ]),
                    ],
                  ),
              ],
            ),
          ],
        ),
        _ => div([]),
      },

      // Section Divider & Title
      div(
        classes: 'flex items-center justify-between border-t border-gray-200 pt-5',
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

      // Ultra-Minimalist Store Cards / List Responsive Layout
      switch (storesState) {
        AsyncData(value: final stores) => () {
          final query = _searchQuery.trim().toLowerCase();
          final filtered = stores.where((store) {
            if (query.isEmpty) return true;
            return store.name.toLowerCase().contains(query) ||
                (store.slug?.toLowerCase().contains(query) ?? false) ||
                (store.storeType?.toLowerCase().contains(query) ?? false);
          }).toList();

          if (filtered.isEmpty) {
            return div(
              classes:
                  'p-12 sm:p-16 text-center bg-gray-50/50 rounded-3xl text-gray-400 font-medium border border-dashed border-gray-200 flex flex-col items-center gap-3',
              [
                SearchX(classes: 'w-10 h-10 text-gray-300'),
                .text(
                  query.isEmpty ? 'No online stores available currently.' : 'No online stores match your search query.',
                ),
              ],
            );
          }

          return div(
            classes: 'flex flex-col gap-3 w-full',
            [
              for (final store in filtered) _buildStoreRow(store),
            ],
          );
        }(),
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

  /// Clean Minimalist Store List Row Item (Fully Responsive Stack on Mobile)
  Component _buildStoreRow(Store store) {
    return div(
      classes:
          'bg-white rounded-2xl p-3.5 sm:p-4 border border-gray-200 hover:border-black transition-all cursor-pointer flex flex-col sm:flex-row sm:items-center justify-between gap-3 sm:gap-4 group shadow-2xs hover:shadow-xs w-full',
      events: {'click': (e) => _navigateToStore(store)},
      [
        div(classes: 'flex items-center gap-3 sm:gap-4 min-w-0 w-full sm:w-auto', [
          div(
            classes:
                'w-10 h-10 sm:w-12 sm:h-12 rounded-xl bg-gray-100 text-black flex items-center justify-center font-bold group-hover:bg-black group-hover:text-white transition-colors shrink-0',
            [
              icon.Store(classes: 'w-5 h-5 sm:w-6 sm:h-6'),
            ],
          ),
          div(classes: 'flex flex-col min-w-0 flex-1', [
            h3(
              classes:
                  'text-sm sm:text-base font-extrabold text-black group-hover:opacity-80 transition-opacity truncate',
              [
                .text(store.name),
              ],
            ),
            div(
              classes: 'flex items-center gap-2 text-xs text-gray-400 font-medium truncate',
              [
                if (store.storeType != null)
                  span(classes: 'truncate', [
                    .text(store.storeType!),
                  ]),
                if (store.slug != null) ...[
                  span([.text('•')]),
                  span(classes: 'text-black font-mono truncate', [
                    .text('/${store.slug}'),
                  ]),
                ],
              ],
            ),
          ]),
        ]),

        div(
          classes:
              'w-full sm:w-auto px-5 py-2.5 rounded-xl bg-gray-100 group-hover:bg-black text-black group-hover:text-white font-extrabold text-xs sm:text-sm flex items-center justify-center gap-2 transition-all shrink-0 shadow-2xs',
          [
            .text('Open Store Menu'),
            ArrowRight(classes: 'w-4 h-4'),
          ],
        ),
      ],
    );
  }
}
