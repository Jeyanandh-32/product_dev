import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/inventory/inventory.dart';
import 'package:terminal/pages/loading.dart';
import 'package:terminal/signals/inventory_products_signal.dart';
import 'package:terminal/signals/products_signal.dart';
import 'package:terminal/utils/responsive_extensions.dart';

/// Full-featured, responsive POS Inventory Products management screen.
class InventoryProductsPage extends StatefulWidget {
  const InventoryProductsPage({super.key});

  @override
  State<InventoryProductsPage> createState() => _InventoryProductsPageState();
}

class _InventoryProductsPageState extends State<InventoryProductsPage> {
  @override
  void initState() {
    super.initState();
    if (productsSignal.value.value == null) refreshProductsSignal();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = context.isDesktop;

    return SignalBuilder(
      builder: (context) {
        final productsAsync = productsSignal.value;
        if (productsAsync.isLoading && productsAsync.value == null) {
          return const Center(child: Loading(message: 'Loading inventory products...'));
        }

        final pagedProducts = pagedInventoryProductsSignal.value;

        return Padding(
          padding: EdgeInsets.all(isDesktop ? 16 : 10),
          child: Material(
            color: const Color(0xFFFFFFFF),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: Color(0xFFE2E8F0), width: 1),
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: InventoryProductsToolbar(
                    onAddProduct: () => showDialog<void>(context: context, builder: (_) => const AddEditProductDialog()),
                  ),
                ),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                Expanded(
                  child: pagedProducts.isEmpty
                      ? const Center(child: Text('No products match the selected filters.', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF64748B))))
                      : (isDesktop ? _buildDesktopTable(pagedProducts) : _buildMobileList(pagedProducts)),
                ),
                const Divider(height: 1, color: Color(0xFFE2E8F0)),
                const InventoryPaginationToolbar(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildDesktopTable(List<Product> products) {
    return InventoryDataTable(
      products: products,
      onEdit: (product) => _openEditModal(context, product),
      onUpdateStock: (product) => _openUpdateStockModal(context, product),
    );
  }

  Widget _buildMobileList(List<Product> products) {
    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: products.length,
      separatorBuilder: (_, _) => const Gap(10),
      itemBuilder: (context, index) {
        final product = products[index];
        return InventoryProductCardMobile(
          product: product,
          onEdit: () => _openEditModal(context, product),
          onUpdateStock: () => _openUpdateStockModal(context, product),
        );
      },
    );
  }

  void _openEditModal(BuildContext context, Product product) => showDialog<void>(context: context, builder: (_) => AddEditProductDialog(product: product));

  void _openUpdateStockModal(BuildContext context, Product product) => showDialog<void>(context: context, builder: (_) => UpdateStockDialog(product: product));
}
