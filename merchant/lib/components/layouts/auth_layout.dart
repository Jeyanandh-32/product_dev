import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class AuthLayout extends StatelessComponent {
  final String title;
  final String descriptionLine1;
  final String descriptionLine2;
  final Component formContent;
  final Component footerContent;
  const AuthLayout({
    super.key,
    required this.title,
    required this.descriptionLine1,
    required this.descriptionLine2,
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
          classes:
              'max-w-120 w-full mx-auto flex flex-col justify-center items-center px-6 md:px-0',
          [
            h1(classes: 'font-script text-primary text-[40px] font-normal', [
              .text('Branding'),
            ]),

            h1(classes: 'text-center text-3xl font-bold mt-4 mb-2', [
              .text(title),
            ]),

            h4(classes: 'text-gray-500 text-center mb-8', [
              .text(descriptionLine1),
              br(),
              .text(descriptionLine2),
            ]),

            div(classes: 'card bg-white shadow-sm w-full mb-8', [
              formContent,
            ]),

            footerContent,
          ],
        ),
      ],
    );
  }
}
