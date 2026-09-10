import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/generated_icons/chevron_down.dart';
import 'package:models/models.dart';
import 'package:web/web.dart' as web;

/// Dropdown selector field for choosing an optional store counter.
class CounterSelectorField extends StatelessComponent {
  final String counterId;
  final List<Counter> counters;
  final ValueChanged<String> onSelect;

  const CounterSelectorField({
    super.key,
    required this.counterId,
    required this.counters,
    required this.onSelect,
  });

  @override
  Component build(BuildContext context) {
    return fieldset(classes: 'fieldset w-full mb-4', [
      label(
        htmlFor: 'counterId',
        classes: 'label text-[14px] font-semibold text-gray-500 flex justify-between',
        [
          .text('Counter'),
          span(classes: 'text-xs text-gray-400 font-normal', [
            .text('(Optional)'),
          ]),
        ],
      ),
      details(classes: 'dropdown w-full', [
        summary(
          classes:
              'btn border border-border-medium bg-white hover:bg-base-200 text-sm h-11 w-full justify-between font-normal px-3 rounded-lg list-none cursor-pointer ${counterId.isEmpty ? 'text-gray-400' : 'text-base-content'}',
          [
            span([
              .text(
                counterId.isEmpty
                    ? 'Select Counter (Optional)'
                    : (counters.any((c) => c.id == counterId)
                          ? counters.firstWhere((c) => c.id == counterId).name
                          : 'Select Counter (Optional)'),
              ),
            ]),
            ChevronDown(classes: 'w-4 h-4 opacity-50'),
          ],
        ),
        ul(
          classes: 'dropdown-content menu bg-base-100 rounded-box z-50 mt-1 p-2 shadow-sm border border-border-light w-full max-h-48 overflow-y-auto',
          [
            li([
              a(
                href: '#',
                classes:
                    'rounded-md hover:bg-neutral py-2 px-3 block text-gray-400 ${counterId.isEmpty ? 'bg-neutral font-semibold' : ''}',
                onClick: () {
                  onSelect('');
                  _closeDropdown();
                },
                [.text('None (No Counter)')],
              ),
            ]),
            if (counters.isNotEmpty)
              for (final cnt in counters)
                li([
                  a(
                    href: '#',
                    classes:
                        'rounded-md hover:bg-neutral py-2 px-3 block ${cnt.id == counterId ? 'bg-neutral font-semibold' : ''}',
                    onClick: () {
                      onSelect(cnt.id);
                      _closeDropdown();
                    },
                    [.text(cnt.name)],
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
