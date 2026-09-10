import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/fields/form_field.dart';
import 'package:merchant/components/modals/modal.dart';
import 'package:merchant/signals/categories_signal.dart';
import 'package:merchant/signals/navigation_signal.dart';
import 'package:models/models.dart';
import 'package:web/web.dart';

class AddEditCategoryModal extends StatefulComponent {
  const AddEditCategoryModal({super.key, this.category});

  final Category? category;

  @override
  State<AddEditCategoryModal> createState() => _AddEditCategoryModalState();
}

class _AddEditCategoryModalState extends State<AddEditCategoryModal> {
  String _categoryName = '';
  String _description = '';
  String _imageUrl = '';
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    final cat = component.category;
    if (cat != null) {
      _categoryName = cat.name;
      _description = cat.description ?? '';
      _imageUrl = cat.imageUrl ?? '';
      _isActive = cat.isActive;
    }
  }

  void _onSubmit(Event e) {
    e.preventDefault();
    (document.activeElement as HTMLElement?)?.blur();
    final categoryName = _categoryName.trim();
    final descriptionVal = _description.trim();
    final imageUrlVal = _imageUrl.trim();
    final description = descriptionVal.isNotEmpty ? descriptionVal : null;
    final imageUrl = imageUrlVal.isNotEmpty ? imageUrlVal : null;

    activeModalSignal.value = ActiveModal.none;

    final cat = component.category;
    if (cat != null) {
      CategoriesActions.updateCategory(
        id: cat.id,
        name: categoryName,
        isActive: _isActive,
        description: description,
        imageUrl: imageUrl,
      );
    } else {
      CategoriesActions.create(
        name: categoryName,
        description: description,
        imageUrl: imageUrl,
      );
    }
  }

  @override
  Component build(BuildContext context) {
    final isEditing = component.category != null;

    return Modal(
      title: isEditing ? 'Edit Category' : 'Add Category',
      child: form(
        method: FormMethod.post,
        events: {'submit': _onSubmit},
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
          if (isEditing)
            div(classes: 'form-control mb-4 flex flex-row items-center gap-3', [
              p(classes: 'text-[14px] font-semibold text-slate-500', [
                .text('Active'),
              ]),
              input(
                type: InputType.checkbox,
                classes:
                    'toggle ${_isActive ? 'toggle-success' : ''} hover:cursor-pointer',
                checked: _isActive,
                events: {
                  'change': (e) {
                    final target = e.target as HTMLInputElement;
                    setState(() => _isActive = target.checked);
                  },
                },
              ),
            ]),
          div(classes: 'flex justify-end items-center pt-2', [
            button(
              type: ButtonType.submit,
              classes: 'btn btn-primary px-6 h-10 rounded-xl font-bold text-sm shadow-xs transition-all cursor-pointer',
              [.text('Save')],
            ),
          ]),
        ],
      ),
    );
  }
}
