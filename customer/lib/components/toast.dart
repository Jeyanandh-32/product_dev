import 'package:customer/components/signal_component.dart';
import 'package:customer/signals/toast_signal.dart';
import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

class Toast extends SignalComponent {
  const Toast({super.key});

  @override
  SignalState<Toast> createState() => _ToastState();
}

class _ToastState extends SignalState<Toast> {
  @override
  Component buildSignal(BuildContext context) {
    final toast = customerToastSignal.value;
    if (toast == null) return div([]);

    final alertClass = switch (toast.type) {
      ToastType.success => 'alert-success',
      ToastType.error => 'alert-error',
      ToastType.warning => 'alert-warning',
      ToastType.info => 'alert-info',
    };

    return div(classes: 'toast toast-top toast-center z-100', [
      div(
        attributes: {'role': 'alert'},
        classes: 'alert $alertClass text-white shadow-lg font-medium',
        [
          span([
            .text(toast.message),
          ]),
        ],
      ),
    ]);
  }
}
