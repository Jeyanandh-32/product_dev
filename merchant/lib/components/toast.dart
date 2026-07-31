import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:merchant/components/signal_component.dart';
import 'package:merchant/providers/toast_provider.dart';

class Toast extends SignalComponent {
  const Toast({super.key});

  @override
  SignalState<Toast> createState() => _ToastState();
}

class _ToastState extends SignalState<Toast> {
  @override
  Component buildSignal(BuildContext context) {
    final message = toastSignal.value;
    if (message == null) return div([]);

    return div(classes: 'toast toast-top toast-center z-[100]', [
      div(classes: 'alert alert-error text-white', [
        span([
          .text(message),
        ]),
      ]),
    ]);
  }
}
