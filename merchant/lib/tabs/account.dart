import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';

class Account extends StatelessComponent {
  const Account({super.key});

  @override
  Component build(BuildContext context) {
    return div(
      classes:
          'p-8 text-gray-400 font-medium text-center flex-1 flex items-center justify-center',
      [
        .text(
          'Account content coming soon!',
        ),
      ],
    );
  }
}
