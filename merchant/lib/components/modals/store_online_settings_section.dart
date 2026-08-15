import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/fields/form_field.dart';
import 'package:web/web.dart' as web;

/// Online ordering toggle and store URL slug input field block.
class StoreOnlineSettingsSection extends StatelessComponent {
  final bool isOnlineEnabled;
  final String slug;
  final ValueChanged<bool> onToggleOnline;
  final ValueChanged<String> onSlugChanged;

  const StoreOnlineSettingsSection({
    super.key,
    required this.isOnlineEnabled,
    required this.slug,
    required this.onToggleOnline,
    required this.onSlugChanged,
  });

  @override
  Component build(BuildContext context) {
    return div(classes: 'flex flex-col', [
      div(classes: 'form-control mb-4 flex flex-row items-center gap-3', [
        p(
          classes: 'text-[14px] font-semibold text-gray-500',
          [.text('Enable Online Ordering')],
        ),
        input(
          type: InputType.checkbox,
          classes:
              'toggle ${isOnlineEnabled ? 'toggle-success' : ''} hover:cursor-pointer',
          checked: isOnlineEnabled,
          events: {
            'change': (e) {
              final target = e.target as web.HTMLInputElement;
              onToggleOnline(target.checked);
            },
          },
        ),
      ]),
      if (isOnlineEnabled)
        FormField(
          id: 'slug',
          labelText: 'Store URL Slug',
          type: InputType.text,
          attributes: {
            'placeholder': 'jack-devs-cafe',
            'required': '',
            'pattern': r'^[a-z0-9]+(?:-[a-z0-9]+)*$',
            'title':
                'Lowercase letters, numbers, and hyphens only (e.g. baker-street)',
            'value': slug,
          },
          hintText: 'Must be lowercase letters, numbers, and hyphens.',
          onChange: (value) => onSlugChanged((value as String).trim()),
        ),
    ]);
  }
}
