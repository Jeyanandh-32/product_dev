import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/fields/form_field.dart';
import 'package:web/web.dart' as web;

/// Optional extra metadata fields for product modal (SKU, barcode, image URL, and active toggle).
class ProductMetadataSection extends StatelessComponent {
  final String sku;
  final String barcode;
  final String imageUrl;
  final bool isActive;
  final bool isEditing;
  final ValueChanged<String> onSkuChanged;
  final ValueChanged<String> onBarcodeChanged;
  final ValueChanged<String> onImageUrlChanged;
  final ValueChanged<bool> onActiveChanged;

  const ProductMetadataSection({
    super.key,
    required this.sku,
    required this.barcode,
    required this.imageUrl,
    required this.isActive,
    required this.isEditing,
    required this.onSkuChanged,
    required this.onBarcodeChanged,
    required this.onImageUrlChanged,
    required this.onActiveChanged,
  });

  @override
  Component build(BuildContext context) {
    return div(classes: 'flex flex-col gap-4', [
      FormField(
        id: 'sku',
        labelText: 'SKU (optional)',
        type: InputType.text,
        attributes: {
          'placeholder': 'DF-BISCUIT-01',
          'value': sku,
        },
        onChange: (value) => onSkuChanged(value as String),
      ),
      FormField(
        id: 'barcode',
        labelText: 'Barcode (optional)',
        type: InputType.text,
        attributes: {
          'placeholder': '8901728281223',
          'value': barcode,
        },
        onChange: (value) => onBarcodeChanged(value as String),
      ),
      FormField(
        id: 'imageUrl',
        labelText: 'Image URL (optional)',
        type: InputType.url,
        attributes: {
          'placeholder': 'https://example.com/image.png',
          'value': imageUrl,
        },
        onChange: (value) => onImageUrlChanged(value as String),
      ),
      if (isEditing)
        div(
          classes: 'form-control mb-2 flex flex-row items-center gap-3',
          [
            p(
              classes: 'text-[14px] font-semibold text-gray-500',
              [.text('Active')],
            ),
            input(
              type: InputType.checkbox,
              classes:
                  'toggle ${isActive ? 'toggle-success' : ''} hover:cursor-pointer',
              checked: isActive,
              events: {
                'change': (e) {
                  final target = e.target as web.HTMLInputElement;
                  onActiveChanged(target.checked);
                },
              },
            ),
          ],
        ),
    ]);
  }
}
