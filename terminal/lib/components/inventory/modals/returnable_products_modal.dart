import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/inventory/modals/returnable_product_row.dart';
import 'package:terminal/components/inventory/modals/returnable_products_header.dart';
import 'package:terminal/components/inventory/modals/returnable_products_search_bar.dart';
import 'package:terminal/signals/auth_signal.dart';
import 'package:terminal/signals/bottle_return_product_signal.dart';
import 'package:terminal/signals/bottle_return_signal.dart';
import 'package:terminal/utils/terminal_toast.dart';

/// Modal for managing store returnable bottle products and bulk toggling.
class ReturnableProductsModal extends StatefulWidget {
  const ReturnableProductsModal({super.key});

  /// Displays the Returnable Products management dialog.
  static Future<void> show(BuildContext context) =>
      showDialog(context: context, builder: (_) => const ReturnableProductsModal());

  @override
  State<ReturnableProductsModal> createState() => _ReturnableProductsModalState();
}

class _ReturnableProductsModalState extends State<ReturnableProductsModal> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    final storeId = authSignal.value.value?.storeId;
    if (storeId != null) {
      BottleReturnProductActions.loadProducts(storeId);
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final storeId = authSignal.value.value?.storeId ?? '';
    final rewardAmt = bottleReturnConfigSignal.value?.rewardAmountInRupees ?? 10;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Container(
        width: 580,
        height: 600,
        padding: const EdgeInsets.all(22),
        child: SignalBuilder(
          builder: (context) {
            final productsState = bottleReturnProductsSignal.value;
            final allProducts = productsState.value ?? [];
            final filtered = allProducts.where((p) {
              if (_searchQuery.trim().isEmpty) return true;
              final name = (p['name'] as String? ?? '').toLowerCase();
              final cat = (p['categoryName'] as String? ?? '').toLowerCase();
              final q = _searchQuery.toLowerCase().trim();
              return name.contains(q) || cat.contains(q);
            }).toList();

            final returnableCount = allProducts.where((p) => p['isReturnable'] as bool? ?? false).length;
            final areAllReturnable = allProducts.isNotEmpty && returnableCount == allProducts.length;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ReturnableProductsHeader(rewardAmount: rewardAmt, onClose: () => Navigator.of(context).pop()),
                const Gap(16),
                ReturnableProductsSearchBar(
                  controller: _searchController,
                  areAllReturnable: areAllReturnable,
                  onSearchChanged: (val) => setState(() => _searchQuery = val),
                  onToggleAll: (val) => _handleToggleAll(storeId, val),
                ),
                const Gap(12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('$returnableCount of ${allProducts.length} products returnable', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF64748B))),
                    if (_searchQuery.isNotEmpty) Text('${filtered.length} matching search', style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
                  ],
                ),
                const Gap(8),
                Expanded(
                  child: productsState.isLoading
                      ? const Center(child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF16A34A)))
                      : filtered.isEmpty
                          ? Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
                              child: const Text('No matching products found.', style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
                            )
                          : ListView.separated(
                              itemCount: filtered.length,
                              separatorBuilder: (context, index) => const Gap(8),
                              itemBuilder: (context, index) {
                                final item = filtered[index];
                                return ReturnableProductRow(
                                  product: item,
                                  onToggle: (val) => _handleToggleProduct(storeId, item, val),
                                );
                              },
                            ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Future<void> _handleToggleProduct(String storeId, Map<String, dynamic> item, bool isReturnable) async {
    final name = item['name'] as String? ?? 'Product';
    final success = await BottleReturnProductActions.toggleProduct(storeId: storeId, productId: item['productId'] as String, isReturnable: isReturnable);
    if (!mounted) return;
    if (success) {
      if (isReturnable) {
        TerminalToast.showSuccess(context: context, title: 'Product Updated', description: '$name marked as returnable.');
      } else {
        TerminalToast.showInfo(context: context, title: 'Product Updated', description: '$name marked as not returnable.');
      }
    } else {
      TerminalToast.showError(context: context, title: 'Update Failed', description: 'Failed to update $name.');
    }
  }

  Future<void> _handleToggleAll(String storeId, bool isReturnable) async {
    final success = await BottleReturnProductActions.toggleAllProducts(storeId: storeId, isReturnable: isReturnable);
    if (!mounted) return;
    if (success) {
      if (isReturnable) {
        TerminalToast.showSuccess(context: context, title: 'Catalog Updated', description: 'All products marked as returnable bottles.');
      } else {
        TerminalToast.showInfo(context: context, title: 'Catalog Updated', description: 'All products marked as not returnable.');
      }
    } else {
      TerminalToast.showError(context: context, title: 'Update Failed', description: 'Failed to update catalog returnable status.');
    }
  }
}
