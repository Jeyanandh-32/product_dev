import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:merchant/components/cards/bottle_return_product_row.dart';
import 'package:merchant/components/centered_message.dart';
import 'package:merchant/components/containers/bottle_return_disabled_view.dart';
import 'package:merchant/components/containers/bottle_return_header.dart';
import 'package:merchant/components/containers/bottle_return_reward_card.dart';
import 'package:merchant/components/fields/searchbar.dart';
import 'package:merchant/components/loading.dart';
import 'package:merchant/components/modals/modal.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/signals/bottle_return_signal.dart';
import 'package:models/models.dart';
import 'package:web/web.dart' as web;

/// Modal for configuring store bottle return settings and returnable products.
class BottleReturnModal extends SignalComponent {
  const BottleReturnModal({super.key, required this.store});

  final Store store;

  @override
  SignalState<BottleReturnModal> createState() => _BottleReturnModalState();
}

class _BottleReturnModalState extends SignalState<BottleReturnModal> {
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Future.microtask(() => loadBottleReturnData(component.store.id));
  }

  @override
  Component buildSignal(BuildContext context) {
    final store = component.store;
    final cfg = bottleReturnConfigSignal.value;
    final isEnabled = cfg?.isEnabled ?? false;
    final rewardAmount = cfg?.rewardAmountInRupees ?? 10;
    final productsState = bottleReturnProductsSignal.value;
    final allProducts = productsState.value ?? [];

    final filtered = allProducts.where((item) {
      if (_searchQuery.trim().isEmpty) return true;
      final name = (item['name'] as String? ?? '').toLowerCase();
      final cat = (item['categoryName'] as String? ?? '').toLowerCase();
      final query = _searchQuery.toLowerCase().trim();
      return name.contains(query) || cat.contains(query);
    }).toList();

    final returnableCount = allProducts
        .where((item) => item['isReturnable'] as bool? ?? false)
        .length;
    final areAllReturnable =
        allProducts.isNotEmpty && returnableCount == allProducts.length;

    return Modal(
      title: 'Bottle Return Settings — ${store.name}',
      maxWidthClass: 'max-w-2xl',
      child: div(classes: 'flex flex-col gap-3 sm:gap-4', [
        BottleReturnHeader(
          store: store,
          isEnabled: isEnabled,
          returnableCount: returnableCount,
          onToggleStore: (val) => BottleReturnActions.saveStoreConfig(
            storeId: store.id,
            isEnabled: val,
            rewardAmount: rewardAmount,
          ),
        ),
        if (isEnabled) ...[
          BottleReturnRewardCard(
            rewardAmount: rewardAmount,
            onSaveReward: (newAmount) => BottleReturnActions.saveStoreConfig(
              storeId: store.id,
              isEnabled: isEnabled,
              rewardAmount: newAmount,
            ),
          ),
          Searchbar(
            placeholder: 'Search store products...',
            classes: 'w-full h-10 ring-1 ring-border-medium rounded-xl text-sm',
            onInput: (val) => setState(() => _searchQuery = val),
          ),
          div(classes: 'flex items-center justify-between gap-2.5', [
            div(
              classes: 'flex items-center gap-2 px-3 h-10 bg-neutral/50 border border-border-medium/60 rounded-xl',
              [
                span(classes: 'text-xs font-semibold text-gray-600', [
                  .text('Select All'),
                ]),
                input(
                  type: InputType.checkbox,
                  classes:
                      'toggle toggle-sm ${areAllReturnable ? 'toggle-success' : ''} hover:cursor-pointer shrink-0',
                  checked: areAllReturnable,
                  events: {
                    'change': (e) => BottleReturnActions.toggleAllProducts(
                      storeId: store.id,
                      isReturnable: (e.target as web.HTMLInputElement).checked,
                    ),
                  },
                ),
              ],
            ),
            span(
              classes: 'text-xs font-semibold text-gray-500 bg-neutral/80 px-3 rounded-xl whitespace-nowrap h-10 flex items-center justify-center shrink-0',
              [.text('$returnableCount / ${allProducts.length} Returnable')],
            ),
          ]),
          if (productsState.isLoading)
            Loading(text: 'Loading store items...', fullScreen: false)
          else if (filtered.isEmpty)
            CenteredMessage(message: 'No products found for this store.')
          else
            div(
              classes: 'flex flex-col gap-2 sm:gap-2.5 max-h-[42vh] sm:max-h-85 overflow-y-auto pr-0.5 sm:pr-1',
              [
                for (final item in filtered)
                  BottleReturnProductRow(
                    product: item,
                    onToggle: (val) => BottleReturnActions.toggleProduct(
                      storeId: store.id,
                      productId: item['productId'] as String,
                      isReturnable: val,
                    ),
                  ),
              ],
            ),
        ] else
          const BottleReturnDisabledView(),
      ]),
    );
  }
}
