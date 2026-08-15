import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/generated_icons/square_pen.dart';
import 'package:models/models.dart';

class CategoryTableRow extends StatelessComponent {
  final Category category;
  final int productsCount;
  final VoidCallback onEdit;

  const CategoryTableRow({
    super.key,
    required this.category,
    required this.productsCount,
    required this.onEdit,
  });

  @override
  Component build(BuildContext context) {
    final image = category.imageUrl;
    final name = category.name;
    final isActive = category.isActive;
    final description = category.description ?? 'N/A';

    return tr([
      th([]),
      td([
        button(
          classes:
              'hover:cursor-pointer btn btn-ghost btn-xs h-8 w-8 p-0 rounded-full text-gray-500 hover:text-accent transition-colors',
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
      td([
        div(
          classes:
              '${isActive ? 'bg-soft-green text-soft-green-content' : 'bg-soft-red text-soft-red-content'} rounded-full px-3 py-1 text-center text-xs font-semibold inline-block',
          [
            .text(isActive ? 'ACTIVE' : 'INACTIVE'),
          ],
        ),
      ]),
      td([.text('$productsCount')]),
      td([.text(description)]),
      th([]),
    ]);
  }
}
