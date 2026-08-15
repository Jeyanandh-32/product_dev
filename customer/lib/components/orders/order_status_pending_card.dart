import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

/// Error and pending verification state card for order status page.
class OrderStatusPendingCard extends StatelessComponent {
  final String reference;

  const OrderStatusPendingCard({super.key, required this.reference});

  @override
  Component build(BuildContext context) {
    return div(
      classes:
          'min-h-[60vh] flex flex-col items-center justify-center gap-4 text-center px-4',
      [
        div(
          classes:
              'w-16 h-16 rounded-full bg-red-50 text-red-500 flex items-center justify-center text-2xl font-bold',
          [
            .text('⚠️'),
          ],
        ),
        h1(classes: 'text-2xl font-extrabold text-black', [
          .text('Payment Status Pending'),
        ]),
        p(classes: 'text-sm text-gray-500 max-w-md', [
          .text(
            'We are verifying your transaction with PhonePe. Reference: $reference',
          ),
        ]),
        button(
          classes:
              'mt-4 px-6 py-3 rounded-xl bg-black text-white text-sm font-bold cursor-pointer border-0',
          onClick: () => Router.of(context).push('/'),
          [
            .text('Return to Store Menu'),
          ],
        ),
      ],
    );
  }
}
