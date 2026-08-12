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
          'min-h-screen bg-white text-gray-900 flex flex-col items-center justify-center py-8 px-4 font-sans selection:bg-gray-900 selection:text-white',
      [
        div(
          classes: 'max-w-md w-full mx-auto flex flex-col items-center',
          [
            // Script Branding Logo
            h1(classes: 'font-script text-primary text-4xl font-normal mb-1', [
              .text('Branding'),
            ]),

            // Page Title
            h1(
              classes: 'text-center text-2xl md:text-3xl font-extrabold text-black tracking-tight mt-2 mb-1.5',
              [
                .text(title),
              ],
            ),

            // Subtitle Description
            p(classes: 'text-xs text-gray-500 font-medium text-center mb-6 max-w-xs', [
              .text(descriptionLine1),
              if (descriptionLine2.isNotEmpty) ...[
                .text(' '),
                .text(descriptionLine2),
              ],
            ]),

            // Form Body Container
            div(classes: 'w-full mb-6', [
              formContent,
            ]),

            // Footer Link
            footerContent,
          ],
        ),
      ],
    );
  }
}
