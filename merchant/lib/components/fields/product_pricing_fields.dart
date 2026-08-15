import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/fields/form_field.dart';

/// Price and tax input fields row for product creation/editing.
class ProductPricingFields extends StatelessComponent {
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
  Component build(BuildContext context) {
    return div(classes: 'flex flex-col gap-0', [
      div(classes: 'flex gap-4', [
        FormField(
          id: 'basePrice',
          labelText: 'Base Price (₹)',
          type: InputType.number,
          attributes: {
            'placeholder': '100',
            'required': '',
            'min': '0',
            'value': basePrice,
          },
          hintText: 'Base price is required.',
          onChange: (value) => onBasePriceChanged(value as String),
        ),
        FormField(
          id: 'sellingPrice',
          labelText: 'Selling Price (₹)',
          type: InputType.number,
          attributes: {
            'placeholder': '120',
            'required': '',
            'min': '0',
            'value': sellingPrice,
          },
          hintText: 'Selling price is required.',
          onChange: (value) => onSellingPriceChanged(value as String),
        ),
      ]),
      FormField(
        id: 'taxRate',
        labelText: 'Tax Rate (%)',
        type: InputType.number,
        attributes: {
          'placeholder': '0',
          'min': '0',
          'max': '100',
          'step': '0.01',
          'value': taxRate,
        },
        onChange: (value) => onTaxRateChanged(value as String),
      ),
    ]);
  }
}
