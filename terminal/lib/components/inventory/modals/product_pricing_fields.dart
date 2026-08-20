import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:terminal/components/inventory/modals/modal_input_field.dart';

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
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('PRICING & TAXES', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.5, color: Color(0xFF64748B))),
          const Gap(10),
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
              const Gap(10),
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
              const Gap(10),
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
          ),
        ],
      ),
    );
  }
}
