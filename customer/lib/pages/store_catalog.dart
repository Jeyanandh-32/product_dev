import 'package:client_repositories/client_repositories.dart';
import 'package:customer/components/signal_component.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:models/models.dart';
import 'package:signals/signals.dart';

class StoreCatalogPage extends SignalComponent {
  const StoreCatalogPage({super.key});

  @override
  SignalState<StoreCatalogPage> createState() => _StoreCatalogPageState();
}

class _StoreCatalogPageState extends SignalState<StoreCatalogPage> {
  late final onlineStoresSignal = asyncSignal<List<Store>>(const AsyncLoading());

  @override
  void initState() {
    super.initState();
    _fetchOnlineStores();
  }

  Future<void> _fetchOnlineStores() async {
    try {
      final stores = await StoreRepository.getOnlineStores();
      onlineStoresSignal.value = AsyncData(stores);
    } catch (e, stack) {
      onlineStoresSignal.value = AsyncError(e, stack);
    }
  }

  @override
  Component buildSignal(BuildContext context) {
    final storesState = onlineStoresSignal.value;

    return div(
      classes: 'min-h-screen bg-base-100 p-6 max-w-5xl mx-auto flex flex-col gap-6',
      [
        header(classes: 'flex flex-col gap-2', [
          h1(classes: 'text-3xl font-bold text-primary', [
            .text('Online Stores'),
          ]),
          p(classes: 'text-gray-500 text-sm', [
            .text('Select a store to view menu and order online.'),
          ]),
        ]),

        storesState.map(
          data: (stores) {
            if (stores.isEmpty) {
              return div(
                classes: 'p-12 text-center bg-base-200 rounded-2xl text-gray-500 font-medium',
                [
                  .text('No online stores available right now.'),
                ],
              );
            }

            return div(
              classes: 'grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4',
              [
                for (final store in stores)
                  div(
                    classes:
                        'card bg-white border border-border-medium rounded-xl p-5 shadow-xs flex flex-col gap-3 justify-between hover:border-accent transition-all cursor-pointer',
                    [
                      div(classes: 'flex flex-col gap-1', [
                        h2(classes: 'text-xl font-semibold text-primary', [
                          .text(store.name),
                        ]),
                        if (store.storeType != null)
                          span(
                            classes: 'text-xs text-gray-400 font-medium uppercase tracking-wider',
                            [
                              .text(store.storeType!),
                            ],
                          ),
                      ]),

                      div(classes: 'flex items-center justify-between pt-2 border-t border-border-light', [
                        span(classes: 'text-xs text-accent font-semibold', [
                          .text('/${store.slug ?? ''}'),
                        ]),
                        button(
                          classes: 'btn btn-sm btn-primary rounded-lg font-semibold',
                          [.text('View Menu')],
                        ),
                      ]),
                    ],
                  ),
              ],
            );
          },
          error: (error, _) => div(
            classes: 'p-6 bg-soft-red text-soft-red-content rounded-xl text-center',
            [
              .text('Failed to load online stores.'),
            ],
          ),
          loading: () => div(
            classes: 'flex justify-center p-12',
            [
              span(
                classes: 'loading loading-spinner loading-lg text-primary',
                [],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
