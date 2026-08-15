import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:models/models.dart';

class StoreCategoryFilters extends StatelessComponent {
  final List<Category> categories;
  final String? selectedCategoryId;
  final ValueChanged<String?> onSelectCategory;

  const StoreCategoryFilters({
    super.key,
    required this.categories,
    required this.selectedCategoryId,
    required this.onSelectCategory,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes:
          'flex gap-2.5 overflow-x-auto pb-1 scrollbar-none -mx-4 px-4 sm:mx-0 sm:px-0',
      [
        button(
          classes: selectedCategoryId == null
              ? 'bg-black text-white font-bold text-sm sm:text-base py-1.5 pl-1.5 pr-4 rounded-full cursor-pointer border-0 transition-all flex items-center gap-2.5 shrink-0 shadow-2xs'
              : 'bg-gray-100 hover:bg-gray-200 text-black font-extrabold text-sm sm:text-base py-1.5 pl-1.5 pr-4 rounded-full cursor-pointer border-0 transition-all flex items-center gap-2.5 shrink-0',
          onClick: () => onSelectCategory(null),
          [
            div(
              classes:
                  'w-8 h-8 rounded-full bg-white/20 flex items-center justify-center text-sm shrink-0',
              [.text('✨')],
            ),
            .text('All Products'),
          ],
        ),
        for (final cat in categories)
          button(
            classes: selectedCategoryId == cat.id
                ? 'bg-black text-white font-bold text-sm sm:text-base py-1.5 pl-1.5 pr-4 rounded-full cursor-pointer border-0 transition-all flex items-center gap-2.5 shrink-0 shadow-2xs'
                : 'bg-gray-100 hover:bg-gray-200 text-black font-extrabold text-sm sm:text-base py-1.5 pl-1.5 pr-4 rounded-full cursor-pointer border-0 transition-all flex items-center gap-2.5 shrink-0',
            onClick: () => onSelectCategory(cat.id),
            [
              if (cat.imageUrl != null && cat.imageUrl!.trim().isNotEmpty)
                img(
                  src: cat.imageUrl!,
                  classes:
                      'w-8 h-8 rounded-full object-cover shrink-0 border border-black/10 shadow-2xs',
                )
              else
                div(
                  classes:
                      'w-8 h-8 rounded-full bg-gray-200 text-black flex items-center justify-center text-xs font-extrabold shrink-0',
                  [
                    .text(
                      cat.name.isNotEmpty
                          ? cat.name.substring(0, 1).toUpperCase()
                          : '📦',
                    ),
                  ],
                ),
              .text(cat.name),
            ],
          ),
      ],
    );
  }
}
