import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart' hide List, Map, Router;
import 'package:models/models.dart';

class ProfileOverviewCard extends StatelessComponent {
  final Customer customer;

  const ProfileOverviewCard({
    super.key,
    required this.customer,
  });

  @override
  Component build(BuildContext context) {
    final initialChar = customer.name.isNotEmpty
        ? customer.name[0].toUpperCase()
        : 'C';

    return div(
      classes:
          'bg-white rounded-3xl border border-gray-200/90 p-6 sm:p-8 shadow-xs flex flex-col sm:flex-row items-center sm:items-start gap-5',
      [
        // Avatar Pill
        div(
          classes:
              'w-20 h-20 rounded-full bg-gray-900 text-white font-black text-2xl flex items-center justify-center shrink-0 shadow-md border-4 border-gray-100',
          [
            .text(initialChar),
          ],
        ),

        div(classes: 'flex flex-col gap-1 text-center sm:text-left flex-1', [
          h2(classes: 'text-2xl font-black text-black tracking-tight', [
            .text(customer.name),
          ]),
          div(
            classes:
                'flex flex-wrap items-center justify-center sm:justify-start gap-2.5 mt-1',
            [
              div(
                classes:
                    'inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-gray-100 text-gray-700 font-semibold text-xs border border-gray-200/80',
                [
                  Phone(classes: 'w-3.5 h-3.5 text-gray-500'),
                  .text(customer.mobileNumber),
                ],
              ),
              div(
                classes:
                    'inline-flex items-center gap-1.5 px-3 py-1 rounded-full bg-emerald-50 text-emerald-700 font-semibold text-xs border border-emerald-200/60',
                [
                  ShieldCheck(classes: 'w-3.5 h-3.5 text-emerald-600'),
                  .text('Verified Customer'),
                ],
              ),
            ],
          ),
        ]),
      ],
    );
  }
}
