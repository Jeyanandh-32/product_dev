import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:merchant/components/fields/form_field.dart';
import 'package:merchant/components/modals/modal.dart';
import 'package:merchant/providers/categories_provider.dart';
import 'package:merchant/providers/ui_providers.dart';
import 'package:models/models.dart';
import 'package:web/web.dart';

class AddEditCategoryModal extends StatefulComponent {
  const AddEditCategoryModal({super.key, this.category});

  final Category? category;

  @override
  State<AddEditCategoryModal> createState() => _AddEditCategoryModalState();
}

class _AddEditCategoryModalState extends State<AddEditCategoryModal> {
  late String _categoryName;
  late bool _isActive;

  @override
  void initState() {
    super.initState();
    _categoryName = component.category?.name ?? '';
    _isActive = component.category?.isActive ?? true;
  }

  void _onSubmit(BuildContext context, Event e) {
    e.preventDefault();
    final categoryName = _categoryName.trim();
    final isActive = _isActive;

    context.read(activeModalProvider.notifier).state = ActiveModal.none;

    if (component.category != null) {
      context.read(categoriesProvider.notifier).updateCategory(
        id: component.category!.id,
        name: categoryName,
        isActive: isActive,
      );
    } else {
      context.read(categoriesProvider.notifier).create(
        name: categoryName,
      );
    }
  }

  @override
  Component build(BuildContext context) {
    return Modal(
      title: component.category != null ? 'Edit Category' : 'Add Category',
      child: form(
        method: FormMethod.post,
        events: {'submit': (e) => _onSubmit(context, e)},
        [
          FormField(
            id: 'categoryName',
            labelText: 'Category Name',
            type: InputType.text,
            attributes: {
              'placeholder': 'Biscuits',
              'required': '',
              'value': _categoryName,
            },
            hintText: 'Category name is required.',
            onChange: (value) => _categoryName = value as String,
          ),

          if (component.category != null)
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
