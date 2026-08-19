import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Pricing input fields for base price, selling price, and tax rate.
class ProductPricingFields extends StatelessWidget {
  final String basePrice;
  final String sellingPrice;
  final String taxRate;
  final ValueChanged<String> onBasePriceChanged;
  final ValueChanged<String> onSellingPriceChanged;
  final ValueChanged<String> onTaxRateChanged;

  const ProductPricingFields({
    super.key,
    required this.basePrice,
    required this.sellingPrice,
    required this.taxRate,
    required this.onBasePriceChanged,
    required this.onSellingPriceChanged,
    required this.onTaxRateChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: TextEditingController(text: basePrice)..selection = TextSelection.collapsed(offset: basePrice.length),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: onBasePriceChanged,
            decoration: InputDecoration(
              labelText: 'Base Price (₹)*',
              hintText: '0.00',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        const Gap(10),
        Expanded(
          child: TextField(
            controller: TextEditingController(text: sellingPrice)..selection = TextSelection.collapsed(offset: sellingPrice.length),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: onSellingPriceChanged,
            decoration: InputDecoration(
              labelText: 'Selling Price (₹)*',
              hintText: '0.00',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
        const Gap(10),
        Expanded(
          child: TextField(
            controller: TextEditingController(text: taxRate)..selection = TextSelection.collapsed(offset: taxRate.length),
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            onChanged: onTaxRateChanged,
            decoration: InputDecoration(
              labelText: 'Tax Rate (%)',
              hintText: '0.00',
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
        ),
      ],
    );
  }
}
