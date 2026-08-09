import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/generated_icons/chevron_down.dart';
import 'package:merchant/components/fields/form_field.dart';
import 'package:merchant/components/modals/modal.dart';
import 'package:merchant/signals/stores_signal.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:models/models.dart';
import 'package:web/web.dart' as web;

class AddEditStoreModal extends StatefulComponent {
  const AddEditStoreModal({super.key, this.store});

  final Store? store;

  @override
  State<AddEditStoreModal> createState() => _AddEditStoreModalState();
}

class _AddEditStoreModalState extends State<AddEditStoreModal> {
  late String _storeName;
  StoreType? _storeType;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _storeName = component.store?.name ?? '';
    _storeType = component.store?.storeType != null
        ? StoreType.values.firstWhere(
            (t) => t.name == component.store?.storeType?.toLowerCase(),
            orElse: () => .other,
          )
        : null;
    _isActive = component.store?.isActive ?? true;
  }

  void _onSubmit(web.Event e) {
    e.preventDefault();
    final storeName = _storeName.trim();
    final storeType = _storeType;
    final isActive = _isActive;

    activeModalSignal.value = .none;

    if (component.store != null) {
      StoresActions.updateStore(
        id: component.store!.id,
        name: storeName,
        storeType: storeType,
        isActive: isActive,
      );
    } else {
      StoresActions.create(
        name: storeName,
        storeType: storeType,
      );
    }
  }

  @override
  Component build(BuildContext context) {
    return Modal(
      title: component.store != null ? 'Edit Store' : 'Add Store',
      child: form(
        method: FormMethod.post,
        events: {'submit': (e) => _onSubmit(e)},
        [
          FormField(
            id: 'storeName',
            labelText: 'Store Name',
            type: InputType.text,
            attributes: {
              'placeholder': 'Jack Dev\'s Cafe',
              'required': '',
              'value': _storeName,
            },
            hintText: 'Store name is required.',
            onChange: (value) => _storeName = value as String,
          ),

          fieldset(classes: 'fieldset w-full mb-4', [
            label(
              htmlFor: 'storeType',
              classes: 'label text-[14px] font-semibold text-gray-500',
              [.text('Store Type')],
            ),
            details(classes: 'dropdown w-full', [
              summary(
                classes:
                    'btn border border-border-medium bg-white hover:bg-base-200 text-sm h-11 w-full justify-between font-normal px-3 rounded-lg list-none cursor-pointer ${_storeType == null ? 'text-gray-400' : 'text-base-content'}',
                [
                  span([
                    .text(
                      _storeType == null
                          ? 'Select Store Type'
                          : '${_storeType!.name[0].toUpperCase()}${_storeType!.name.substring(1)}',
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
                            'rounded-md hover:bg-neutral py-2 px-3 block ${type == _storeType ? 'bg-neutral font-semibold' : ''}',
                        onClick: () {
                          setState(() {
                            _storeType = type;
                          });
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
          ]),

          if (component.store != null)
            div(classes: 'form-control mb-4 flex flex-row items-center gap-3', [
              p(
                classes: 'text-[14px] font-semibold text-gray-500',
                [.text('Active')],
              ),
              input(
                type: InputType.checkbox,
                classes:
                    'toggle ${_isActive ? 'toggle-success' : ''} hover:cursor-pointer',
                checked: _isActive,
                events: {
                  'change': (e) {
                    final target = e.target as web.HTMLInputElement;
                    setState(() {
                      _isActive = target.checked;
                    });
                  },
                },
              ),
            ]),

          div(classes: 'flex justify-end items-center pt-2', [
            button(
              type: ButtonType.submit,
              classes:
                  'bg-primary text-primary-content px-6 h-10 rounded-lg hover:cursor-pointer hover:bg-opacity-80 transition-all duration-300',
              [
                .text('Save'),
              ],
            ),
          ]),
        ],
      ),
    );
  }
}
