import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/inventory/modals/returnable_products_count_row.dart';
import 'package:terminal/components/inventory/modals/returnable_products_header.dart';
import 'package:terminal/components/inventory/modals/returnable_products_list.dart';
import 'package:terminal/components/inventory/modals/returnable_products_search_bar.dart';
import 'package:terminal/signals/auth_signal.dart';
import 'package:terminal/signals/bottle_return_product_signal.dart';
import 'package:terminal/signals/bottle_return_signal.dart';
import 'package:terminal/utils/terminal_toast.dart';

/// Body content of the Returnable Products modal with search, bulk toggle, and product listing.
class ReturnableProductsBody extends StatefulWidget {
  const ReturnableProductsBody({super.key});

  @override
  State<ReturnableProductsBody> createState() => _ReturnableProductsBodyState();
}

class _ReturnableProductsBodyState extends State<ReturnableProductsBody> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    final storeId = authSignal.value.value?.storeId;
    if (storeId != null) BottleReturnProductActions.loadProducts(storeId);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _handleToggleProduct(
    String storeId,
    Map<String, dynamic> item,
    bool isReturnable,
  ) async {
    final name = item['name'] as String? ?? 'Product';
    final ok = await BottleReturnProductActions.toggleProduct(
      storeId: storeId,
      productId: item['productId'] as String,
      isReturnable: isReturnable,
    );
    if (!mounted) return;
    final desc =
        '$name marked as ${isReturnable ? 'returnable' : 'not returnable'}.';
    ok
        ? TerminalToast.showSuccess(
            context: context,
            title: 'Product Updated',
            description: desc,
          )
        : TerminalToast.showError(
            context: context,
            title: 'Update Failed',
            description: 'Failed to update $name.',
          );
  }

  Future<void> _handleToggleAll(String storeId, bool isReturnable) async {
    final ok = await BottleReturnProductActions.toggleAllProducts(
      storeId: storeId,
      isReturnable: isReturnable,
    );
    if (!mounted) return;
    final desc =
        'All products marked as ${isReturnable ? 'returnable' : 'not returnable'}.';
    ok
        ? TerminalToast.showSuccess(
            context: context,
            title: 'Catalog Updated',
            description: desc,
          )
        : TerminalToast.showError(
            context: context,
            title: 'Update Failed',
            description: 'Failed to update catalog status.',
          );
  }

  @override
  Widget build(BuildContext context) {
    final storeId = authSignal.value.value?.storeId ?? '';
    final rewardAmt =
        bottleReturnConfigSignal.value?.rewardAmountInRupees ?? 10;

    return SignalBuilder(
      builder: (context) {
        final productsState = bottleReturnProductsSignal.value;
        final allProducts = productsState.value ?? [];
        final q = _searchQuery.toLowerCase().trim();
        final filtered = allProducts.where((p) {
          if (q.isEmpty) return true;
          final name = (p['name'] as String? ?? '').toLowerCase();
          final cat = (p['categoryName'] as String? ?? '').toLowerCase();
          return name.contains(q) || cat.contains(q);
        }).toList();
        final returnableCount = allProducts
            .where((p) => p['isReturnable'] as bool? ?? false)
            .length;
        final areAllReturnable =
            allProducts.isNotEmpty && returnableCount == allProducts.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ReturnableProductsHeader(
              rewardAmount: rewardAmt,
              onClose: () => Navigator.of(context).pop(),
            ),
            const Gap(16),
            ReturnableProductsSearchBar(
              controller: _searchController,
              areAllReturnable: areAllReturnable,
              onSearchChanged: (val) => setState(() => _searchQuery = val),
              onToggleAll: (val) => _handleToggleAll(storeId, val),
            ),
            const Gap(12),
            ReturnableProductsCountRow(
              returnableCount: returnableCount,
              totalCount: allProducts.length,
              matchingCount: filtered.length,
              isSearching: _searchQuery.isNotEmpty,
            ),
            const Gap(8),
            Expanded(
              child: ReturnableProductsList(
                isLoading: productsState.isLoading,
                products: filtered,
                onToggleProduct: (prod, val) =>
                    _handleToggleProduct(storeId, prod, val),
              ),
            ),
          ],
        );
      },
    );
  }
}
