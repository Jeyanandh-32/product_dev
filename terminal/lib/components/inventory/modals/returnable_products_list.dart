import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:terminal/components/inventory/modals/returnable_product_row.dart';

/// Scrollable list of returnable products with loading and empty state handling.
class ReturnableProductsList extends StatelessWidget {
  const ReturnableProductsList({
    super.key,
    required this.isLoading,
    required this.products,
    required this.onToggleProduct,
  });

  final bool isLoading;
  final List<Map<String, dynamic>> products;
  final void Function(Map<String, dynamic> product, bool isReturnable)
      onToggleProduct;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: Color(0xFF16A34A),
        ),
      );
    }

    if (products.isEmpty) {
      return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: const Text(
          'No matching products found.',
          style: TextStyle(
            fontSize: 13,
            color: Color(0xFF94A3B8),
          ),
        ),
      );
    }

    return ListView.separated(
      itemCount: products.length,
      separatorBuilder: (context, index) => const Gap(8),
      itemBuilder: (context, index) {
        final product = products[index];
        return ReturnableProductRow(
          product: product,
          onToggle: (val) => onToggleProduct(product, val),
        );
      },
    );
  }
}
