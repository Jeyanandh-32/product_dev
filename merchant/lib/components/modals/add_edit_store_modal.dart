import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/fields/form_field.dart';
import 'package:merchant/components/fields/store_type_selector_field.dart';
import 'package:merchant/components/modals/modal.dart';
import 'package:merchant/components/modals/store_bottle_returns_section.dart';
import 'package:merchant/components/modals/store_online_settings_section.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:models/models.dart';
import 'package:web/web.dart' as web;

/// Modal dialog for creating and updating stores and their online ordering settings.
class AddEditStoreModal extends StatefulComponent {
  const AddEditStoreModal({super.key, this.store});

  final Store? store;

  @override
  State<AddEditStoreModal> createState() => _AddEditStoreModalState();
}

class _AddEditStoreModalState extends State<AddEditStoreModal> {
  String _storeName = '';
  StoreType? _storeType;
  bool _isActive = true;
  bool _isOnlineEnabled = false;
  String _slug = '';

  @override
  void initState() {
    super.initState();
    final s = component.store;
    if (s != null) {
      _storeName = s.name;
      _storeType = s.storeType != null
          ? StoreType.values.firstWhere((t) => t.name == s.storeType?.toLowerCase(), orElse: () => StoreType.other)
          : null;
      _isActive = s.isActive;
      _isOnlineEnabled = s.isOnlineEnabled;
      _slug = s.slug ?? '';
    }
  }

  String _toSlug(String input) => input
      .toLowerCase()
      .replaceAll(RegExp(r'[^a-z0-9\s-]'), '')
      .replaceAll(RegExp(r'\s+'), '-')
      .replaceAll(RegExp(r'-+'), '-');

  void _onStoreNameChange(String name) {
    _storeName = name;
    if (_isOnlineEnabled && (_slug.isEmpty || component.store == null)) {
      setState(() => _slug = _toSlug(name));
    }
  }

  void _onSubmit(web.Event e) {
    e.preventDefault();
    (web.document.activeElement as web.HTMLElement?)?.blur();
    final store = component.store;
    if (store != null) {
      StoresActions.updateStore(
        id: store.id,
        name: _storeName,
        storeType: _storeType,
        isActive: _isActive,
        isOnlineEnabled: _isOnlineEnabled,
        slug: _slug.isNotEmpty ? _slug : null,
      );
    } else {
      StoresActions.create(
        name: _storeName,
        storeType: _storeType,
        isOnlineEnabled: _isOnlineEnabled,
        slug: _slug.isNotEmpty ? _slug : null,
      );
    }
    activeModalSignal.value = ActiveModal.none;
  }

  @override
  Component build(BuildContext context) {
    final store = component.store;
    final isEditing = store != null;

    return Modal(
      title: isEditing ? 'Edit Store' : 'Add Store',
      child: form(
        events: {'submit': _onSubmit},
        [
          FormField(
            id: 'name',
            labelText: 'Store Name',
            type: InputType.text,
            attributes: {'placeholder': "Jack Dev's Cafe", 'required': '', 'value': _storeName},
            hintText: 'Store name is required.',
            onChange: (value) => _onStoreNameChange(value as String),
          ),
          StoreTypeSelectorField(
            selectedType: _storeType,
            onTypeSelected: (type) => setState(() => _storeType = type),
          ),
          StoreOnlineSettingsSection(
            isOnlineEnabled: _isOnlineEnabled,
            slug: _slug,
            onToggleOnline: (enabled) {
              setState(() {
                _isOnlineEnabled = enabled;
                if (_isOnlineEnabled && _slug.isEmpty) _slug = _toSlug(_storeName);
              });
            },
            onSlugChanged: (slugVal) => setState(() => _slug = slugVal),
          ),
          if (isEditing) ...[
            StoreBottleReturnsSection(store: store),
            div(classes: 'form-control mb-4 flex flex-row items-center gap-3', [
              p(classes: 'text-[14px] font-semibold text-gray-500', [.text('Active')]),
              input(
                type: InputType.checkbox,
                classes: 'toggle ${_isActive ? 'toggle-success' : ''} hover:cursor-pointer',
                checked: _isActive,
                events: {'change': (e) => setState(() => _isActive = (e.target as web.HTMLInputElement).checked)},
              ),
            ]),
          ],
          div(classes: 'flex justify-end items-center pt-2', [
            button(
              type: ButtonType.submit,
              classes: 'bg-primary text-primary-content px-6 h-10 rounded-lg hover:cursor-pointer hover:bg-opacity-80 transition-all duration-300',
              [.text('Save')],
            ),
          ]),
        ],
      ),
    );
  }
}
