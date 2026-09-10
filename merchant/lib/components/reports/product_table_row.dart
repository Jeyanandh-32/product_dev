import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart';
import 'package:models/models.dart';

class ProductTableRow extends StatelessComponent {
  final Product product;
  final VoidCallback onEdit;
  final VoidCallback onUpdateStock;

  const ProductTableRow({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onUpdateStock,
  });

  @override
  Component build(BuildContext context) {
    final image = product.imageUrl;
    final name = product.name;
    final sku = product.sku;
    final barcode = product.barcode;
    final isActive = product.isActive;
    final stock = product.stock?.quantity ?? 0;
    final lowStock = product.stock?.lowStockThreshold ?? 0;
    final stockMonitor = product.stock?.stockMonitor ?? false;
    final basePrice = product.basePrice;
    final sellingPrice = product.sellingPrice;
    final taxRate = product.taxRate;
    final category = product.category?.name ?? '-';
    final counter = product.counter?.name ?? '-';

    return tr([
      th([]),
      td([
        div(classes: 'flex items-center gap-4', [
          button(
            classes: 'hover:cursor-pointer btn btn-ghost btn-xs h-8 w-8 p-0 rounded-full text-gray-500 hover:text-accent transition-colors',
            events: {
              'click': (e) {
                e.stopPropagation();
                onEdit();
              },
            },
            [
              SquarePen(classes: 'w-5 h-5'),
            ],
          ),
          button(
            classes: 'hover:cursor-pointer btn btn-ghost btn-xs h-8 w-8 p-0 rounded-full text-gray-500 hover:text-accent transition-colors',
            events: {
              'click': (e) {
                e.stopPropagation();
                onUpdateStock();
              },
            },
            [
              Boxes(classes: 'w-5 h-5'),
            ],
          ),
        ]),
      ]),
      td([
        if (image != null && image.isNotEmpty)
          div(
            classes:
                'h-12 w-12 overflow-hidden rounded-2xl bg-gray-100 shrink-0',
            [
              img(
                src: image,
                alt: name,
                classes: 'block h-full w-full object-cover',
              ),
            ],
          )
        else
          .text('-'),
      ]),
      th(classes: 'whitespace-nowrap', [
        .text(name),
      ]),
      td(classes: 'whitespace-nowrap', [.text(sku ?? '-')]),
      td(classes: 'whitespace-nowrap', [.text(barcode ?? '-')]),
      td([
        div(
          classes:
              '${isActive ? 'bg-soft-green text-soft-green-content' : 'bg-soft-red text-soft-red-content'} rounded-full px-3 py-1 text-center text-xs font-semibold inline-block',
          [
            .text(isActive ? 'ACTIVE' : 'INACTIVE'),
          ],
        ),
      ]),
      td([.text('$stock')]),
      td([.text('$lowStock')]),
      td([
        div(
          classes:
              '${stockMonitor ? 'bg-soft-green text-soft-green-content' : 'bg-soft-red text-soft-red-content'} rounded-full px-3 py-1 text-center text-xs font-semibold',
          [
            .text(stockMonitor ? 'ON' : 'OFF'),
          ],
        ),
      ]),
      td([.text(basePrice.toStringAsFixed(2))]),
      td([.text(sellingPrice.toStringAsFixed(2))]),
      td([.text('${taxRate.toStringAsFixed(2)}%')]),
      td(classes: 'whitespace-nowrap', [.text(category)]),
      td(classes: 'whitespace-nowrap', [.text(counter)]),
      th([]),
    ]);
  }
}
