import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// Clean authentication layout matching the Finch POS terminal aesthetic.
class AuthLayout extends StatelessComponent {
  final String? title;
  final String? descriptionLine1;
  final String? descriptionLine2;
  final Component formContent;
  final Component footerContent;

  const AuthLayout({
    super.key,
    this.title,
    this.descriptionLine1,
    this.descriptionLine2,
    required this.formContent,
    required this.footerContent,
  });

  @override
  Component build(BuildContext context) {
    return div(
      classes:
          'bg-neutral w-full min-h-screen flex flex-col justify-center py-10',
      [
        div(
          classes: 'max-w-110 w-full mx-auto flex flex-col justify-center items-center px-4 md:px-0',
          [
            div(
              classes: 'flex flex-col items-center mb-8 text-center',
              [
                div(
                  classes: 'w-14 h-14 rounded-2xl overflow-hidden shadow-2xs border border-border-medium mb-3',
                  [
                    img(
                      src: 'images/finch_app_icon_square.png',
                      width: 56,
                      height: 56,
                      classes: 'w-full h-full object-cover',
                    ),
                  ],
                ),
                div(
                  classes: 'flex items-center gap-2 mb-0.5',
                  [
                    span(
                      classes: 'font-script text-[42px] font-bold text-slate-900 leading-none select-none',
                      [.text('Finch')],
                    ),
                    span(
                      classes: 'text-xs font-black tracking-widest text-sky-600 bg-sky-50 border border-sky-200/80 px-2 py-0.5 rounded-md uppercase leading-none shadow-2xs select-none',
                      [.text('POS')],
                    ),
                  ],
                ),
                span(
                  classes: 'text-sm font-medium text-slate-500 mt-1',
                  [.text('Merchant Portal')],
                ),
                if (title case final heading? when heading.isNotEmpty)
                  h1(
                    classes: 'text-center text-xl font-bold text-slate-900 mt-4 mb-1 tracking-tight',
                    [.text(heading)],
                  ),
                if (descriptionLine1 case final desc? when desc.isNotEmpty)
                  h4(
                    classes:
                        'text-slate-500 text-center mb-2 text-sm font-normal',
                    [
                      .text(desc),
                      if (descriptionLine2 case final d2?
                          when d2.isNotEmpty) ...[
                        br(),
                        .text(d2),
                      ],
                    ],
                  ),
              ],
            ),
            div(
              classes: 'w-full bg-white rounded-3xl border border-border-medium shadow-[0_4px_16px_rgba(0,0,0,0.04)] p-7 mb-6',
              [
                formContent,
              ],
            ),
            footerContent,
          ],
        ),
      ],
    );
  }
}
