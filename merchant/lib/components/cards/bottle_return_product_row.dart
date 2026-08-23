import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/generated_icons/bottle_wine.dart';
import 'package:web/web.dart' as web;

class BottleReturnProductRow extends StatelessComponent {
  const BottleReturnProductRow({
    super.key,
    required this.product,
    required this.onToggle,
  });

  final Map<String, dynamic> product;
  final ValueChanged<bool> onToggle;

  @override
  Component build(BuildContext context) {
    final name = product['name'] as String? ?? '';
    final category = product['categoryName'] as String?;
    final price = (product['sellingPrice'] as num?)?.toDouble() ?? 0.0;
    final isReturnable = product['isReturnable'] as bool? ?? false;
    final imageUrl = product['imageUrl'] as String?;

    return div(
      classes:
          'flex items-center justify-between p-3 border ${isReturnable ? 'border-emerald-500/30 bg-emerald-500/[0.02]' : 'border-border-medium/70 bg-white'} rounded-xl hover:border-accent/40 transition-all duration-200 shadow-2xs',
      [
        div(classes: 'flex items-center gap-3 min-w-0 flex-1 pr-3', [
          if (imageUrl != null && imageUrl.isNotEmpty)
            div(
              classes:
                  'w-10 h-10 rounded-lg overflow-hidden bg-gray-100 shrink-0 border border-border-medium/60 shadow-2xs',
              [
                img(
                  src: imageUrl,
                  alt: name,
                  classes: 'w-full h-full object-cover block',
                ),
              ],
            )
          else
            div(
              classes:
                  'w-10 h-10 rounded-lg flex items-center justify-center shrink-0 ${isReturnable ? 'bg-emerald-500/10 text-emerald-600' : 'bg-neutral/70 text-gray-400'}',
              [
                BottleWine(classes: 'w-5 h-5'),
              ],
            ),
          div(classes: 'flex flex-col min-w-0 flex-1', [
            p(classes: 'font-medium text-sm text-primary truncate', [.text(name)]),
            div(classes: 'flex items-center gap-2 mt-0.5', [
              if (category != null && category.isNotEmpty)
                span(
                  classes:
                      'bg-neutral text-gray-600 text-[11px] font-medium px-2 py-0.5 rounded-md',
                  [.text(category)],
                ),
              span(
                classes: 'text-xs font-semibold text-gray-500',
                [.text('₹${price.toStringAsFixed(0)}')],
              ),
              if (isReturnable)
                span(
                  classes:
                      'hidden sm:inline-block text-[11px] font-medium text-emerald-600 bg-emerald-50 px-1.5 py-0.5 rounded',
                  [.text('₹10 Deposit Token')],
                ),
            ]),
          ]),
        ]),
        input(
          type: InputType.checkbox,
          classes:
              'toggle toggle-sm ${isReturnable ? 'toggle-success' : ''} hover:cursor-pointer',
          checked: isReturnable,
          events: {
            'change': (e) {
              final target = e.target as web.HTMLInputElement;
              onToggle(target.checked);
            },
          },
        ),
      ],
    );
  }
}
