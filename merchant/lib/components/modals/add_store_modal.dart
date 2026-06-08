import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:jaspr_riverpod/legacy.dart';
import 'package:merchant/components/form_field.dart';
import 'package:merchant/components/modals/modal.dart';
import 'package:merchant/providers/field_providers.dart';
import 'package:merchant/providers/stores_provider.dart';
import 'package:merchant/providers/ui_providers.dart';
import 'package:web/web.dart';

class AddStoreModal extends StatelessComponent {
  void _onSubmit(BuildContext context, Event e) {
    e.preventDefault();
    final storeName = context.read(addStoreStoreNameProvider).trim();
    final storeType = context.read(addStoreStoreTypeProvider)?.trim();

    context.read(activeModalProvider.notifier).state = .none;

    print("store name = $storeName");
    print("store type = $storeType");

    context
        .read(storesProvider.notifier)
        .create(name: storeName, storeType: storeType);
  }

  void _onChange(StateProvider provider, BuildContext context, dynamic value) {
    context.read(provider.notifier).state = value as String;
  }

  @override
  Component build(BuildContext context) {
    context.watch(addStoreStoreNameProvider);
    context.watch(addStoreStoreTypeProvider);
    return Modal(
      title: 'Add Store',
      child: form(
        method: .post,
        events: {'submit': (e) => _onSubmit(context, e)},
        [
          FormField(
            id: 'storeName',
            labelText: 'Store Name',
            type: .text,
            attributes: {'placeholder': 'Jack Dev\'s Cafe', 'required': ''},
            hintText: 'Store name is required.',
            onChange: (value) =>
                _onChange(addStoreStoreNameProvider, context, value),
          ),

          FormField(
            id: 'storeType',
            labelText: 'Store Type (optional)',
            type: .text,
            attributes: {'placeholder': 'Cafe'},
            onChange: (value) =>
                _onChange(addStoreStoreTypeProvider, context, value),
          ),

          div(classes: 'flex justify-end items-center pt-2', [
            button(
              type: .submit,
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
