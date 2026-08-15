import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/generated_icons/chevron_down.dart';
import 'package:models/models.dart';
import 'package:web/web.dart' as web;

class CategorySelectorField extends StatelessComponent {
  final String categoryId;
  final List<Category> categories;
  final ValueChanged<String> onSelect;

  const CategorySelectorField({
    super.key,
    required this.categoryId,
    required this.categories,
    required this.onSelect,
  });

  @override
  Component build(BuildContext context) {
    return fieldset(classes: 'fieldset w-full mb-4', [
      label(
        htmlFor: 'categoryId',
        classes: 'label text-[14px] font-semibold text-gray-500',
        [.text('Category')],
      ),
      details(classes: 'dropdown w-full', [
        summary(
          classes:
              'btn border border-border-medium bg-white hover:bg-base-200 text-sm h-11 w-full justify-between font-normal px-3 rounded-lg list-none cursor-pointer ${categoryId.isEmpty ? 'text-gray-400' : 'text-base-content'}',
          [
            span([
              .text(
                categoryId.isEmpty
                    ? 'Select Category'
                    : (categories.any((c) => c.id == categoryId)
                          ? categories
                                .firstWhere((c) => c.id == categoryId)
                                .name
                          : 'Select Category'),
              ),
            ]),
            ChevronDown(classes: 'w-4 h-4 opacity-50'),
          ],
        ),
        ul(
          classes:
              'dropdown-content menu bg-base-100 rounded-box z-50 mt-1 p-2 shadow-sm border border-border-light w-full max-h-48 overflow-y-auto',
          [
            if (categories.isEmpty)
              li([
                span(
                  classes: 'text-gray-400 text-sm p-2',
                  [.text('No categories available')],
                ),
              ])
            else
              for (final cat in categories)
                li([
                  a(
                    href: '#',
                    classes:
                        'rounded-md hover:bg-neutral py-2 px-3 block ${cat.id == categoryId ? 'bg-neutral font-semibold' : ''}',
                    onClick: () {
                      onSelect(cat.id);
                      _closeDropdown();
                    },
                    [.text(cat.name)],
                  ),
                ]),
          ],
        ),
      ]),
    ]);
  }

  void _closeDropdown() {
    final activeElement = web.document.activeElement;
    if (activeElement != null) {
      (activeElement as web.HTMLElement).blur();
      final details = activeElement.closest('details');
      details?.removeAttribute('open');
    }
  }
}
