import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';

class CenteredMessage extends StatelessComponent {
  const CenteredMessage({super.key, required this.message});

  final String message;

  @override
  Component build(BuildContext context) {
    return div(
      classes:
          'flex flex-col items-center justify-center h-full text-center text-gray-400 py-10 w-full',
      [
        .text(message),
      ],
    );
  }
}
