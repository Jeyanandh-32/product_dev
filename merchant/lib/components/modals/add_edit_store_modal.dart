import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:merchant/components/fields/form_field.dart';
import 'package:merchant/components/modals/modal.dart';
import 'package:merchant/providers/stores_provider.dart';
import 'package:merchant/providers/ui_providers.dart';
import 'package:models/models.dart';
import 'package:web/web.dart';

class AddEditStoreModal extends StatefulComponent {
  const AddEditStoreModal({super.key, this.store});

  final Store? store;

  @override
  State<AddEditStoreModal> createState() => _AddEditStoreModalState();
}

class _AddEditStoreModalState extends State<AddEditStoreModal> {
  late String _storeName;
  late String _storeType;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _storeName = component.store?.name ?? '';
    _storeType = component.store?.storeType ?? '';
    _isActive = component.store?.isActive ?? true;
  }

  void _onSubmit(BuildContext context, Event e) {
    e.preventDefault();
    final storeName = _storeName.trim();
    final storeType = _storeType.trim();
    final isActive = _isActive;

    context.read(activeModalProvider.notifier).state = ActiveModal.none;

    print("store name = $storeName");
    print("store type = $storeType");
    print("is active = $isActive");
    if (component.store != null) {
      context
          .read(storesProvider.notifier)
          .updateStore(
            id: component.store!.id,
            name: storeName,
            storeType: storeType.isEmpty ? null : storeType,
            isActive: isActive,
          );
    } else {
      context
          .read(storesProvider.notifier)
          .create(
            name: storeName,
            storeType: storeType.isEmpty ? null : storeType,
          );
    }
  }

  @override
  Component build(BuildContext context) {
    return Modal(
      title: component.store != null ? 'Edit Store' : 'Add Store',
      child: form(
        method: FormMethod.post,
        events: {'submit': (e) => _onSubmit(context, e)},
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

          FormField(
            id: 'storeType',
            labelText: 'Store Type (optional)',
            type: InputType.text,
            attributes: {
              'placeholder': 'Cafe',
              'value': _storeType,
            },
            onChange: (value) => _storeType = value as String,
          ),

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
                    final target = e.target as HTMLInputElement;
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
