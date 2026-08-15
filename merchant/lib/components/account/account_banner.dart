import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_lucide/jaspr_lucide.dart';

class AccountBanner extends StatelessComponent {
  final String displayName;
  final String displayBusiness;
  final String displayEmail;
  final String displayWhatsapp;
  final String initials;
  final int activeStoreCount;

  const AccountBanner({
    super.key,
    required this.displayName,
    required this.displayBusiness,
    required this.displayEmail,
    required this.displayWhatsapp,
    required this.initials,
    required this.activeStoreCount,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes:
          'w-full rounded-2xl bg-white p-4.5 border border-border-medium shadow-2xs',
      [
        div(
          classes:
              'flex flex-col md:flex-row items-start md:items-center justify-between gap-4',
          [
            // Avatar & Main Details
            div(classes: 'flex items-center gap-4', [
              div(
                classes:
                    'relative w-14 h-14 rounded-lg bg-primary text-primary-content text-lg font-bold flex items-center justify-center border border-border-medium shrink-0',
                [
                  .text(initials),
                  div(
                    classes:
                        'absolute -bottom-1 -right-1 p-0.5 bg-emerald-500 rounded-full text-white shadow-2xs border border-white',
                    attributes: {'title': 'Verified Account'},
                    [
                      BadgeCheck(classes: 'w-3.5 h-3.5'),
                    ],
                  ),
                ],
              ),

              div(classes: 'space-y-0.5 min-w-0', [
                div(classes: 'flex items-center gap-2 flex-wrap', [
                  h2(
                    classes:
                        'text-base sm:text-lg font-bold tracking-tight truncate text-primary',
                    [.text(displayName)],
                  ),
                  span(
                    classes:
                        'px-2 py-0.5 rounded text-[11px] font-bold uppercase tracking-wider bg-emerald-50 text-emerald-700 border border-emerald-200',
                    [.text('Active Account')],
                  ),
                ]),

                p(
                  classes:
                      'text-xs sm:text-sm font-semibold text-gray-500 flex items-center gap-1.5 truncate',
                  [
                    Building2(
                      classes: 'w-3.5 h-3.5 text-gray-400 shrink-0',
                    ),
                    .text(displayBusiness),
                  ],
                ),

                div(
                  classes:
                      'flex items-center gap-3.5 text-xs sm:text-sm text-gray-500 pt-0.5 flex-wrap font-medium',
                  [
                    span(classes: 'flex items-center gap-1', [
                      Mail(classes: 'w-3.5 h-3.5 text-gray-400'),
                      .text(displayEmail),
                    ]),
                    span(classes: 'flex items-center gap-1', [
                      Phone(classes: 'w-3.5 h-3.5 text-emerald-600'),
                      .text(displayWhatsapp),
                    ]),
                  ],
                ),
              ]),
            ]),

            // Metrics Badges
            div(
              classes:
                  'flex items-center gap-3 w-full md:w-auto justify-between md:justify-end border-t md:border-t-0 border-border-light pt-3 md:pt-0',
              [
                div(
                  classes:
                      'px-4 py-2 rounded-lg bg-neutral/40 border border-border-light text-center',
                  [
                    p(
                      classes: 'text-xs text-gray-500 font-semibold',
                      [.text('Active Stores')],
                    ),
                    p(
                      classes: 'text-base font-bold text-primary',
                      [.text('$activeStoreCount')],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
