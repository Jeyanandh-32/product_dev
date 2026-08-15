import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/generated_icons/chevron_down.dart';
import 'package:models/models.dart';
import 'package:web/web.dart' as web;

/// Dropdown selector for store business category / store type.
class StoreTypeSelectorField extends StatelessComponent {
  final StoreType? selectedType;
  final ValueChanged<StoreType> onTypeSelected;

  const StoreTypeSelectorField({
    super.key,
    required this.selectedType,
    required this.onTypeSelected,
  });

  @override
  Component build(BuildContext context) {
    return fieldset(classes: 'fieldset w-full mb-4', [
      label(
        htmlFor: 'storeType',
        classes: 'label text-[14px] font-semibold text-gray-500',
        [.text('Store Type')],
      ),
      details(classes: 'dropdown w-full', [
        summary(
          classes:
              'btn border border-border-medium bg-white hover:bg-base-200 text-sm h-11 w-full justify-between font-normal px-3 rounded-lg list-none cursor-pointer ${selectedType == null ? 'text-gray-400' : 'text-base-content'}',
          [
            span([
              .text(
                selectedType == null
                    ? 'Select Store Type'
                    : '${selectedType!.name[0].toUpperCase()}${selectedType!.name.substring(1)}',
              ),
            ]),
            ChevronDown(classes: 'w-4 h-4 opacity-50'),
          ],
        ),
        ul(
          classes:
              'dropdown-content menu bg-base-100 rounded-box z-50 mt-1 p-2 shadow-sm border border-border-light w-full max-h-48 overflow-y-auto',
          [
            for (final type in StoreType.values)
              li([
                a(
                  href: '#',
                  classes:
                      'rounded-md hover:bg-neutral py-2 px-3 block ${type == selectedType ? 'bg-neutral font-semibold' : ''}',
                  onClick: () {
                    onTypeSelected(type);
                    final activeElement = web.document.activeElement;
                    if (activeElement != null) {
                      (activeElement as web.HTMLElement).blur();
                      final details = activeElement.closest('details');
                      details?.removeAttribute('open');
                    }
                  },
                  [
                    .text(
                      '${type.name[0].toUpperCase()}${type.name.substring(1)}',
                    ),
                  ],
                ),
              ]),
          ],
        ),
      ]),
    ]);
  }
}
