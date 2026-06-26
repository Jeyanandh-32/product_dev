import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:merchant/components/fields/form_field.dart';
import 'package:merchant/components/modals/modal.dart';
import 'package:merchant/providers/products_provider.dart';
import 'package:merchant/providers/toast_provider.dart';
import 'package:merchant/providers/ui_providers.dart';
import 'package:models/models.dart';
import 'package:web/web.dart';

class UpdateStockModal extends StatefulComponent {
  const UpdateStockModal({super.key, required this.product});

  final Product product;

  @override
  State<UpdateStockModal> createState() => _UpdateStockModalState();
}

class _UpdateStockModalState extends State<UpdateStockModal> {
  late String _quantity;
  late String _lowStockThreshold;
  late bool _stockMonitor;

  @override
  void initState() {
    super.initState();
    final s = component.product.stock;
    _quantity = s != null ? '${s.quantity}' : '0';
    _lowStockThreshold = s != null ? '${s.lowStockThreshold}' : '0';
    _stockMonitor = s?.stockMonitor ?? false;
  }

  void _onSubmit(BuildContext context, Event e) {
    e.preventDefault();

    final quantity = int.tryParse(_quantity.trim());
    final lowStockThreshold = int.tryParse(_lowStockThreshold.trim());

    if (_stockMonitor && lowStockThreshold == null) {
      context.read(toastProvider.notifier).state =
          'Low Stock Threshold is required when Stock Monitor is enabled.';
      Future.delayed(const Duration(seconds: 3), () {
        context.read(toastProvider.notifier).state = null;
      });
      return;
    }

    context.read(activeModalProvider.notifier).state = ActiveModal.none;

    if (component.product.stock != null) {
      context.read(productsProvider.notifier).updateStock(
            stockId: component.product.stock!.id,
            productId: component.product.id,
            quantity: quantity,
            lowStockThreshold: lowStockThreshold,
            stockMonitor: _stockMonitor,
          );
    }
  }

  @override
  Component build(BuildContext context) {
    return Modal(
      title: 'Update Stock - ${component.product.name}',
      child: form(
        method: FormMethod.post,
        events: {'submit': (e) => _onSubmit(context, e)},
        [
          FormField(
            id: 'quantity',
            labelText: 'Stock Quantity',
            type: InputType.number,
            attributes: {
              'placeholder': '100',
              'required': '',
              'min': '0',
              'value': _quantity,
            },
            hintText: 'Stock quantity is required.',
            onChange: (value) => _quantity = value as String,
          ),
          
          // Stock Monitor Toggle
          div(
            classes: 'form-control mb-4 flex flex-row items-center gap-3',
            [
              p(
                classes: 'text-[14px] font-semibold text-gray-500',
                [.text('Stock Monitor')],
              ),
              input(
                type: InputType.checkbox,
                classes:
                    'toggle ${_stockMonitor ? 'toggle-success' : ''} hover:cursor-pointer',
                checked: _stockMonitor,
                events: {
                  'change': (e) {
                    final target = e.target as HTMLInputElement;
                    setState(() {
                      _stockMonitor = target.checked;
                    });
                  },
                },
              ),
            ],
          ),

          FormField(
            id: 'lowStockThreshold',
            labelText: 'Low Stock Threshold',
            type: InputType.number,
            attributes: {
              'placeholder': '10',
              if (_stockMonitor) 'required': '',
              'min': '0',
              'value': _lowStockThreshold,
            },
            hintText: 'Low stock threshold is required.',
            onChange: (value) => _lowStockThreshold = value as String,
          ),
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
