import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';

class Loading extends StatelessComponent {
  const Loading({super.key, this.text, this.fullScreen = true});

  final String? text;
  final bool fullScreen;

  @override
  Component build(BuildContext context) {
    return div(
      classes: fullScreen
          ? 'h-screen w-full flex flex-col justify-center items-center bg-neutral gap-2'
          : 'flex flex-col items-center justify-center h-full text-center text-gray-400 py-10 w-full gap-2',
      [
        span(classes: 'loading loading-spinner text-primary', []),
        if (text != null && text!.isNotEmpty) p([.text(text!)]),
      ],
    );
  }
}
