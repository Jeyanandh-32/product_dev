import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';

class Loading extends StatelessComponent {
  const Loading({super.key});

  @override
  Component build(BuildContext context) {
    return div(
      classes: 'h-screen w-full flex justify-center items-center bg-neutral',
      [
        span(classes: 'loading loading-spinner text-primary', []),
      ],
    );
  }
}
