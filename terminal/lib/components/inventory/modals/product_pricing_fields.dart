import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:terminal/components/inventory/modals/modal_input_field.dart';

/// Responsive pricing input fields for base price, selling price, and tax rate.
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 440;

        if (isCompact) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Expanded(
                    child: ModalInputField(
                      label: 'Base Price (₹)',
                      hint: '0.00',
                      value: basePrice,
                      isRequired: true,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onChanged: onBasePriceChanged,
                    ),
                  ),
                  const Gap(12),
                  Expanded(
                    child: ModalInputField(
                      label: 'Selling Price (₹)',
                      hint: '0.00',
                      value: sellingPrice,
                      isRequired: true,
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                      onChanged: onSellingPriceChanged,
                    ),
                  ),
                ],
              ),
              const Gap(14),
              ModalInputField(
                label: 'Tax Rate (%)',
                hint: '0.00',
                value: taxRate,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: onTaxRateChanged,
              ),
            ],
          );
        }

        return Row(
          children: [
            Expanded(
              child: ModalInputField(
                label: 'Base Price (₹)',
                hint: '0.00',
                value: basePrice,
                isRequired: true,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: onBasePriceChanged,
              ),
            ),
            const Gap(12),
            Expanded(
              child: ModalInputField(
                label: 'Selling Price (₹)',
                hint: '0.00',
                value: sellingPrice,
                isRequired: true,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: onSellingPriceChanged,
              ),
            ),
            const Gap(12),
            Expanded(
              child: ModalInputField(
                label: 'Tax Rate (%)',
                hint: '0.00',
                value: taxRate,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                onChanged: onTaxRateChanged,
              ),
            ),
          ],
        );
      },
    );
  }
}
