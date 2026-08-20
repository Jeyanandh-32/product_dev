import 'package:flutter/material.dart';
import 'package:forui/forui.dart';
import 'package:gap/gap.dart';
import 'package:mix/mix.dart';
import 'package:models/models.dart';
import 'package:terminal/components/inventory/categories/modals/category_dialog_actions.dart';
import 'package:terminal/components/inventory/modals/modal_input_field.dart';
import 'package:terminal/components/inventory/modals/modal_switch.dart';
import 'package:terminal/signals/categories_signal.dart';
import 'package:terminal/signals/inventory_categories_signal.dart';

/// Modal dialog for adding a new category or editing an existing category.
class AddEditCategoryDialog extends StatefulWidget {
  final Category? category;
  const AddEditCategoryDialog({super.key, this.category});

  @override
  State<AddEditCategoryDialog> createState() => _AddEditCategoryDialogState();
}

class _AddEditCategoryDialogState extends State<AddEditCategoryDialog> {
  late String _name = widget.category?.name ?? '';
  late String _description = widget.category?.description ?? '';
  late String _imageUrl = widget.category?.imageUrl ?? '';
  late bool _isActive = widget.category?.isActive ?? true;
  bool _isSubmitting = false;

  Future<void> _handleSubmit() async {
    final nameTrimmed = _name.trim();
    if (nameTrimmed.isEmpty) {
      showFToast(context: context, alignment: .topCenter, title: const Text('Validation Error'), description: const Text('Category name is required.'));
      return;
    }

    final descVal = _description.trim();
    final imgVal = _imageUrl.trim();
    setState(() => _isSubmitting = true);

    try {
      if (widget.category != null) {
        await CategoryActions.update(
          id: widget.category!.id,
          name: nameTrimmed,
          isActive: _isActive,
          description: descVal.isNotEmpty ? descVal : null,
          imageUrl: imgVal.isNotEmpty ? imgVal : null,
        );
      } else {
        await CategoryActions.create(
          name: nameTrimmed,
          description: descVal.isNotEmpty ? descVal : null,
          imageUrl: imgVal.isNotEmpty ? imgVal : null,
        );
      }
      refreshCategoriesSignal();
      if (!mounted) return;
      Navigator.of(context).pop();
      showFToast(
        context: context,
        alignment: .topCenter,
        title: const Text('Success'),
        description: Text(widget.category != null ? 'Category updated.' : 'Category created.'),
      );
    } catch (e) {
      if (!mounted) return;
      showFToast(context: context, alignment: .topCenter, title: const Text('Error'), description: Text(e.toString()));
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.category != null;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.88;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Color(0xFFE2E8F0))),
      backgroundColor: const Color(0xFFFFFFFF),
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: 480, maxHeight: maxHeight),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(isEditing ? 'Edit Category' : 'Add New Category', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: Color(0xFF0F172A))),
                  MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: PressableBox(
                      onPress: () => Navigator.of(context).pop(),
                      style: BoxStyler().width(32).height(32).borderRadiusAll(const Radius.circular(999)).borderAll(color: const Color(0xFFE2E8F0)).color(const Color(0xFFFFFFFF)).alignment(Alignment.center).onHovered(BoxStyler().color(const Color(0xFFF8FAFC))),
                      child: const Icon(FLucideIcons.x, size: 16, color: Color(0xFF64748B)),
                    ),
                  ),
                ],
              ),
              const Gap(16),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ModalInputField(label: 'Category Name', hint: 'e.g. Hot Beverages', value: _name, isRequired: true, onChanged: (v) => _name = v),
                      const Gap(14),
                      ModalInputField(label: 'Description (Optional)', hint: 'e.g. Coffee, tea, hot cocoa...', value: _description, onChanged: (v) => _description = v),
                      const Gap(14),
                      ModalInputField(label: 'Image URL (Optional)', hint: 'https://images.unsplash.com/...', value: _imageUrl, onChanged: (v) => _imageUrl = v),
                      const Gap(14),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(color: const Color(0xFFF8FAFC), borderRadius: BorderRadius.circular(12), border: Border.all(color: const Color(0xFFE2E8F0))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Active Status', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Color(0xFF0F172A))),
                                  Text(_isActive ? 'Category is visible in POS catalog' : 'Hidden from POS catalog', style: const TextStyle(fontSize: 11.5, color: Color(0xFF64748B)), overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                            const Gap(8),
                            ModalSwitch(value: _isActive, onChanged: (v) => setState(() => _isActive = v)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const Gap(18),
              CategoryDialogActions(isSubmitting: _isSubmitting, isEditing: isEditing, onSubmit: _handleSubmit),
            ],
          ),
        ),
      ),
    );
  }
}
