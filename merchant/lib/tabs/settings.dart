import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';

class Settings extends StatelessComponent {
  const Settings({super.key});

  @override
  Component build(BuildContext context) {
    return div(
      classes:
          'p-8 text-gray-400 font-medium text-center flex-1 flex items-center justify-center',
      [
        .text(
          'Settings content coming soon!',
        ),
      ],
    );
  }
}
