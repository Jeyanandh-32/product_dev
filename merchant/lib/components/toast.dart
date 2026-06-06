import 'package:jaspr/client.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr_riverpod/jaspr_riverpod.dart';
import 'package:merchant/providers/toast_provider.dart';

class Toast extends StatelessComponent {
  const Toast({super.key});

  @override
  Component build(BuildContext context) {
    final message = context.watch(toastProvider);
    if (message == null) return div([]);

    return div(classes: 'toast toast-top toast-center', [
      div(classes: 'alert alert-error text-white', [
        span([
          .text(message),
        ]),
      ]),
    ]);
  }
}
