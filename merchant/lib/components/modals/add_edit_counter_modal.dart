import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:merchant/components/fields/form_field.dart';
import 'package:merchant/components/modals/modal.dart';
import 'package:merchant/providers/counters_provider.dart';
import 'package:merchant/providers/ui_providers.dart';
import 'package:models/models.dart';
import 'package:web/web.dart';

class AddEditCounterModal extends StatefulComponent {
  const AddEditCounterModal({super.key, this.counter});

  final Counter? counter;

  @override
  State<AddEditCounterModal> createState() => _AddEditCounterModalState();
}

class _AddEditCounterModalState extends State<AddEditCounterModal> {
  late String _counterName;
  late String _description;
  late String _imageUrl;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _counterName = component.counter?.name ?? '';
    _description = component.counter?.description ?? '';
    _imageUrl = component.counter?.imageUrl ?? '';
    _isActive = component.counter?.isActive ?? true;
  }

  void _onSubmit(BuildContext context, Event e) {
    e.preventDefault();
    final counterName = _counterName.trim();
    final descriptionVal = _description.trim();
    final imageUrlVal = _imageUrl.trim();
    final description = descriptionVal.isNotEmpty ? descriptionVal : null;
    final imageUrl = imageUrlVal.isNotEmpty ? imageUrlVal : null;
    final isActive = _isActive;

    context.read(activeModalProvider.notifier).state = ActiveModal.none;

    if (component.counter != null) {
      context.read(countersProvider.notifier).updateCounter(
        id: component.counter!.id,
        name: counterName,
        isActive: isActive,
        description: description,
        imageUrl: imageUrl,
      );
    } else {
      context.read(countersProvider.notifier).create(
        name: counterName,
        description: description,
        imageUrl: imageUrl,
      );
    }
  }

  @override
  Component build(BuildContext context) {
    return Modal(
      title: component.counter != null ? 'Edit Counter' : 'Add Counter',
      child: form(
        method: FormMethod.post,
        events: {'submit': (e) => _onSubmit(context, e)},
        [
          FormField(
            id: 'counterName',
            labelText: 'Counter Name',
            type: InputType.text,
            attributes: {
              'placeholder': 'Counter 1',
              'required': '',
              'value': _counterName,
            },
            hintText: 'Counter name is required.',
            onChange: (value) => _counterName = value as String,
          ),

          FormField(
            id: 'description',
            labelText: 'Description (optional)',
            type: InputType.text,
            attributes: {
              'placeholder': 'Optional description...',
              'value': _description,
            },
            onChange: (value) => _description = value as String,
          ),

          FormField(
            id: 'imageUrl',
            labelText: 'Image URL (optional)',
            type: InputType.url,
            attributes: {
              'placeholder': 'https://example.com/image.jpg',
              'value': _imageUrl,
            },
            onChange: (value) => _imageUrl = value as String,
          ),

          if (component.counter != null)
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
