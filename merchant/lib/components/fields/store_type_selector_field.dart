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
        classes: 'label text-[14px] font-semibold text-slate-700',
        [.text('Store Type')],
      ),
      details(classes: 'dropdown w-full', [
        summary(
          classes:
              'btn border border-border-medium bg-white hover:bg-slate-50 text-sm h-[42px] w-full justify-between font-normal px-3 rounded-[10px] list-none cursor-pointer ${selectedType == null ? 'text-slate-400' : 'text-slate-900'}',
          [
            span([
              .text(
                selectedType != null
                    ? '${selectedType?.name[0].toUpperCase()}${selectedType?.name.substring(1)}'
                    : 'Select Store Type',
              ),
            ]),
            ChevronDown(classes: 'w-4 h-4 opacity-50'),
          ],
        ),
        ul(
          classes: 'dropdown-content menu bg-white rounded-2xl z-50 mt-1 p-2 shadow-lg border border-border-medium w-full max-h-48 overflow-y-auto',
          [
            for (final type in StoreType.values)
              li([
                a(
                  href: '#',
                  classes:
                      'rounded-lg hover:bg-slate-50 py-2 px-3 block ${type == selectedType ? 'bg-slate-100 font-semibold text-slate-900' : 'text-slate-700'}',
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
