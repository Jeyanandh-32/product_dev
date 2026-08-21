import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:models/models.dart';
import 'package:signals_flutter/signals_flutter.dart';
import 'package:terminal/components/inventory/inventory.dart';
import 'package:terminal/pages/loading.dart';
import 'package:terminal/signals/inventory_products_signal.dart';
import 'package:terminal/signals/products_signal.dart';
import 'package:terminal/theme/terminal_colors.dart';
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
    final isMobile = context.isMobile;

    return SignalBuilder(
      builder: (context) {
        final productsAsync = productsSignal.value;
        if (productsAsync.isLoading && productsAsync.value == null) {
          return const Center(child: Loading(message: 'Loading inventory products...'));
        }

        final allProducts = productsAsync.value ?? [];
        final pagedProducts = pagedInventoryProductsSignal.value;

        return Padding(
          padding: EdgeInsets.all(isMobile ? 10 : 16),
          child: Material(
            color: TerminalColors.surface,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
              side: const BorderSide(color: TerminalColors.border, width: 1),
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
                const Divider(height: 1, color: TerminalColors.border),
                Expanded(
                  child: pagedProducts.isEmpty
                      ? InventoryEmptyProducts(
                          isFiltered: allProducts.isNotEmpty,
                          onAddProduct: () => showDialog<void>(context: context, builder: (_) => const AddEditProductDialog()),
                        )
                      : (isMobile ? _buildMobileList(pagedProducts) : _buildTable(pagedProducts)),
                ),
                const Divider(height: 1, color: TerminalColors.border),
                const InventoryPaginationToolbar(),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTable(List<Product> products) {
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
